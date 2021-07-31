import 'package:base_flutter_project/env/base_config.dart';

class DevConfig implements BaseConfig {
  String get apiHost => throw('Dev api host undefined');

  bool get reportErrors => false;

  bool get trackEvents => false;

  bool get useHttps => false;
}