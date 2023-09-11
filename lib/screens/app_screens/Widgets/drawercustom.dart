import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_one/providers/usernameprovider.dart';
import 'package:project_one/screens/app_screens/home_screen.dart';
import 'package:project_one/screens/app_screens/previousyear_screen.dart';
import 'package:project_one/screens/authentication/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerCustom extends ConsumerWidget {
  const DrawerCustom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<String?> getUsername() async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final String username =
            (userDoc.data() as Map<String, dynamic>)['username'];
        ref.read(usernameprov.notifier).getuser(username);

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
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple,
                          Colors.purpleAccent,
                        ],
                      ),
                    ),
                    child: DrawerHeader(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder<String?>(
                        future: getUsername(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              strokeCap: StrokeCap.round,
                              color: Colors.lightBlue,
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final username = snapshot.data;

                            return Text(
                              'Welcome! ${username ?? "Guest"}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.question_answer_outlined),
                    title: const Text('Previous Year Question Papers'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const PreviousYearScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notes_sharp),
                    title: const Text('Notes'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
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
