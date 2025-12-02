import 'package:flutter/material.dart';

class ReusableForm extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final VoidCallback onSubmit;
  final String submitButtonText;

  const ReusableForm({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...fields,
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(submitButtonText, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
