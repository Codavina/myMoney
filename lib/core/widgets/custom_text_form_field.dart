import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.validator,
    this.readOnly = false,
  });

  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      controller: controller,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
