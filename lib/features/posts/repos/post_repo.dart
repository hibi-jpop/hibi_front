import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/posts/models/post_models.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final basehost = '${dotenv.env["API_BASE_URL"]}';
  final basepath = "/api/v1/posts";

  Future<void> getPosts() async {
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
    final data = jsonDecode(response.body)["data"];
    log("data: ${data}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final post = Post.fromJson(data);
    }
  }
}
