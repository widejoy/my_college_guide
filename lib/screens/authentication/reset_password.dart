import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/authentication/signin_screen.dart';
import 'package:project_one/screens/authentication/widgets/form.dart';

class ResetPass extends StatelessWidget {
  const ResetPass({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _email = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        title: const Text(
          'Reset Password',
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
                    auth('email', Icons.email_outlined, false, _email),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
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
                      onPressed: () {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: _email.text)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.black,
                              content: Text(
                                  'A password reset mail has been sent to your email'),
                            ),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ),
                          );
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Error: ${error.toString()}'),
                            ),
                          );
                        });
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
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
