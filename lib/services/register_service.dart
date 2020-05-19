import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class RegisterService {

  final String schoolUrl = 'https://wsc.bixterprise.com/api/etablissement';
  var _data = List();

  List get data {
    return _data;
  }

  Future fetchSchools() async {
    final response = await http.get(
      schoolUrl,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    var responseJson = json.decode(response.body);

    _data = responseJson["data"];
    print("In method: $_data");
    return "Success";
  }

  Future postForm(data) async {
    final response = await http.post(
      schoolUrl,
      body: data
    );

    //var responseJson = json.decode(response.body);

    //_data = responseJson["data"];
    //print("In method: $_data");
    //return "Success";
  }

}