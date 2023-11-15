import 'package:chat/widget/chat_msg.dart';
import 'package:chat/widget/new_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat APP"),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          },
           icon: Icon(Icons.exit_to_app,
           color: Theme.of(context).colorScheme.primary,
           ))
        ],  
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessage()),
          NewMessage(),
        ],
      )
    );
  }
}