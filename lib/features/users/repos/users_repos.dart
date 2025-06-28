import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hidi/features/common/common_repos.dart';
import 'package:http/http.dart' as http;

class UsersRepos {
  final baseurl = '${dotenv.env["API_BASE_URL"]}/api/vi/members/me';

  Future<void> getCurrentUser(String accessToken) async {
    final url = baseurl;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    CommonRepos.reponsePrint(response);
  }

  Future<void> deleteCurrentUser(String accessToken) async {
    final url = baseurl;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    CommonRepos.reponsePrint(response);
  }

  Future<void> patchCurrentUser(
    String accessToken,
    String nickname,
    String password,
  ) async {
    final url = baseurl;
    Map<String, String> data = {"nickname": nickname, "password": password};
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(data),
    );
    CommonRepos.reponsePrint(response);
  }
}
