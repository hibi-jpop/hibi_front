import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/common/common_repos.dart';
import 'package:hidi/features/users/models/user.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final basehost = '${dotenv.env["API_BASE_URL"]}';
  final basepath = "/api/v1/members/me";

  Future<User> getCurrentUser(String accessToken) async {
    final uri = Uri.http(basehost, basepath);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    log("${response.statusCode}");
    final data = jsonDecode(response.body)["data"];
    log("data : ${data}");
    final user = User.fromJson(data);
    return user;
  }

  Future<void> deleteCurrentUser(Ref ref, String accessToken) async {
    final _authRepo = ref.read(authRepo);
    final uri = Uri.http(basehost, basepath);
    final response = await http.delete(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      await _authRepo.tokensClear();
    }

    CommonRepos.reponsePrint(response);
  }

  Future<void> patchCurrentUser(
    String accessToken,
    String nickname,
    String password,
  ) async {
    final uri = Uri.http(basehost, basepath);

    Map<String, dynamic> body = {"nickname": nickname, "password": password};
    final response = await http.patch(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body)["data"];
    log("${data}");
  }
}

final userRepo = Provider((ref) => UserRepository());
