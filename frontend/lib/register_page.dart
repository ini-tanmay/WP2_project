import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/login_page.dart';
import 'package:http/http.dart' as http;
import 'editor.dart';
import 'dart:convert';
import 'dart:developer' as dev;

class RegisterPage extends StatefulWidget {
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State {
  // Boolean variable for CircularProgressIndicator.
  bool isBusy = false;

  // Getting value from TextField widget.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> userRegistration() async {
    setState(() {
      isBusy = true;
    });
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    var url = 'http://localhost:8080/WP2_project/register_mongo.php';
    var data = {'name': name, 'email': email, 'password': password};
    http.Response response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    dev.log(message.toString() + 'neyyyyyyyyyyyyyyyyyyyyyyy');
    dev.log(response.statusCode.toString());
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
              content:
                  Text('This email is already in use, please try again later'),
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
      return true;
    }
    return false;
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
                      autocorrect: false,
                      autofillHints: [AutofillHints.name],
                      placeholder: 'Name')),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: CupertinoTextField(
                      controller: emailController,
                      autofillHints: [AutofillHints.email],
                      autocorrect: false,
                      placeholder: 'Enter Your Email Here')),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: CupertinoTextField(
                      controller: passwordController,
                      autocorrect: false,
                      autofillHints: [AutofillHints.password],
                      obscureText: true,
                      placeholder: 'Password')),
              RaisedButton(
                onPressed: () async {
                  var isValid = await userRegistration();
                  if (isValid)
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => EditorPage()));
                },
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text('Sign Up'),
              ),
              CupertinoButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Got an account already?')),
              Visibility(
                  visible: isBusy,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator())),
            ],
          ),
        ));
  }
}
