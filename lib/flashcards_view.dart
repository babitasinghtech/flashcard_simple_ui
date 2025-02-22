import 'package:flutter/material.dart';

class FlashcardsView extends StatelessWidget {
  final String text;

  // ignore: prefer_const_constructors_in_immutables, use_super_parameters
  FlashcardsView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
