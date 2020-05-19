import 'package:flutter/material.dart';
import 'package:learn_app/models/subject.dart';
import 'package:learn_app/services/subject_service.dart';

import 'package:learn_app/views/courses.dart';

class Subjects extends StatefulWidget {
  Subjects({Key key, this.token, this.userSchool, this.userClass})
      : super(key: key);

  final String token;
  final String userSchool;
  final String userClass;

  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {

  Future<List<Subject>> futureSubject;

  @override
  void initState() {
    super.initState();
    futureSubject = SubjectService().fetchSubjects(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text('Subjects'),
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
          future: futureSubject,
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
                            title: Text(snapshot.data[index].intitule),
                            subtitle: Text(snapshot.data[index].id),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Courses(
                                    intitule: snapshot.data[index].intitule,
                                    token: widget.token,
                                    courseUserSchool: widget.userSchool,
                                    courseUserClass: widget.userClass)
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    );
                  }
              );
            }
            else {
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
      ),
    );
  }
}
