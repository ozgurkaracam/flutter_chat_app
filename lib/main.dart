import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fulutter_flashchat_app/screens/chat.dart';
import 'package:fulutter_flashchat_app/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(),
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelStyle: TextStyle(color: Colors.orangeAccent),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          )),
      home:
          _auth.currentUser == null ? const LoginScreen() : const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
