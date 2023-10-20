import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/home_screen.dart';
import 'package:project_one/screens/app_screens/overseas_screen.dart';
import 'package:project_one/screens/app_screens/previousyear_screen.dart';
import 'package:project_one/screens/authentication/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context) {
    PageRouteBuilder<dynamic> customPageRouteBuilder(
      Widget page,
    ) {
      return PageRouteBuilder<dynamic>(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          });
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

    Drawer buildDrawer(BuildContext context) {
      return Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 0, 136, 255),
                    ),
                    child: DrawerHeader(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder<String?>(
                        future: getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                color: Colors.lightBlue,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final username = snapshot.data;

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                              child: Text(
                                username!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Dashboard'),
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacement(customPageRouteBuilder(
                        const HomeScreen(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.question_answer_outlined),
                    title: const Text('Previous Year Question Papers'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        customPageRouteBuilder(
                          const PreviousYearScreen(isquestionpaper: true),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notes_sharp),
                    title: const Text('Notes'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        customPageRouteBuilder(
                          const PreviousYearScreen(isquestionpaper: false),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_center_outlined),
                    title: const Text('Overseas Help'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const OverseasScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                FirebaseAuth.instance.signOut().then((value) {
                  prefs.setBool('userLoggedIn', false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Successfully logged out'),
                    ),
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      );
    }

    return buildDrawer(context);
  }
}
