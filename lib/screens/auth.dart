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
    

    void _submit() async {
      final isValid = _form.currentState!.validate();

      if(!isValid){
        return ;
      }
      _form.currentState!.save();


      try{
        if(_islogin){
          final userCredential = await _firebase.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
        }else{
          final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
           password: _enteredPassword);
        }
      }on FirebaseAuthException catch (error) {
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
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if(value==null || value.trim().isEmpty || !value.contains('@')){
                                return "Please enter a valid email edress";
                              }
                              return null; 
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if(value==null || value.trim().isEmpty || value.trim().length < 6){
                                return "Password must be greater than 6 character";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12,),
                          ElevatedButton(
                            onPressed: _submit ,
                           child: Text(_islogin? "Login":"SignUp"),
                           style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                           ),
                           ),
                           TextButton(onPressed: (){
                            print("pressed");
                            setState(() {
                              _islogin= !_islogin;
                            });
                           },
                            child: Text(_islogin? "Create an account":"Already have an account"))
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