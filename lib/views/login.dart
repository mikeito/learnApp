import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_app/services/login_service.dart';
import 'package:learn_app/views/register.dart';
import 'package:learn_app/views/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String login_url = 'https://wsc.bixterprise.com/api/eleve/login';
  String token = '';
  String user_school = '';
  String user_class = '';


  ///Method that triggers permission popup.
  void requestPermission() async {
    if (await Permission.storage.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
      print("permission granted");
    }
  }

  @override
  void initState() {
    super.initState();
    this.requestPermission();
  }

  Future<String> attemptLogIn(String telephone, String password) async {
    var res = await http.post(
        login_url,
        body: {
          "telephone": telephone,
          "password": password
        }
    );
    if(res.statusCode == 200) {
      var data = json.decode(res.body);
      //print(data['data']['classe']);
      token = data['token'];
      user_school = data['data']['etablissement'];
      user_class = data['data']['classe'];
      print(user_school);
      return token;
    }
    else{print("failed request");}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Wanda School'),
        ),
        body: Padding(
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
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name OR Phone number',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        attemptLogIn(nameController.text, passwordController.text).then((val) {
                          if(val.isNotEmpty) {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (BuildContext context) => Subjects(token: token, userSchool: user_school, userClass: user_class)));
                          }
                          else{
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Center(child: Text("Bad credentials"),))
                            );
                          }
                        }).catchError((e) {
                          print("Error: $e");
                        });
                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Colors.blue,
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Register()));
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )
        )
    );
  }
}
