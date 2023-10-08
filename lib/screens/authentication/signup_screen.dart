// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/authentication/signin_screen.dart';
import 'package:project_one/screens/authentication/widgets/form.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordretype = TextEditingController();
  bool isloading = false;

  String _errorText = "";

  Future<void> signup() async {
    setState(() {
      isloading = true;
    });
    if (await _validateFields()) {
      try {
        UserCredential authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );

        await authResult.user!.sendEmailVerification();

        createUserProfile(authResult.user!.uid, _username.text, _email.text);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SignIn(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
                'Account created. Please check your email for verification.'),
          ),
        );
      } catch (error) {
        _clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error: ${error.toString()}'),
          ),
        );
      }
    }
    setState(() {
      isloading = false;
    });
  }

  Future<void> _clearFields() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _username.clear();
    _email.clear();
    _password.clear();
    _passwordretype.clear();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(
      String userId, String username, String email) async {
    await _firestore.collection('users').doc(userId).set({
      'username': username,
      'email': email,
      'QpPosts': [],
      "downvoted": [],
      "favs": [],
      "upvoted": []
    });
  }

  bool _isPasswordComplex(String password) {
    return password.length >= 8;
  }

  bool _isUsernameValid(String username) {
    return !username.contains(' ');
  }

  Future<bool> _validateFields() async {
    final email = _email.text.trim();
    final password = _password.text;
    final username = _username.text.trim();
    final data = await _firestore.collection('users').get();
    for (var i in data.docs) {
      final check = i["username"];

      if (check == username) {
        setState(() {
          _errorText = "Username aleredy taken";
        });
        return false;
      }
    }
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _passwordretype.text.isEmpty) {
      setState(() {
        _errorText = "Please fill in all fields.";
      });
      _clearFields();
      return false;
    } else if (!_isPasswordComplex(password)) {
      setState(() {
        _errorText = "Password must be at least 8 characters long.";
      });
      _clearFields();
      return false;
    } else if (!_isUsernameValid(username)) {
      setState(() {
        _errorText = "Username cannot contain spaces.";
      });
      _clearFields();
      return false;
    } else if (password != _passwordretype.text) {
      setState(() {
        _errorText = "Passwords do not match.";
      });
      _clearFields();
      return false;
    } else {
      setState(() {
        _errorText = "";
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        title: const Text(
          'SignUp',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
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
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    auth('username', Icons.supervised_user_circle_outlined,
                        false, _username),
                    const SizedBox(
                      height: 16,
                    ),
                    auth('email', Icons.email_outlined, false, _email),
                    const SizedBox(
                      height: 16,
                    ),
                    auth('password', Icons.lock_outline_rounded, true,
                        _password),
                    const SizedBox(
                      height: 16,
                    ),
                    auth('retype password', Icons.password_outlined, true,
                        _passwordretype),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      _errorText,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      autofocus: true,
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(10),
                        fixedSize: MaterialStatePropertyAll(
                          Size(1000, 50),
                        ),
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        overlayColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      onPressed: () async {
                        isloading ? null : await signup();
                      },
                      child: !isloading
                          ? const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
