import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:base_flutter_project/app.dart';
import 'package:base_flutter_project/env/environment.dart';
import 'package:flutter/material.dart';
import 'package:network_client/network_client.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// set up environment to be used
    const String environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: Environment.DEV,
    );
    Environment().initConfig(environment);

    // todo: create a firebase project before uncommenting this line
    /// Once your Android app has been registered, download the configuration
    /// file from the Firebase Console (the file is called google-services.json).
    /// Add this file into the android/app directory within your Flutter project.
    ///
    /// Next you must add the file to the project using Xcode (adding manually
    /// via the filesystem won't link the file to the project). Using Xcode,
    /// open the project's ios/{projectName}.xcworkspace file.
    /// Right click Runner from the left-hand side project navigation within
    /// Xcode and select "Add files".
    /// Select the GoogleService-Info.plist file you downloaded,
    /// and ensure the "Copy items if needed" checkbox is enabled
    // await FirebaseService.instance.init();
    runApp(
      App(
        authenticationRepository: DjangoApiAuthenticationRepository(
            client: NetworkClient.instance
              ..setBaseUrl(
                Environment().config.apiHost,
                useHttps: Environment().config.useHttps,
              ),
            loginPath: '/userlogin/'),
      ),
    );
  },
      // todo: remove this and uncomment line below when firebase project has been created
      (o, s) {
    print('*** error ****');
    print(o);
    print('*** stacktrace ****');
    print(s);
    print('\n\n This print means firebase was not set up for this project');
  }
      // FirebaseService.instance.logError
      );
}
