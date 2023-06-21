import 'package:firebase/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  //
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    splashServices.isLogon(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'SPLASH SCREEN',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: mySplashScreen(),
    );
  }

  Widget mySplashScreen() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.pink,
      ),

      // child: Text(
      //   'Firebase Tutorials',
      //   style: TextStyle(
      //     color: Colors.black,
      //     fontSize: 24,
      //     fontStyle: FontStyle.italic,
      //   ),
      // ),
    );
  }
}
