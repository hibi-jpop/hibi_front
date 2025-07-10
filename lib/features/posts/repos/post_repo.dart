import 'dart:convert';
import 'dart:developer';

import 'package:hidi/env.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/posts/models/post_models.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final basehost = Env.basehost;
  final basepath = "/api/v1/posts";

  Future<Post> getPost(int id) async {
    final uri = Uri.http(basehost, "${basepath}/$id");
    log("${uri}");
    final response = await AuthenticationRepository.requestWithRetry(
      (accessToken) => http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      ),
    );

    log("${response.statusCode}");
    final data = jsonDecode(response.body)["data"];
    log("data: ${data}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final post = Post.fromJson(data);
      return Post.empty();
    } else {
      log("Error :get Artists");
      return Post.empty();
    }
  }

  Future<List<Post>> getPosts() async {
    final uri = Uri.http(basehost, basepath);
    final response = await AuthenticationRepository.requestWithRetry(
      (accessToken) => http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    log("${response.statusCode}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body)["data"];
      log("data : ${data}");
      final posts = data.map((json) => Post.fromJson(json)).toList();
      // TODO : test용 post로 변경ㅈ미
      return [];
    } else {
      log("Error :get Artists");
      return [];
    }
  }
}
