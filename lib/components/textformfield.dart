import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.isObscure,
  });

  final TextEditingController controller;
  final String label;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }
}