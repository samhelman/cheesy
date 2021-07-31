import 'package:base_flutter_project/env/base_config.dart';

class StagingConfig implements BaseConfig {
  String get apiHost => throw('Staging api host undefined');

  bool get reportErrors => true;

  bool get trackEvents => false;

  bool get useHttps => true;
}