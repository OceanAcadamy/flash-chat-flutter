import 'package:flash_chat/components/button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;
  String errorEmail, errorPassword;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter you Email',
                  errorText: errorEmail,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter you Password',
                  errorText: errorPassword,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Button(
                text: 'Log In',
                onTap: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    email ??= '';
                    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email.trim()) &&
                        password != null) {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        email = '';
                        password = '';
                        Navigator.pushNamed(context, ChatScreen.id);
                        setState(() {
                          showSpinner = false;
                          errorEmail = null;
                          errorPassword = null;
                        });
                        _emailController.clear();
                        _passwordController.clear();
                        print(user);
                      }
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email.trim())) {
                      setState(() {
                        showSpinner = false;
                        errorEmail = 'enter your email';
                        errorPassword = null;
                      });
                    } else if (password == null || password == '') {
                      setState(() {
                        showSpinner = false;
                        errorEmail = null;
                        errorPassword = 'enter you password';
                      });
                    }
                  } on PlatformException catch (e) {
                    if (e.code == 'ERROR_USER_NOT_FOUND') {
                      setState(() {
                        showSpinner = false;
                        errorEmail = 'User not found';
                        errorPassword = null;
                      });
                      print(e.code);
                    } else if (e.code == 'ERROR_WRONG_PASSWORD') {
                      setState(() {
                        showSpinner = false;
                        errorEmail = null;
                        errorPassword = 'Password is incorrect';
                      });
                      print(e.code);
                    }
                  }
                },
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
