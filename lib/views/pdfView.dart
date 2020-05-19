import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PDFVIEW extends StatefulWidget {

  PDFVIEW({Key key, this.intitule, this.domain, this.support}) : super(key: key);

  final String intitule;
  final String domain;
  final String support;

  @override
  _PDFVIEWState createState() => _PDFVIEWState();
}

class _PDFVIEWState extends State<PDFVIEW> {

  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    try{
      var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_MUSIC);
      print(dir);
      var fileLocation = "$dir/${widget.intitule}.pdf";
      File fileVarible = File(fileLocation);
      print(fileLocation);
      document = await PDFDocument.fromFile(fileVarible);

      setState(() => _isLoading = false);
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.intitule),
        centerTitle: true,
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: document)),
    );
  }
}
