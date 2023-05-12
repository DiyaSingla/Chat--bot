import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E wallet Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ChatBotScreen(),
    );
  }
}
