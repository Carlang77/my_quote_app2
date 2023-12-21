import 'package:flutter/material.dart';
import 'package:quotes/views/quote_screen.dart'; // Import the QuoteScreen from quote_screen.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quote App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuoteScreen(), // Use the imported QuoteScreen here
    );
  }
}
