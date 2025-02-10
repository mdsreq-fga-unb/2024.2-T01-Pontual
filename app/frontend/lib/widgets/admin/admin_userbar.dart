import 'package:flutter/material.dart';

class AdminUseBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onReportPressed;
  final VoidCallback onSettingsPressed;

  const AdminUseBar({
    Key? key,
    required this.onHomePressed,
    required this.onReportPressed,
    required this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Color(0xFFF08484),
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 40,
            bottom: 15,
            child: IconButton(
              icon: const Icon(Icons.fact_check_outlined,
                  size: 30, color: Colors.white),
              onPressed: onReportPressed,
            ),
          ),
          Positioned(
            bottom: 15,
            child: IconButton(
              icon: const Icon(Icons.home, size: 30, color: Colors.white),
              onPressed: onHomePressed,
            ),
          ),
          Positioned(
            right: 40,
            bottom: 15,
            child: IconButton(
              icon: const Icon(Icons.settings, size: 30, color: Colors.white),
              onPressed: onSettingsPressed,
            ),
          ),
        ],
      ),
    );
  }
}
