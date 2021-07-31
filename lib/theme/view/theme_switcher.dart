import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (oldState, newState) => oldState.isDark != newState.isDark,
      builder: (context, state) => SwitchListTile(
        secondary: const Icon(Icons.brightness_2),
        title: const Text("Dark Theme"),
        value: state.isDark,
        onChanged: (bool value) => context.read<ThemeCubit>().toggleIsDark(),
      ),
    );
  }
}