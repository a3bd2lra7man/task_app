import 'package:flutter/material.dart';

class PrimaryEditText extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int minLines;
  const PrimaryEditText({super.key, required this.controller, this.validator, this.minLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: null,
      controller: controller,
      validator: validator,
      
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: .2),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: .2),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: .2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
