import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zefyr/zefyr.dart';

//class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
//  @override
//  Future<String> pickImage(ImageSource source) async {
//    PickedFile file = await ImagePicker().getImage(source: source,imageQuality: 80);
//    if (file == null) return null;
//    // We simply return the absolute path to selected file.
//    return file.path.toString();
//  }
//
//  @override
//  Widget buildImage(BuildContext context, String key) {
//    final file = File.fromUri(Uri.parse(key));
//    /// Create standard [FileImage] provider. If [key] was an HTTP link
//    /// we could use [NetworkImage] instead.
//    final image = FileImage(file);
//    return Image(image: image);
//  }
//
//  @override
//  // TODO: implement cameraSource
//  ImageSource get cameraSource => ImageSource.camera;
//
//  @override
//  // TODO: implement gallerySource
//  ImageSource get gallerySource => ImageSource.gallery;
//}

class RichTextEditWidget extends StatefulWidget {
  final File file;

  RichTextEditWidget({this.file});

  @override
  _RichTextEditWidgetState createState() => _RichTextEditWidgetState();
}

class _RichTextEditWidgetState extends State<RichTextEditWidget> {
  ZefyrController _editorController;
  String dropdownValue = 'One';
  FocusNode _focusNode;
  NotusDocument _document;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _document = _loadDocument();
    _focusNode = FocusNode();

    _editorController = ZefyrController(_document);
    //  timer = Timer.periodic(Duration(minutes: 3, seconds: 20),
    //      (Timer t) => _saveDocument(isAutoSave: true));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  NotusDocument _loadDocument() {
    return widget.file != null
        ? NotusDocument.fromJson(jsonDecode(widget.file.readAsStringSync()))
        : NotusDocument();
  }

  _saveDocument() async {}

  @override
  Widget build(BuildContext context) {
    final editor = ZefyrField(
      height: MediaQuery.of(context).size.height,
      controller: _editorController,
      focusNode: _focusNode,
      mode: ZefyrMode.edit,
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      physics: BouncingScrollPhysics(),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              color: Colors.white,
              onPressed: () async {
                await _saveDocument();
              }),
          IconButton(
            icon: Icon(Icons.clear_all),
            color: Colors.white,
            onPressed: () async {
              await _clearDocument(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.white,
            onPressed: () async {
              var delta = _editorController.document.toDelta();
//               (_editorController.document.toJson());
              (_editorController.document.toPlainText());
            },
          )
        ],
      ),
      body: ZefyrScaffold(
          child: Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height,
              child: editor)),
    );
  }

  Future<void> _clearDocument(BuildContext context) async {
    bool confirmed = await _getConfirmationDialog(context);
    if (confirmed) {
      _editorController.replaceText(
          0, _editorController.document.length - 1, '');
    }
  }

  Future<bool> _getConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Confirm?'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: Text('Are you sure you want to clear the contents?'),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              isDefaultAction: true,
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}

// Future<String> showTextInputDialog({String title = 'New Blogpost'}) async {
//  return await showCupertinoDialog

//    CupertinoAlertDialog(
//      title: Text('Change title'),
//      content: Material(
//        child: TextFormField(
//          maxLength: 110,
//          initialValue: title,
//          onChanged: (val) {
//            title = val;
//          },
//          decoration: InputDecoration(
//            border: OutlineInputBorder(
//              borderRadius: BorderRadius.circular(5.0),
//            ),
//          ),
//          maxLines: null,
//          textInputAction: TextInputAction.newline,
//          keyboardType: TextInputType.multiline,
//        ),
//      ),
//      actions: [
//        FlatButton(
//          child: Text('Done'),
//          onPressed: () {
//            Get.back(result: title);
//          },
//        )
//      ],
//    ),
//    barrierDismissible: false,
//  );
// }
