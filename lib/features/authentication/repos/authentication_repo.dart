import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hidi/features/common/common_repos.dart';
import 'package:http/http.dart' as http;

class AuthenticationRepository {
  final baseurl = '${dotenv.env["API_BASE_URL"]}/api/v1/auth';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  

  Future<bool> isLoggedIn() async {
    final accessToken = await _secureStorage.read(key: "accessToken");
    final refreshToken = await _secureStorage.read(key: "refreshToken");
    if (accessToken == null || refreshToken == null) {
      return false;
    }
    final isLoggedIn = await postReissue(refreshToken);
    log("$isLoggedIn");
    if (!isLoggedIn) {
      return false;
    }
    return true;
  }

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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body)["data"];
      await tokenSaves(data["accessToken"], data["refreshToken"]);
    }
  }

  Future<void> postSignOut(int uid) async {
    final url = "$baseurl/sign-out?uid=$uid";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    await tokensClear();
    CommonRepos.reponsePrint(response);
  }

  Future<bool> postReissue(String refreshToken) async {
    final url = "$baseurl/reissue?refreshToken=$refreshToken";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }
    return false;
  }

  Future<void> tokenSaves(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: "accessToken", value: accessToken);
    await _secureStorage.write(key: "refreshToken", value: refreshToken);
  }

  Future<void> tokensClear() async {
    await _secureStorage.deleteAll();
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
