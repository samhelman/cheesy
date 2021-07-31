import 'package:base_flutter_project/theme/repositories/theme_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeCubit(this._themeRepository)
      : super(ThemeState());

  init() async {
    final isDark = await _themeRepository.getIsDark();
    emit(state.copyWith(isDark: isDark));
  }

  toggleIsDark() {
    _themeRepository.setIsDark(!state.isDark);
    emit(state.copyWith(isDark: !state.isDark));
  }
}