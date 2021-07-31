import 'package:base_flutter_project/theme/bloc/theme_cubit.dart';
import 'package:base_flutter_project/theme/models/app_theme.dart';
import 'package:base_flutter_project/theme/repositories/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeProvider extends StatelessWidget {
  final child;

  const ThemeProvider({Key? key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(
        ThemeRepository(),
      )..init(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Theme(
                data: AppThemes.defaultThemeData(state.isDark ? Brightness.dark : Brightness.light),
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
