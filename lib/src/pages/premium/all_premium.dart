import 'package:flutter/material.dart';

class AllPremium extends StatelessWidget {
  const AllPremium({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final fontSize = width * 0.015;

    return Center(
      child: Text(
        'Show Premium here',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
