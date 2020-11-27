import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/draft.dart';
import 'package:frontend/drafts_page.dart';
import 'package:frontend/login_page.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class EditorPage extends StatefulWidget {
  EditorPage(this.userEmail, {this.draft});
  final Draft draft;
  final String userEmail;
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  String _text = 'Sample Text';
  String title = DateTime.now().toIso8601String();

  addDraftToDb() async {
    Draft draft = Draft(
        userID: widget.userEmail,
        text: _text,
        timeStamp: DateTime.now(),
        title: title);

    await http.post('http://localhost:8080/WP2_project/add_draft.php',
        body: json.encode(draft.toMap()));
  }

  @override
  void initState() {
    super.initState();
    if (widget.draft != null) {
      _text = widget.draft.text;
      title = widget.draft.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
            middle: Text('Edit Draft - ' + title),
            trailing: CupertinoButton(
              child: Icon(Icons.save),
              onPressed: () async {
                await showTextInputDialog();
                await addDraftToDb();
              },
            ),
          ),
          body: Center(
              child: Column(
            children: [
              TabBar(
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'Edit',
                    icon: Icon(Icons.edit),
                  ),
                  Tab(
                    text: 'Preview',
                    icon: Icon(CupertinoIcons.eye),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: MarkdownTextInput((val) {
                        setState(() {
                          _text = val;
                          print(val);
                        });
                      }, _text),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MarkdownWidget(
                          data: _text.replaceAll('<br>', '\n'),
                          loadingWidget:
                              Center(child: Text('Enter in some text!')),
                          styleConfig: StyleConfig(
                            pConfig: PConfig(
                                onLinkTap: (val) async {
                                  if (await canLaunch(val))
                                    await launch(
                                      val,
                                      forceSafariVC: false,
                                    );
                                },
                                textStyle:
                                    Theme.of(context).textTheme.headline5),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ))),
    );
  }

  Widget buildDrawer(context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(''),
            accountEmail: Text(widget.userEmail),
          ),
          ListTile(
            title: Text('Editor'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => EditorPage(widget.userEmail))),
          ),
          ListTile(
            title: Text('Drafts'),
            leading: Icon(Icons.attach_file),
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => DraftsPage(widget.userEmail))),
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.logout),
            onTap: () => Navigator.push(
                context, CupertinoPageRoute(builder: (context) => LoginPage())),
          ),
        ],
      ),
    );
  }

  Future<String> showTextInputDialog() async {
    return await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Change title'),
        content: Material(
          child: TextFormField(
            maxLength: 110,
            initialValue: title,
            onChanged: (val) {
              title = val;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            maxLines: null,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
          ),
        ),
        actions: [
          FlatButton(
            child: Text('Done'),
            onPressed: () {
              Navigator.of(context).pop(title);
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
}
