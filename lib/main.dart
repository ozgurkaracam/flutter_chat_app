import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fulutter_flashchat_app/screens/chat.dart';
import 'package:fulutter_flashchat_app/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flash Chat",
      home:
          _auth.currentUser == null ? const LoginScreen() : const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
