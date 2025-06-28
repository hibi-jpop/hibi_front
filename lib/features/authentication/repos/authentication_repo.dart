import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/common/common_repos.dart';
import 'package:http/http.dart' as http;

class AuthenticationRepository {
  final baseurl = '${dotenv.env["API_BASE_URL"]}/api/v1/auth';

  Future<void> postLocalSignup(
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

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      log('Response: $responseData');
    } else {
      log('Failed with status code: ${response.statusCode}');
      log('Response: ${response.body}');
      throw Exception('Failed to sign up.');
    }
  }

  Future<void> postLogin(String email, String password) async {
    final url = "$baseurl/sign-in";

    final Map<String, dynamic> data = {"email": email, "password": password};

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode(data),
    );

    CommonRepos.reponsePrint(response);
  }

  Future<void> postSignOut(int uid) async {
    final url = "$baseurl/sign-out?uid=$uid";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    CommonRepos.reponsePrint(response);
  }

  Future<void> postReissue(String refreshToken) async {
    final url = "$baseurl/reissue?refreshToken=$refreshToken";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    CommonRepos.reponsePrint(response);
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
