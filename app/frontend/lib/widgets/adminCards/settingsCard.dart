import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard(
      {super.key,
      required this.title,
      required this.color,
      required this.icon,
      required this.onPressed});

  final String title;
  final String color;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 42,
      width: 370,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${title}",
                  style: TextStyle(color: _parseColor(color), fontSize: 15),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onPressed,
                  icon: icon,
                  color: Color(0xFF2DA5D0),
                  iconSize: 25,
                  padding: EdgeInsets.zero, // Remove padding extra
                  constraints: BoxConstraints(), // Evita restrições extras
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", ""); // Remove o "#" se existir
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Adiciona a opacidade (FF = 100%)
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
