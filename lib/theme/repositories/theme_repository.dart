import 'package:local_storage_service/local_storage_service.dart';

class ThemeRepository with LocalStorageMixin {
  static const String IS_DARK_THEME = 'IS_DARK_THEME';
  static const String IS_OFFLINE = 'IS_OFFLINE';

  Future<bool> getIsDark() async {
    try{
      final isDark = readValue<bool>(IS_DARK_THEME);
      return isDark;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<void> setIsDark(bool value) async => await storeValue<bool>(IS_DARK_THEME, value);

}