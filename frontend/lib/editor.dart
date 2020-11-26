import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/drafts.dart';
import 'package:frontend/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_editor/text_editor.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  TextStyle _textStyle = GoogleFonts.bilbo(fontSize: 33);

  String _text = 'Sample Text';

  TextAlign _textAlign = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: buildDrawer(context),
        appBar: CupertinoNavigationBar(
          leading: Builder(
            builder: (newContext) => CupertinoButton(
              onPressed: () {
                Scaffold.of(newContext).openDrawer();
              },
              child: Icon(Icons.menu),
            ),
          ),
          middle: Text('Edit Draft'),
        ),
        body: Center(
            child: Container(
          color: Colors.red,
          child: TextEditor(
            fonts: ['Billabong'],
            text: _text,
            textStyle: _textStyle,
            textAlingment: _textAlign,
            onEditCompleted: (style, align, text) {
              setState(() {
                _text = text;
                _textStyle = style;
                _textAlign = align;
              });
              Navigator.pop(context);
            },
          ),
        )));
  }

  Widget buildDrawer(context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text('email'),
            accountName: Text('name'),
          ),
          ListTile(
            title: Text('Editor'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.push(context,
                CupertinoPageRoute(builder: (context) => EditorPage())),
          ),
          ListTile(
            title: Text('Drafts'),
            leading: Icon(Icons.attach_file),
            onTap: () => Navigator.push(context,
                CupertinoPageRoute(builder: (context) => DraftsPage())),
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.logout),
            onTap: () => Navigator.push(
                context, CupertinoPageRoute(builder: (context) => AuthPage())),
          ),
        ],
      ),
    );
  }
}
