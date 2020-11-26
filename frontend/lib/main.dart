import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/drafts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'editor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint.resize(450, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
            ),
        home: AuthPage());
  }
}

class AuthPage extends StatefulWidget {
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State {
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;

  // Getting value from TextField widget.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  get http => null;

  Future userRegistration() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    var url = 'http://localhost:8080/WP2_project/auth.php';
    var data = {'name': name, 'email': email, 'password': password};
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('TextEdit'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('User Registration Form',
                      style: TextStyle(fontSize: 21))),
              Divider(),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: CupertinoTextField(
                      controller: nameController,
                      autocorrect: true,
                      placeholder: 'Name')),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: CupertinoTextField(
                      controller: emailController,
                      autocorrect: true,
                      placeholder: 'Enter Your Email Here')),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: CupertinoTextField(
                      controller: passwordController,
                      autocorrect: true,
                      obscureText: true,
                      placeholder: 'Password')),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => EditorPage()));
                },
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text('Sign Up'),
              ),
              Visibility(
                  visible: visible,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator())),
            ],
          ),
        ));
  }
}
