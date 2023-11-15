import 'dart:io';

import 'package:chat/widget/userimagepicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  final _form = GlobalKey<FormState>(); 

    var _islogin=false;
    var _enteredEmail='';
    var _enteredPassword='';
    File? _selcetedImage;
    var _isUploading = false;
    var _enteredUsernmae='';
    

    void _submit() async {
      final isValid = _form.currentState!.validate();

      if(!isValid){
        return ;
      }
      
      if(!_islogin){
        if(_selcetedImage==null){
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No Image Picked")));
          return ;
        }
      }


      _form.currentState!.save();


      try{
        setState(() {
          _isUploading=true;
        });
        if(_islogin){
          final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        }else{
          final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
           password: _enteredPassword);
           final storageRef = 
            FirebaseStorage.
            instance.ref().
            child("user_images").
            child('${userCredentials.user!.uid}.jpg');

            await storageRef.putFile(_selcetedImage!);
            final imageUrl = await storageRef.getDownloadURL();
            print(imageUrl);
            
            await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredentials.user!.uid)
            .set({
              'username':_enteredUsernmae,
              'email':_enteredEmail,
              'image_url':imageUrl,
            });
        }
      }on FirebaseAuthException catch (error) {
        setState(() {
          _isUploading=false;
        });
          if(error.code == 'email-already-in-use'){
            // specific error
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? "Auth failed")));
        }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16,),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(!_islogin)
                            UserImagePicker(onPickImage: (pickedImage) {
                              _selcetedImage=pickedImage;
                            },),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if(value==null 
                              || value.trim().isEmpty 
                              || !value.contains('@')){
                                return "Please enter a valid email edress";
                              }
                              return null; 
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if(!_islogin)
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Username"
                              ),
                              enableSuggestions: false,
                              validator: (value) {
                                if( value==null 
                                || value.trim().isEmpty 
                                || value.trim().length<4){
                                  return "Please enter a valid Name";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _enteredUsernmae = newValue!;
                              },
                            ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if(value==null 
                              || value.trim().isEmpty 
                              || value.trim().length < 6){
                                return "Password must be greater than 6 character";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12,),
                          if(_isUploading)
                             CircularProgressIndicator(),
                          if(!_isUploading)
                            ElevatedButton(
                              onPressed: _submit ,
                            child: Text(_islogin? "Login":"SignUp"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: 
                              Theme.of(context).colorScheme.primaryContainer,
                            ),
                           ),
                           TextButton(onPressed: (){
                            print("pressed");
                            setState(() {
                              _islogin= !_islogin;
                            });
                           },
                            child: Text(_islogin? "Create an account"
                            :"Already have an account")
                            )
                        ],
                      )),
                ),
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}