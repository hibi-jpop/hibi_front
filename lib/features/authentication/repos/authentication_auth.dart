import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AuthenticationRepository {
  final baseurl = '${dotenv.env["API_BASE_URL"]}/api/v1/auth';

  Future<void> localSignup(
    String email,
    String password,
    String nickname,
  ) async {
    final url = "$baseurl/sign-up";
    log("url : $url");

    final Map<String, dynamic> data = {
      "email": email,
      "password": password,
      "nickname": nickname,
    };
    log(data["email"]);
    log(data["password"]);
    log(data["nickname"]);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode(data),
      );

      print(response);
    } catch (e) {
      print("Error: ${e}");
    }
  }

  Future<void> login(String email, String password) async {
    final url = "$baseurl/sign-in";
    log("url : $url");

    final Map<String, dynamic> data = {"email": email, "password": password};
    log(data["email"]);
    log(data["password"]);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': "application/json"},
        body: jsonEncode(data),
      );

      print(response);
    } catch (e) {
      print("Error: ${e}");
    }
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
