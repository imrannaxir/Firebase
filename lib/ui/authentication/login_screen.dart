import 'package:firebase/firestore/firestore_list_screen.dart';
import 'package:firebase/toast/toast.dart';
import 'package:firebase/ui/authentication/login_with_phone_number.dart';
import 'package:firebase/ui/forgot_password.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  //
  //
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Learn Here New Widget
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: LoginScreenClipper(),
                child: Container(
                  color: Colors.pink,
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.09,
                      width: size.width * 0.9,
                      child: TextFormField(
                        controller: _mailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          // prefixIcon: const Icon(Icons.password),
                          icon: const Icon(Icons.mail),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: size.height * 0.09,
                      width: size.width * 0.9,
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Give Your Password';
                          } else if (value.length < 6) {
                            return 'Should Be At Least 6 Characters';
                          } else if (value.length > 15) {
                            return 'Should Not Be More Than 15 Characters';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          //prefixIcon: const Icon(Icons.mail),
                          icon: const Icon(Icons.password),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'Login',
                loading: loading,

                myOnTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    await _auth
                        .signInWithEmailAndPassword(
                      email: _mailController.text.toString(),
                      password: _passwordController.text.toString(),
                    )
                        .then((value) {
                      debugPrint('Data Added');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Data Added Successfully',
                          ),
                        ),
                      );
                      Toast().toastMessage(value.user!.email.toString());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const FirestoreListScreen();
                          },
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                    }).onError(
                      (error, stackTrace) {
                        debugPrint('Something went wrong!');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Something went wrong!',
                            ),
                          ),
                        );
                        Toast().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      },
                    );
                  }
                },

                // myOnTap: () async {
                //   try {
                //     await _auth.signInWithEmailAndPassword(
                //       email: mailController.text,
                //       password: passwordController.text.toString(),
                //     );

                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text(
                //           'Successfull',
                //         ),
                //       ),
                //     );
                //   } on FirebaseAuthException catch (e) {
                //     if (e.code == 'weak-password') {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text(
                //             'The password provided is too weak.',
                //           ),
                //         ),
                //       );
                //     } else if (e.code == 'email-already-in-use') {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text(
                //             'The account already exit from the account.',
                //           ),
                //         ),
                //       );
                //     }
                //   } catch (e) {
                //     debugPrint('Error');
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text(
                //           e.toString(),
                //         ),
                //       ),
                //     );
                //   }
                // },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password ?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginWithPhoneNumber();
                      },
                    ),
                  );
                },
                child: Container(
                  height: size.height * 0.08,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Text(
                      'Login With Phone',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  // child: Center(
                  //   child: loading
                  //       ? const CircularProgressIndicator(
                  //           strokeWidth: 3,
                  //           color: Colors.white,
                  //         )
                  //       : const Text(
                  // 'Login With Phone',
                  // style: TextStyle(
                  //   color: Colors.white,
                  //   fontSize: 20,
                  //   fontStyle: FontStyle.italic,
                  //             // fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
