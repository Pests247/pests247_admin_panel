import 'package:flutter/material.dart';

class AllGifts extends StatelessWidget {
  const AllGifts({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final fontSize = width * 0.015;

    return Center(
      child: Text(
        'Show Gifts here',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
