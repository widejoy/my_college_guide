import 'package:flutter/material.dart';
import 'package:project_one/screens/app_screens/Widgets/custom_field.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomField(),
    );
  }
}
