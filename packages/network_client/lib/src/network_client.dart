import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:network_client/src/network_exception.dart';

enum RequestContentType { formUrlEncoded, applicationJson, formData }

/// Purpose of this class is to abstract the network connection from the app.
/// So if there is an "issue" with dio in the future, we can just switch the implementation
/// here and not within all the apps that use it.
class NetworkClient {
  final Dio _dio = Dio();

  String? _baseUrl;

  NetworkClient._internal();

  static final NetworkClient _instance = NetworkClient._internal();

  static NetworkClient get instance => _instance;

  String? get baseUrl => _baseUrl;

  setBaseUrl(String baseUrl, {useHttps = false}) {
    /// if the baseUrl passed doesn't have the http prefix, we'll add it
    if(!baseUrl.startsWith('http://') && !baseUrl.startsWith('https://')){
      if(useHttps)
        baseUrl = 'https://$_baseUrl';
      else
        baseUrl = 'http://$_baseUrl';
    }

    // remove trailing slash from url
    if (baseUrl.endsWith('/')) baseUrl = baseUrl.substring(0, baseUrl.length - 1);

    _baseUrl = baseUrl;
    _dio.options = _dio.options.copyWith(baseUrl: baseUrl, headers: {});
  }

  _setContentType(RequestContentType type) {
    switch (type) {
      case RequestContentType.applicationJson:
        _dio.options.contentType = "application/json";
        break;
      case RequestContentType.formUrlEncoded:
        _dio.options.contentType = Headers.formUrlEncodedContentType;
        break;
      case RequestContentType.formData:
        _dio.options.contentType = "multipart/form-data";
        break;
      default:
        throw ("Unknown content type");
    }
  }

  setPermanentHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  removeHeaders() {
    _dio.options.headers = {};
  }

  _handleDioResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response.data;
      case HttpStatus.badRequest:
        throw NetworkException('Bad request', response.statusCode);
      case HttpStatus.unauthorized:
        throw NetworkException('Unauthorized', response.statusCode);
      case HttpStatus.forbidden:
        throw NetworkException('Forbidden', response.statusCode);
      case HttpStatus.notFound:
        throw NetworkException('Resource not found', response.statusCode);
      case HttpStatus.internalServerError:
        continue a;
      a:
      default:
        throw NetworkException(
            'Something went wrong while communicating to the server',
            response.statusCode);
    }
  }

  _solveDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.connectTimeout:
        throw NetworkException('Could not communicate with the server',
            HttpStatus.networkConnectTimeoutError);
      case DioErrorType.other:
        if (error.message.contains('SocketException')) {
          throw NetworkException('You do not have internet connection',
              HttpStatus.connectionClosedWithoutResponse);
        }
        continue a;
      case DioErrorType.response:
        _handleDioResponse(error.response!);
        break;
      a:
      default:
        throw NetworkException('Something went wrong', -1);
    }
  }

  Future<dynamic> get(String path,
      {RequestContentType contentType = RequestContentType.applicationJson,
      Map<String, dynamic> queryParam = const {}}) async {
    _setContentType(contentType);

    try {
      final response =
          _handleDioResponse(await _dio.get(path, queryParameters: queryParam));
      return response;
    } on DioError catch (e) {
      _solveDioError(e);
    }
  }

  Future<dynamic> delete(String path,
      {RequestContentType contentType = RequestContentType.applicationJson,
      Map<String, dynamic> queryParam = const {}}) async {
    _setContentType(contentType);

    try {
      final response = _handleDioResponse(
          await _dio.delete(path, queryParameters: queryParam));
      return response;
    } on DioError catch (e) {
      _solveDioError(e);
    }
  }

  Future<dynamic> post(String path,
      {dynamic body,
      RequestContentType contentType = RequestContentType.applicationJson,
      Map<String, dynamic> queryParam = const {}}) async {
    _setContentType(contentType);

    try {
      final response = _handleDioResponse(
          await _dio.post(path, data: body, queryParameters: queryParam));
      return response;
    } on DioError catch (e) {
      _solveDioError(e);
    }
  }

  Future<dynamic> put(String path,
      {dynamic body,
      RequestContentType contentType = RequestContentType.applicationJson,
      Map<String, dynamic> queryParam = const {}}) async {
    _setContentType(contentType);

    try {
      final response = _handleDioResponse(
          await _dio.put(path, data: body, queryParameters: queryParam));
      return response;
    } on DioError catch (e) {
      _solveDioError(e);
    }
  }

  Future<dynamic> download(
    String url,
    String savePath,
  ) async {
    try {
      Response response = await _dio.download(url, savePath,
          options: Options(
            receiveDataWhenStatusError: false,
          ));
      return response;
    } catch (e) {}
  }
}
