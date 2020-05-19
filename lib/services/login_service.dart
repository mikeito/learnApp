import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginService {
  String login_url = 'https://wsc.bixterprise.com/api/eleve/login';
  String _token = '';

  String get token => _token;

  /*set token(String value) {
    _token = value;
  }*/

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
      //print(data);
      _token = data['token'];
      print("token only below");
      print(_token);
      //setUserToken(_token);
    }
    else{print("failed request");}

    return null;
  }

  /*Future<void> setUserToken(String auth_token) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("auth_token", auth_token);
  }

  Future<String> getUserToken() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("auth_token");
  }*/

}