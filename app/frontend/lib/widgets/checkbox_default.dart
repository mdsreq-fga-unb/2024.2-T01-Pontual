import 'package:flutter/material.dart';

class CheckboxDefault extends StatefulWidget {
  final void Function(bool?) onChanged;

  const CheckboxDefault({super.key, required this.onChanged});

  @override
  State<CheckboxDefault> createState() => _CheckboxDefaultState();
}

class _CheckboxDefaultState extends State<CheckboxDefault> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      if (!isChecked) {
        return Color(0xFFEDEDED);
      }
      return Color(0xFFF08484);
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: WidgetStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
        widget.onChanged(value);
      },
    );
  }
}
