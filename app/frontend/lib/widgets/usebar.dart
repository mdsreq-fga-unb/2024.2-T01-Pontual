import 'package:flutter/material.dart';
import 'dialog_options.dart';

class UseBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onProfilePressed;

  const UseBar({
    Key? key,
    required this.onHomePressed,
    required this.onProfilePressed,
  }) : super(key: key);

  void _showDialogOptions(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite fechar ao clicar fora
      builder: (BuildContext context) {
        return DialogOptions();
      },
    );
  }

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
              icon: const Icon(Icons.home, size: 30, color: Colors.white),
              onPressed: onHomePressed,
            ),
          ),
          Positioned(
            right: 40,
            bottom: 15,
            child: IconButton(
              icon: const Icon(Icons.person, size: 30, color: Colors.white),
              onPressed: onProfilePressed,
            ),
          ),
          Positioned(
            top: -25,
            child: FloatingActionButton(
              backgroundColor: Color(0xFFF08484),
              onPressed: () => _showDialogOptions(context),
              shape: const CircleBorder(),
              child: const Icon(Icons.add, size: 32, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
