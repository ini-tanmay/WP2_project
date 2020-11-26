import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DraftsPage extends StatefulWidget {
  @override
  _DraftsPageState createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Drafts'),
        ),
        child: SafeArea(
          child: Center(
            child: GridView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return buildCard(context);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2 / 3,
                  crossAxisCount: 3,
                  crossAxisSpacing: 100),
            ),
          ),
        ));
  }
}

Widget buildCard(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.push(
        context, CupertinoPageRoute(builder: (context) => DraftsPage())),
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
                    'title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'lorem',
                    style: GoogleFonts.montserrat(fontSize: 22),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    DateFormat('E, d MMM yyyy h:mm a')
                        .format(DateTime.now())
                        .toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ]),
          )),
    ),
  );
}
