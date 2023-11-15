import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget{
  NewMessage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage>{
  final MessageController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    MessageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = MessageController.text!;
    if(enteredMessage.trim().isEmpty){
      return ;
    }
    FocusScope.of(context).unfocus();
    MessageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
    .collection('user')
    .doc(user.uid)
    .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text' : enteredMessage,
      'createdAt' : Timestamp.now(),
      'userId' : user.uid,
      'username' : userData.data()!['username'],
      'userimage' : userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(right: 1,bottom: 14,left: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: MessageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: "Send a Message",
              ),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary, 
             )
        ],
      ),
    );
  }
}