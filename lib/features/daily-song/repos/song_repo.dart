import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/daily-song/models/song_model.dart';
import 'package:http/http.dart' as http;

class SongRepository {
  final basehost = '${dotenv.env["API_BASE_URL"]}';
  final basepath = "/api/v1/songs";

  // user
  Future<Song?> getSongById(int id) async {
    final Map<String, dynamic> queryParams = {"id": id};

    final uri = Uri.http(basehost, basepath, queryParams);
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
    log("data : ${data}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final song = Song.fromJson(data);
      return song;
    }

    log("Error :getSongById");
    return null;
  }

  Future<List<Song>> getSongs() async {
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
      final songs = data.map((json) => Song.fromJson(json)).toList();
      return songs;
    }
    log("Error :getSongs");
    return [];
  }

  //  날짜(date) 형식 yyyy-MM-dd
  Future<Song?> getSongByDate(String date) async {
    final Map<String, dynamic> queryParams = {"date": date};

    final uri = Uri.http(basehost, "$basepath/by-date", queryParams);
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
    log("data : ${data}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final song = Song.fromJson(data);
      return song;
    }

    log("Error :getSongByDate");
    return null;
  }

  Future<List<Song>> getSongsByMonthAndYear(int month, int year) async {
    final Map<String, dynamic> queryParams = {"month": month, "year": year};

    final uri = Uri.http(basehost, "$basepath/by-month", queryParams);
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
      final songs = data.map((json) => Song.fromJson(json)).toList();
      return songs;
    }
    log("Error :getSongsByMonthAndYear");
    return [];
  }
}

final songRepo = Provider((ref) => SongRepository());
