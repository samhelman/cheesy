import 'package:base_flutter_project/authentication/authentication.dart';
import 'package:base_flutter_project/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocalizationService.of(context)!.translate('home_page.page_title'))),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                final userId = context.select(
                  (AuthenticationCubit bloc) => bloc.state.user.id,
                );
                return Text('UserID: $userId');
              },
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                context.read<AuthenticationCubit>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
