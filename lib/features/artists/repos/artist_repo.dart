import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ArtistRepository {
  final basehost = "${dotenv.env["API_BASE_URL"]}";
  final basepath = "/api/v1/artists";

  Future<void> getArtistById(int id) async {
    final Map<String, dynamic> queryParams = {"id": id.toString()};

    final uri = Uri.http(basehost, basepath, queryParams);
    await http.get(uri, headers: {"Content-Type": "application/json"});
  }
}
