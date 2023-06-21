import 'package:firebase/firestore/firestore_list_screen.dart';
import 'package:firebase/toast/toast.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({
    required this.verificationId,
    super.key,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  //
  //
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final codeVerifyController = TextEditingController();

  //
  //
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.purple,
      //   title: const Text(
      //     'Verify Code',
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
            clipper: VerifyClipper(),
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
                  controller: codeVerifyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '6 Digit Code',
                  ),
                ),
              ),
              const SizedBox(height: 80),
              RoundButton(
                title: 'Verify',
                loading: loading,
                myOnTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: codeVerifyController.text.toString(),
                  );
                  try {
                    await auth.signInWithCredential(credential);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const FirestoreListScreen();
                        },
                      ),
                    );
                  } catch (error) {
                    Toast().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VerifyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width / 4, size.height * 0.5, size.width / 2, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.7, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(VerifyClipper oldClipper) {
    return false;
  }
}
