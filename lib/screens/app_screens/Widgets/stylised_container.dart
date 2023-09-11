import 'package:flutter/material.dart';

class StylishCard extends StatelessWidget {
  const StylishCard({
    super.key,
    required this.text,
    required this.fun,
  });
  final String text;
  final VoidCallback fun;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        width: double.infinity,
        height: 128,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 221, 128, 237),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
