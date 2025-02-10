import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;
  final Color? iconColor;
  final int width, height;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final bool disabled;

  static const TextStyle _textStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.icon,
      this.color,
      this.iconColor,
      this.width = 354,
      this.height = 52,
      this.disabled = false,
      this.textStyle = _textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      decoration: BoxDecoration(
        color: disabled ? Colors.grey : (color ?? Color(0xFFF08484)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              disabled ? Colors.grey : (color ?? Color(0xFFF08484)),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? Colors.white,
                  ),
                  SizedBox(
                    width: width.toDouble() - 80.0,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  )
                ],
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
      ),
    );
  }
}
