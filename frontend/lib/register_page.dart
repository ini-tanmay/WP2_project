import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/login_page.dart';
import 'package:http/http.dart' as http;
import 'editor_page.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State {
  bool isBusy = false;
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
    var url = 'http://localhost:8080/WP2_project/register.php';
    var data = {'name': name, 'email': email, 'password': password};
    http.Response response = await http.post(url, body: json.encode(data));
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
        body: Center(
          child: Form(
            key: _formKey,
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
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) return 'Name cannot be empty';
                        return null;
                      },
                      controller: nameController,
                      autocorrect: false,
                      autofillHints: [AutofillHints.name],
                      decoration: InputDecoration(hintText: 'Name'),
                    )),
                Container(
                    width: 280,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (val) {
                        if (val.isEmpty) return 'Enter a valid email';
                        return null;
                      },
                      controller: emailController,
                      autofillHints: [AutofillHints.email],
                      autocorrect: false,
                      decoration: InputDecoration(hintText: 'Email'),
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
                      autocorrect: false,
                      autofillHints: [AutofillHints.password],
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password'),
                    )),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var isValid = await userRegistration();
                      if (isValid)
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    EditorPage(emailController.text.trim())));
                    }
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text('Sign Up'),
                ),
                CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => LoginPage()));
                    },
                    child: Text('Got an account already?')),
                Visibility(
                    visible: isBusy,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: CircularProgressIndicator())),
              ],
            ),
          ),
        ));
  }
}
