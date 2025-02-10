import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dialog_options.dart';

class UseBar extends StatelessWidget {
  final bool? isAddNotFloating;
  final VoidCallback onHomePressed;
  final VoidCallback onProfilePressed;
  final void Function() updateClasses;
  final void Function() updateVIP;

  const UseBar({
    Key? key,
    required this.onHomePressed,
    required this.onProfilePressed,
    required this.updateClasses,
    required this.updateVIP,
    this.isAddNotFloating,
  }) : super(key: key);

  void _showDialogOptions(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DialogOptions(
          updateClasses: updateClasses,
          updateVIP: updateVIP,
        );
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
            top: isAddNotFloating == true ? 8 : -42,
            height: isAddNotFloating == true ? 54 : 85,
            width: isAddNotFloating == true ? 54 : 85,
            child: FloatingActionButton(
              backgroundColor: Color(0xFFFA6161),
              elevation: isAddNotFloating == true ? 0 : 5,
              onPressed: () => _showDialogOptions(context),
              shape: const CircleBorder(),
              child: Text(
                String.fromCharCode(CupertinoIcons.add.codePoint),
                style: TextStyle(
                  inherit: false,
                  color: Colors.white,
                  fontSize: isAddNotFloating == true ? 32 : 48,
                  fontWeight: FontWeight.w100,
                  fontFamily: CupertinoIcons.add.fontFamily,
                  package: CupertinoIcons.add.fontPackage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
