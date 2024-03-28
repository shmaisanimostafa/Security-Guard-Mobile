//
//STUB - The Upload Box Widget
//

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  const UploadBox({
    super.key,
    required this.boxText,
    required this.backColor,
    required this.dotColor,
    required this.icon,
  });
  final String boxText;
  final Color backColor;
  final Color dotColor;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      dashPattern: const [10, 10],
      color: dotColor,
      strokeWidth: 2,
      child: Card(
        margin: const EdgeInsets.all(20),
        color: backColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 200.0,
          width: 200.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50.0, color: Colors.black),
                Text(boxText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
