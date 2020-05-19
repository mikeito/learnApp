import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:learn_app/models/subject.dart';

class SubjectService {

  final String subject_url = 'https://wsc.bixterprise.com/api/matiere';

  Future<List<Subject>> fetchSubjects(token) async {
    final String _token = token;
    final response = await http.get(
      subject_url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $_token",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    var responseJson = json.decode(response.body);

    List<Subject> subjects_future = [];
    for (var s in responseJson['data']) {
      Subject subject = Subject(s['_id'], s['intitule']);
      subjects_future.add(subject);
    }
    return subjects_future;
  }

}