import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fulutter_flashchat_app/screens/login.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _messageController = TextEditingController();
  late String message;
  late ScrollController _sc = ScrollController();
  final _messagesRef = FirebaseFirestore.instance.collection('messages');
  @override
  void initState() {
    // jump();

    super.initState();
  }

  void jump() {
    final position = _sc.position.maxScrollExtent;
    _sc.jumpTo(position);
  }

  @override
  void dispose() {
    _sc.dispose();
    _messageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              try {
                _auth.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              } catch (e) {
                print(e);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    _messagesRef.orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      controller: _sc,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot item = snapshot.data!.docs[index];
                        return MessageWidget(item: item);
                      },
                      itemCount: snapshot.data!.size,
                    );
                  }
                  return Center();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      onChanged: (value) => message = value,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton.filled(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orangeAccent)),
                      onPressed: () async {
                        try {
                          _messageController.clear();
                          FocusScope.of(context).unfocus();

                          await _messagesRef.add({
                            "email": _auth.currentUser!.email,
                            "message": message,
                            "date": DateTime.now()
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: Icon(Icons.send_outlined))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  MessageWidget({
    super.key,
    required this.item,
  });

  final _auth = FirebaseAuth.instance;
  final QueryDocumentSnapshot<Object?> item;

  @override
  Widget build(BuildContext context) {
    bool itsMe = _auth.currentUser!.email == item['email'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Column(
        children: [
          Align(
            alignment: itsMe ? Alignment.topLeft : Alignment.topRight,
            child: Text(
              item['email'],
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Align(
            alignment: itsMe ? Alignment.topLeft : Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                color: itsMe ? Colors.greenAccent : Colors.orangeAccent,
                borderRadius: !itsMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item['message'],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
