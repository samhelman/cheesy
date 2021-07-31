import 'package:base_flutter_project/env/base_config.dart';

class ProdConfig implements BaseConfig {
  String get apiHost => throw('Prod api host undefined');

  bool get reportErrors => true;

  bool get trackEvents => true;

  bool get useHttps => true;
}