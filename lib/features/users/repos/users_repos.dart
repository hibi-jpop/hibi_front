import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/common/common_repos.dart';
import 'package:hidi/features/users/models/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final baseurl = '${dotenv.env["API_BASE_URL"]}/api/v1/members/me';
  Future<User> getCurrentUser(String accessToken) async {
    final url = baseurl;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    final data = jsonDecode(response.body)["data"];
    log("${data}");
    final updateduser = User.fromJson(data);
    return updateduser;
  }

  Future<void> deleteCurrentUser(Ref ref, String accessToken) async {
    final _authRepo = ref.read(authRepo);
    final url = baseurl;
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      _authRepo.tokensClear();
    }

    CommonRepos.reponsePrint(response);
  }

  Future<void> patchCurrentUser(
    String accessToken,
    String nickname,
    String password,
  ) async {
    final url = baseurl;
    Map<String, dynamic> json = {"nickname": nickname, "password": password};
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(json),
    );

    final data = jsonDecode(response.body)["data"];
    log("${data}");
  }
}

final userRepo = Provider((ref) => UserRepository());
