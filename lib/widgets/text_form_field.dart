import 'package:flutter/material.dart';

Widget buildGamerField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required Color primaryColor,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: primaryColor, size: 22),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
    validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
  );
}