import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:frontend/drafts.dart';
import 'package:frontend/main.dart';

class EditorPage extends StatelessWidget {
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
        child: Text('Hey'),
      ),
    );
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
