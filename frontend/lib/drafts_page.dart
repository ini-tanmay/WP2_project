import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/draft.dart';
import 'package:frontend/editor_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DraftsPage extends StatefulWidget {
  DraftsPage({this.userEmail});
  final String userEmail;
  @override
  _DraftsPageState createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Drafts'),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Draft>>(
                builder: (context, snap) {
                  if (!snap.hasData) return CircularProgressIndicator();
                  List<Draft> drafts = snap.data;
                  if (drafts.isEmpty)
                    return Center(
                      child: Text('No drafts'),
                    );
                  return GridView.builder(
                    itemCount: drafts.length,
                    itemBuilder: (context, index) {
                      return buildCard(context, drafts[index]);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2 / 3,
                        crossAxisCount: 3,
                        crossAxisSpacing: 100),
                  );
                },
              ),
            ),
          ),
        ));
  }

  Widget buildCard(BuildContext context, Draft draft) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => EditorPage(widget.userEmail))),
      child: Material(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Card(
            margin: EdgeInsets.zero,
            elevation: 6,
            color: Colors.amber.withOpacity(0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.text.substring(0, min(12, draft.text.length)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      draft.text,
                      style: GoogleFonts.montserrat(fontSize: 22),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      DateFormat('E, d MMM yyyy h:mm a')
                          .format(draft.timeStamp)
                          .toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ]),
            )),
      ),
    );
  }
}
