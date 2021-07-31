import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin LocalStorageMixin {
  final _secureStorage = FlutterSecureStorage();

  Future<void> storeSecureValue(String key, String value) async => await _secureStorage.write(key: key, value: value);

  Future<void> deleteSecureValue(String key) async =>
      await _secureStorage.delete(key: key);

  Future<String> readSecureValue(String key) async {
    if (await _secureStorage.containsKey(key: key)) {
      return (await _secureStorage.read(key: key))!;
    }
    throw Exception('$key not found in secure storage');
  }

  Future<void> storeValue<T>(String key, T value) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    switch(T){
      case String:
        await _sharedPreferences.setString(key, value as String);
        break;
      case int:
        await _sharedPreferences.setInt(key, value as int);
        break;
      case double:
        await _sharedPreferences.setDouble(key, value as double);
        break;
      case bool:
        await _sharedPreferences.setBool(key, value as bool);
        break;
    }
  }

  Future<T> readValue<T>(String key) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    if(!_sharedPreferences.containsKey(key)){
      throw Exception('$key not found in storage');
    }

    switch(T){
      case String:
        return (_sharedPreferences.getString(key) as T?)!;
      case int:
        return (_sharedPreferences.getInt(key) as T?)!;
      case double:
        return (_sharedPreferences.getDouble(key) as T?)!;
      case bool:
        return (_sharedPreferences.getBool(key) as T?)!;
      default:
        throw Exception('$T not supported for local storage');
    }
  }

  Future<void> deleteValue(String key) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.remove(key);
  }


}
