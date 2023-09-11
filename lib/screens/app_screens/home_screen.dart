import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';
import 'package:project_one/screens/app_screens/Widgets/stylised_container.dart';
import 'package:project_one/screens/app_screens/create_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerCustom(),
      appBar: const CustomAppBar(title: "Dashboard"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StylishCard(
              text: "My Posts",
              fun: () {},
            ),
            StylishCard(text: "My favourites", fun: () {}),
            StylishCard(
                text: "Create Post",
                fun: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreatePostScreen(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
