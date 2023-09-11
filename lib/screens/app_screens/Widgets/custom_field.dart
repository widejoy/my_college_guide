import 'package:flutter/material.dart';

TextField customField(TextEditingController cont, String text) {
  return TextField(
    autocorrect: true,
    controller: cont,
    style: const TextStyle(
      color: Colors.purpleAccent,
      fontSize: 16.0,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.purple.withOpacity(0.1),
      labelText: text,
      labelStyle: const TextStyle(
        color: Colors.purple,
        fontSize: 16.0,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purple, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Colors.purple.withOpacity(0.7), width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
