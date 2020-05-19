import 'dart:convert';
import 'dart:io';
import 'dart:io' as oi;

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:learn_app/models/class.dart';
import 'package:learn_app/views/pdfView.dart';
import 'package:learn_app/views/quiz.dart';
import 'package:path_provider/path_provider.dart';

class Courses extends StatefulWidget {
  Courses({Key key, this.intitule, this.token, this.courseUserSchool, this.courseUserClass}) : super(key: key);

  final String intitule;
  final String token;
  final String courseUserSchool;
  final String courseUserClass;

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {

  /// Variables declarations
  Future<List<Class>> futureClass;
  final domain = "https://wsc.bixterprise.com/";
  bool downloading = false;
  var downloadProgressString = "";
  String directory;

  Future<List<Class>> _fetchCourses() async {
    final String url = "https://wsc.bixterprise.com/api/cours/etablissement";
    final String _token = widget.token;

    final response = await http.get(
      "$url/${widget.courseUserSchool}/classe/${widget.courseUserClass}",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    //print(response);
    var responseJson = json.decode(response.body);
    //print(responseJson['data']);

    List<Class> classFuture = [];
    for (var s in responseJson['data']) {
      if(s['matiere'] == widget.intitule) {
        Class cl = Class(s['intitule'], s['description'], s['support']);
        classFuture.add(cl);
      }
      
    }
    return classFuture;
  }

  Future<void> downloadFile(support, intitule) async {
    Dio dio = Dio();

    try {
      /// Get External storage MUSIC directory path
      var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_MUSIC);

      await dio.download(domain+support, "${dir}/$intitule.pdf",
        onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            downloading = true;
            downloadProgressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        }
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      downloadProgressString = "Completed";
    });
    print("Download completed");
  }


  @override
  void initState() {
    super.initState();
    futureClass = this._fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text(widget.intitule),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: futureClass,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: downloadProgressString == 'Completed' ? Icon(Icons.check) : Icon(Icons.cloud_download),
                              title: Text(snapshot.data[index].intitule),
                              subtitle: Text(snapshot.data[index].description),
                              trailing: downloading ? Text(downloadProgressString) : Text(''),
                              onTap: () {
                                this.downloadFile(snapshot.data[index].support, snapshot.data[index].intitule);
                              },
                              onLongPress: () {
                                print("long press");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PDFVIEW(intitule: snapshot.data[index].intitule, domain: domain, support: snapshot.data[index].support,)));
                              },
                            )
                          ],
                        ),
                      );
                    });
              }
              else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Quiz(token: widget.token, subject: widget.intitule))
          );
        },
        label: Text('Take quiz'),
        icon: Icon(Icons.thumb_up),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
