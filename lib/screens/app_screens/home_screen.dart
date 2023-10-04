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
            const SizedBox(height: 24),
            StylishCard(
              icon: const Icon(
                Icons.view_agenda_outlined,
                color: Colors.white,
                size: 36,
              ),
              text: "My Posts",
              subtitle: "View Your Contributions Here",
              fun: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPosts(
                      isfav: false,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            StylishCard(
              icon: const Icon(
                Icons.favorite_border_rounded,
                color: Colors.white,
                size: 36,
              ),
              subtitle: "View Your Favourites Here",
              text: "My favourites",
              fun: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyPosts(
                      isfav: true,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            StylishCard(
              icon: const Icon(
                Icons.upload_file_outlined,
                color: Colors.white,
                size: 36,
              ),
              subtitle: "Upload a Question Paper Here",
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
            const SizedBox(height: 24),
            StylishCard(
              icon: const Icon(
                Icons.upload_outlined,
                color: Colors.white,
                size: 36,
              ),
              subtitle: "Upload Notes Here",
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
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
