import 'package:firebase_auth_training/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/auth_page.dart';
import '../pages/home_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (auth.user == null) {
      return const AuthPage();
    } else {
      return const HomePage();
    }
  }
}
