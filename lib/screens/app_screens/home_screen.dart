import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustom(username: username),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple,
                Colors.purpleAccent,
              ],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        elevation: 6,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              'Your Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
