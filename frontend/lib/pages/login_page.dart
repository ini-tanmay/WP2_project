import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/editor_page.dart';
import 'register_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State {
  bool isBusy = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future userLogin() async {
    setState(() {
      isBusy = true;
    });
    String email = emailController.text;
    String password = passwordController.text;
    var url = 'http://localhost:8080/WP2_project/login.php';
    var data = {'email': email, 'password': password};
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isBusy = false;
      });
      if (!message) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Authentication Failed'),
              content: Text(
                  'Please check if your email address and/or password are correct'),
              actions: <Widget>[
                FlatButton(
                  child: new Text("Confirm"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return message;
    }
    return false;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('TextEdit'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Login', style: TextStyle(fontSize: 21))),
                Divider(),
                Container(
                    width: 280,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) return 'Enter a valid email';
                        return null;
                      },
                      controller: emailController,
                      autocorrect: true,
                      decoration:
                          InputDecoration(hintText: 'Enter Your Email Here'),
                    )),
                Container(
                    width: 280,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (val) {
                        if (val.length < 8)
                          return 'Password must be at least 8 characters long';
                        return null;
                      },
                      controller: passwordController,
                      autocorrect: true,
                      obscureText: true,
                      decoration:
                          InputDecoration(hintText: 'Enter Your Password Here'),
                    )),
                RaisedButton(
                  onPressed: () async {
                    var isValid = await userLogin();
                    if (isValid)
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  EditorPage(emailController.text.trim())));
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                  child: Text('Sign In'),
                ),
                CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text('Create an account')),
                Visibility(
                    visible: isBusy,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: CircularProgressIndicator())),
              ],
            ),
          ),
        )));
  }
}
