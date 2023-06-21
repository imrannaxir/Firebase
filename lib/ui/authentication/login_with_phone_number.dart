import 'package:firebase/toast/toast.dart';
import 'package:firebase/ui/authentication/verify_code.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  //
  //
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final phoneNumberController = TextEditingController();

  //
  //
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: Colors.purple,
      //   title: const Text(
      //     'Phone Authentication',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 20,
      //       fontStyle: FontStyle.italic,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: loginWithPhoneNumber(size),
    );
  }

  Widget loginWithPhoneNumber(size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: LoginWithPhoneNumberClipper(),
            child: Container(
              color: Colors.pink,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.08,
                width: size.width * 0.8,
                child: TextFormField(
                  controller: phoneNumberController,
                  //keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '+92 234 3455 786',
                  ),
                ),
              ),
              const SizedBox(height: 80),
              RoundButton(
                title: 'Login',
                loading: loading,
                myOnTap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.text,
                    verificationCompleted: (context) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (error) {
                      Toast().toastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return VerifyCodeScreen(
                              verificationId: verificationId,
                            );
                          },
                        ),
                      );
                      setState(() {
                        loading = true;
                      });
                    },
                    codeAutoRetrievalTimeout: (error) {
                      Toast().toastMessage(error.toString());
                      setState(() {
                        loading = true;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginWithPhoneNumberClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.5);

    final firstControlPoint = Offset(size.width * 0.25, size.height * 0.7);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.3);
    final secondEndPoint = Offset(size.width, size.height * 0.5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(LoginWithPhoneNumberClipper oldClipper) => false;
}
