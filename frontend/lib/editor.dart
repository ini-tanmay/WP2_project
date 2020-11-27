import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/drafts.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  TextStyle _textStyle = GoogleFonts.bilbo(fontSize: 33);
  String _text = 'Sample Text';
  TextAlign _textAlign = TextAlign.center;

  addTextToDb() {}

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
            middle: Text('Edit Draft'),
            trailing: Row(children: [
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () {},
              ),
            ]),
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
                    MarkdownWidget(
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
                              textStyle: Theme.of(context).textTheme.headline5),
                        ))
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
                context, CupertinoPageRoute(builder: (context) => LoginPage())),
          ),
        ],
      ),
    );
  }
}
