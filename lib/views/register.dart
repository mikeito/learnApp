import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:learn_app/services/register_service.dart';
import 'package:learn_app/views/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  List schools = List();
  List classes = List();

  var currentSelectedSchool;
  var currentSelectedClass;

  final String apiUrl = 'https://wsc.bixterprise.com/api/';

  /// Request for schools
  Future<String> fetchSchools() async {
    final response = await http.get(
      apiUrl + 'etablissement',
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    var responseJson = json.decode(response.body);

    setState(() {
      /// Set $schools to the data response
      schools = responseJson["data"];
    });
    return "Success";
  }

  /// Request for classes
  Future<String> fetchClasses(school) async {
    final response = await http.get(
      apiUrl + 'classes/etablissement/$school',
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    var responseJson = json.decode(response.body);

    setState(() {
      /// Set $classes to the data response
      classes = responseJson["data"];
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.fetchSchools();
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    TextEditingController pseudoController = TextEditingController();
    TextEditingController telController = TextEditingController();
    TextEditingController tutorTelController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    /// Grouping all form fields in a map.
    Map getFormData() {
      final formData = {};
      formData['nom'] = nameController.text;
      formData['prenom'] = surnameController.text;
      formData['pseudo'] = pseudoController.text;
      formData['telephone'] = telController.text;
      formData['telephone_tuteur'] = tutorTelController.text;
      formData['email'] = emailController.text;
      formData['password'] = passwordController.text;
      formData['etablissement'] = currentSelectedSchool;
      formData['classe'] = currentSelectedClass;

      return formData;
    }

    ///School dropdown field
    Widget schoolFieldWidget() {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text("Select a school"),
                  value: currentSelectedSchool,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedSchool = newValue;
                      this.fetchClasses(currentSelectedSchool);
                    });
                  },
                  items: schools.map((value) {
                    return DropdownMenuItem(
                      value: value['intitule'],
                      child: Text(value['intitule']),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      );
    }

    ///Class dropdown field
    Widget classFieldWidget() {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  hint: Text("Select a class"),
                  value: currentSelectedClass,
                  isDense: true,
                  onChanged: (newValue) {
                    //currentSelectedClass = null;
                    //print(currentSelectedClass);
                    setState(() {
                      //print(classes);
                      //doesn't enter here for the second time
                      print('in function');
                      currentSelectedClass = null;
                      print('new');
                      print(currentSelectedClass);
                      currentSelectedClass = newValue;
                    });
                  },
                  items: classes.map((value) {
                    return new DropdownMenuItem(
                      value: value['intitule'],
                      child: Text(value['intitule']),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Wanda School'),
      ),
      body: Builder(
          builder: (context) => Form(
              key: _formKey,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Learn App',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 20),
                          )),
                      schoolFieldWidget(),
                      classFieldWidget(),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'First Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: surnameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Last name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: pseudoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Pseudo Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a pseudo';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: telController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Telephone number',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your telephone number';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: tutorTelController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tutor telephone number',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the tutors number';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email address',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Text('Register'),
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                this.postForm(getFormData());
                                /*Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Processing Data, please move to login'), duration: Duration(seconds: 2),));*/
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              }
                            },
                          )),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text('Already have an account?'),
                            FlatButton(
                              textColor: Colors.blue,
                              child: Text(
                                'Sign in',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                      )
                    ],
                  )
              )
          )
      ),
    );
  }

  void postForm(Map formData) async {
    final response = await http.post(apiUrl + 'eleve', body: formData);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
