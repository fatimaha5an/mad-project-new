import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify/presentation/pages/home/pages/home.dart';
import 'package:spotify/presentation/pages/splash.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if user is logged in
            return const RootPage();
          } else {
            //if the user isnt logged in
            return const SplashPage();
          }
        },
      ),
    );
  }
}
