import 'dart:async';
import 'package:firebase/firestore/firestore_list_screen.dart';
import 'package:firebase/ui/authentication/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogon(BuildContext context) {
    //
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        // Anonymous Function
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FirestoreListScreen(),
          ),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        // Anonymous Function
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        ),
      );
    }
  }
}
