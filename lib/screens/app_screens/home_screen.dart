import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/appbar_custom.dart';
import 'package:project_one/screens/app_screens/Widgets/drawercustom.dart';
import 'package:project_one/screens/app_screens/Widgets/stylised_container.dart';
import 'package:project_one/screens/app_screens/create_post_screen.dart';
import 'package:project_one/screens/app_screens/my_posts.dart';

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
              fun: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPosts(),
                  ),
                );
              },
            ),
            StylishCard(
              text: "My favourites",
              fun: () {},
            ),
            StylishCard(
              text: "upload a question paper",
              fun: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreatePostScreen(
                      isquestionpaper: true,
                    ),
                  ),
                );
              },
            ),
            StylishCard(
              text: "upload your notes",
              fun: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const CreatePostScreen(isquestionpaper: false);
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
