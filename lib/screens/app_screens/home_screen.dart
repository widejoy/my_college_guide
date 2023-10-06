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
    PageRouteBuilder createPageRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          var opacityTween = Tween(begin: 0.0, end: 1.0);

          var scaleAnimation = animation.drive(tween);
          var opacityAnimation = animation.drive(opacityTween);

          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: opacityAnimation,
              child: child,
            ),
          );
        },
      );
    }

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
                  createPageRoute(
                    const MyPosts(isfav: false),
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
                  createPageRoute(
                    const MyPosts(isfav: true),
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
              subtitle: "Click here to input Question Paper",
              text: "Upload Question Paper",
              fun: () {
                Navigator.of(context).push(
                  createPageRoute(
                    const CreatePostScreen(isquestionpaper: true),
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
              subtitle: "Click here to input Notes",
              text: "Upload  Notes",
              fun: () {
                Navigator.of(context).push(
                  createPageRoute(
                    const CreatePostScreen(isquestionpaper: false),
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
