import 'package:flutter/material.dart';

TextField customField(TextEditingController cont, String text,
    {bool isnum = false, required bool isNumeric}) {
  return TextField(
    keyboardType: isnum ? const TextInputType.numberWithOptions() : null,
    autocorrect: true,
    controller: cont,
    style: const TextStyle(
      color: Colors.purpleAccent,
      fontSize: 16.0,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(255, 253, 241, 255),
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
