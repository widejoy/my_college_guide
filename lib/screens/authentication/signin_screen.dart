// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/authentication/reset_password.dart';
import 'package:project_one/screens/authentication/signup_screen.dart';
import 'package:project_one/screens/authentication/widgets/form.dart';
import 'package:project_one/screens/app_screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  void signin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('userLoggedIn', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        await user!.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'Please verify your email before logging in. Check your email for a verification link.',
            ),
          ),
        );
      }
    } catch (error) {
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error: $error'),
        ),
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  Future<String?> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        return (userDoc.data() as Map<String, dynamic>)['username'];
      }
    }
    return null;
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isloading = false;
  Row signupoptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Dont have an account?',
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const Signup();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }

  Future<void> _clearFields() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    );
    _email.clear();
    _password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple,
                Colors.purpleAccent,
                Color.fromARGB(255, 28, 119, 193),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.20,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Image.asset(
                      width: 400,
                      height: 400,
                      "assets/images/placeholder-image.png",
                      color: Colors.white,
                    ),
                    auth('Email', Icons.email_outlined, false, _email),
                    const SizedBox(
                      height: 16,
                    ),
                    auth('password', Icons.lock_outline_rounded, true,
                        _password),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const ResetPass();
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );

                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  transformHitTests: true,
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: const Text('Forgot Password?',
                            style: TextStyle(color: Colors.white70),
                            textAlign: TextAlign.right),
                      ),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(10),
                        fixedSize: MaterialStatePropertyAll(
                          Size(1000, 50),
                        ),
                        overlayColor: MaterialStatePropertyAll(Colors.white),
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (!isloading) {
                          setState(() {
                            isloading = true;
                          });
                          signin();
                        }
                      },
                      child: !isloading
                          ? const Text(
                              'Log In',
                              style: TextStyle(color: Colors.black),
                            )
                          : const CircularProgressIndicator(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    signupoptions()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
