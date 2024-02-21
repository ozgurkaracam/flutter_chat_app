import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fulutter_flashchat_app/screens/chat.dart';
import 'package:fulutter_flashchat_app/utils/custom_alert.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String path = 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  late bool _loading = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  child: Row(
                    children: [
                      Image.asset("assets/flash.png", width: 100, height: 100),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Flash Chat',
                            textStyle: const TextStyle(fontSize: 40),
                            speed: const Duration(milliseconds: 50),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    CustomButton(
                      color: Colors.greenAccent,
                      text: "Register",
                      callback: () async {
                        try {
                          _loading = true;
                          setState(() {});
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ));
                        } on FirebaseAuthException catch (e) {
                          await customalert(
                              context: context, message: e.message!);
                        } finally {
                          _loading = false;
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomButton(
                      color: Colors.green,
                      text: "Login",
                      callback: () async {
                        _loading = true;
                        setState(() {});
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ));
                        } on FirebaseAuthException catch (e) {
                          await customalert(
                              context: context, message: e.message!);
                        } finally {
                          _loading = false;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback callback;
  CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(color)),
        onPressed: callback,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
