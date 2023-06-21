import 'package:firebase/toast/toast.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  /*
  
  */

  bool loading = false;
  final _emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Forgot Password Screen',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 70),
            SizedBox(
              height: size.height * 0.09,
              width: size.width * 0.9,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  icon: Icon(Icons.email_outlined),
                ),
              ),
            ),
            const SizedBox(height: 50),
            RoundButton(
              loading: loading,
              title: 'Forgot',
              myOnTap: () {
                setState(() {
                  loading = true;
                });
                auth
                    .sendPasswordResetEmail(
                        email: _emailController.text.toString())
                    .then((value) {
                  Toast().toastMessage(
                      'We have sent you an email to recover password/n Please check email !');

                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Toast().toastMessage(error.toString());

                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
