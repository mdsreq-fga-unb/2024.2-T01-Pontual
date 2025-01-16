import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;

  CustomInput({
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 59,
      decoration: BoxDecoration(
        color: Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFC0C0C0),
          width: 3.0,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword && !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 15, // Tamanho da fonte
            color: Colors.grey.withOpacity(0.6), // Cor com transparência
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color(0xFFC0C0C0),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
