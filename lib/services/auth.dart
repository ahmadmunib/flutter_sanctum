import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/user.dart';
import 'dart:developer' as developer;

import 'package:flutter_application_2/services/dio.dart';

class Auth extends ChangeNotifier {
  bool _isAuth = false;
  late User _user;
  // late String _token;

  bool get isAuth => _isAuth;
  User get user => _user;

  void login(Map creds) async {
    try {
      Dio dio = ApiClient.getInstance();
      Response response = await dio.post('/sanctum/token', data: creds);
      if (response.statusCode == 200) {
        // Token generation successful
        String token = response.data;
        developer.log("Token:========> $token",
            name:
                'lib.services.auth.dart->Login()->if (response.statusCode == 200)');

        developer.log("Resonse:========> ${response.data.toString()}",
            name:
                'lib.services.auth.dart->Login()->if (response.statusCode == 200)');
        developer.log("Provided Credentials:======> ${creds.toString()}",
            name:
                'lib.services.auth.dart->Login()->if (response.statusCode == 200)');

        tryToken(token: token);

        _isAuth = true;
        notifyListeners();
      } else {
        // Handle error responses here
        developer.log(response.data.toString(),
            name:
                'lib.services.auth.dart->Login()->else{} of the if (response.statusCode == 200');
      }
    } catch (e) {
      developer.log(e.toString(),
          name: 'lib.services.auth.dart->Login()->Catch(e)');
    }
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }

  void tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio dio = ApiClient.getInstance();
        Options options = Options(headers: {'Authorization': 'Bearer $token'});
        Response response = await dio.get('/user', options: options);
        _isAuth = true;
        _user = User.fromJson(response.data);
        notifyListeners();
        developer.log("User:========> ${_user.toString()}",
            name: 'lib.services.auth.dart->tryToken()->try()');
      } catch (e) {
        developer.log("Error:========> ${e.toString()}",
            name: 'lib.services.auth.dart->tryToken()->catch()');
      }
    }
  }
}
