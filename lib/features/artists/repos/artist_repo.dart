import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hidi/features/artists/models/artist_model.dart';
import 'package:http/http.dart' as http;

class ArtistRepository {
  final basehost = "${dotenv.env["API_BASE_URL"]}";
  final basepath = "/api/v1/artists";

  Future<Artist> getArtistById(String accessToken, int id) async {
    final Map<String, dynamic> queryParams = {"id": id.toString()};

    final uri = Uri.http(basehost, basepath, queryParams);
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    log("${response.statusCode}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body)["data"];
      log("data : ${data}");
      final artist = Artist.fromJson(data);
      return artist;
    }
    log("Error: getArtistById");
    return Artist.empty();
  }

  Future<List<Artist>> getArtists(String accessToken) async {
    final uri = Uri.http(basehost, basepath);
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    log("${response.statusCode}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body)["data"];
      log("data : ${data}");
      final artists = data.map((json) => Artist.fromJson(json)).toList();
      return artists;
    }
    log("Error :get Artists");
    return [];
  }
}
