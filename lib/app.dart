import 'package:authentication_repository/authentication_repository.dart';
import 'package:base_flutter_project/authentication/authentication.dart';
import 'package:base_flutter_project/home/home.dart';
import 'package:base_flutter_project/login/login.dart';
import 'package:base_flutter_project/services/localization_service.dart';
import 'package:base_flutter_project/splash/splash.dart';
import 'package:base_flutter_project/theme/view/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationCubit(
          authenticationRepository: authenticationRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    context.read<AuthenticationCubit>().tryAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// This delegate uses strings from json under assets/18n/locale.json
      localizationsDelegates: [LocalizationService.delegate],
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return ThemeProvider(
          child: BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    HomePage.route(),
                    (route) => false,
                  );
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    LoginPage.route(),
                    (route) => false,
                  );
                  break;
                default:
                  break;
              }
            },
            child: child,
          ),
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
