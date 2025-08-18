import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Hello World!'),
      ),
    ),
  );
}
