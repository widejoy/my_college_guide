import 'package:flutter/material.dart';

class StylishCard extends StatelessWidget {
  const StylishCard({
    super.key,
    required this.text,
    required this.fun,
    required this.subtitle,
    required this.icon,
  });
  final String text;
  final VoidCallback fun;
  final String subtitle;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 0, 136, 255),
              Color.fromARGB(255, 26, 117, 197),
              Colors.purpleAccent,
              Colors.amber,
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    icon
                  ],
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
