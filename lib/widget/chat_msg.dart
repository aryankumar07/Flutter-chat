import 'package:chat/widget/msg_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget{

  ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore
      .instance
      .collection('chat')
      .orderBy('createdAt',descending: false)
      .snapshots(),
     builder: (ctx, csnapshot) {
      if( csnapshot.connectionState == ConnectionState.waiting){
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      print(csnapshot.data!.docs.isEmpty);

      if( !csnapshot.hasData || csnapshot.data!.docs.isEmpty){
        return Center(
          child: Text("No Message Found"),
        );
      }

      final loadMessage = csnapshot.data!.docs;

      if(csnapshot.hasError){
        return Center(
          child: Text("Something Went Wrong"),
        );
      }

      return ListView.builder( itemCount: loadMessage.length,
       itemBuilder: (ctx,index) 
       {
        final chatMessage = loadMessage[index].data();
        final nextChatMessage = index+1 < loadMessage.length? loadMessage[index+1].data() : null;
        final CurrentmessageUserid = chatMessage['userId'];
        final nextMessageUserid = nextChatMessage!=null? nextChatMessage['userId'] : null;
        final nextUserIsSame = nextMessageUserid==CurrentmessageUserid;
        if(nextUserIsSame){
          return MessageBubble.next(
            message: chatMessage['text'],
           isMe: authUser!.uid==CurrentmessageUserid);
        }else{
          return MessageBubble.first(
            userImage: chatMessage['userImage'],
             username: chatMessage['username'],
              message: chatMessage['text'],
               isMe: authUser!.uid==CurrentmessageUserid);
        }
       }
      );

     }
     );
  }
  
}