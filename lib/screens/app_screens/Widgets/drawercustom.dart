import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_one/screens/authentication/signin_screen.dart';

class DrawerCustom extends StatelessWidget {
  const DrawerCustom({super.key, required this.username});
  final String? username;

  @override
  Widget build(BuildContext context) {
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
                      child: Text(
                        'Welcome! $username',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Dashboard'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.question_answer_outlined),
                    title: const Text('Previous Year Question Papers'),
                    onTap: () {
                      Navigator.pop(context);
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
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Succesfully logged out'),
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
