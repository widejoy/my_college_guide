import 'package:flutter/material.dart';

TextField auth(String text, IconData icon, bool ispassordtype,
    TextEditingController cont) {
  return TextField(
    controller: cont,
    obscureText: ispassordtype,
    enableSuggestions: !ispassordtype,
    autocorrect: !ispassordtype,
    cursorColor: Colors.white,
    style: TextStyle(
      color: Colors.white.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white,
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: ispassordtype
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
