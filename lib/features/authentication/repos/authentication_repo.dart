import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

typedef TokenFunction = Future<void> Function(String token);

class AuthenticationRepository {
  final baseurl = '${dotenv.env["API_BASE_URL"]}/api/v1/auth';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _accessToken;

  Future<void> initToken() async {
    _accessToken = await _secureStorage.read(key: "accessToken");
  }

  bool get isLoggedIn => _accessToken != null;
  String? get accessToken => _accessToken;

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

  Future<void> postSignin(String email, String password) async {
    final url = "$baseurl/sign-in";

    final Map<String, dynamic> data = {"email": email, "password": password};

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body)["data"];
      log("$data");
      log("tokens");
      await tokenSaves(data["accessToken"], data["refreshToken"]);
      _accessToken = data["accessToken"];
      log("test");
    }
  }

  Future<void> postSignOut(int uid) async {
    final url = "$baseurl/sign-out?memberId=$uid";
    log("accessToken : ${_accessToken}");
    // final response = await http.post(
    //   Uri.parse(url),
    //   headers: {
    //     "Content-Type": "application/json",
    //     "Authorization": "Bearer $_accessToken",
    //   },
    // );
    await tokensClear();
    // CommonRepos.reponsePrint(response);
  }

  Future<bool> postReissue() async {
    final _refreshToken = await _secureStorage.read(key: "refreshToken");
    log("${_refreshToken}");

    log("old");
    log("${_accessToken}");
    final url = "$baseurl/reissue?refreshToken=$_refreshToken";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body)["data"];
      final accessToken = data["accessToken"];

      await _secureStorage.write(key: "accessToken", value: accessToken);
      _accessToken = accessToken;
      log("new");
      log("${_accessToken}");
      return true;
    }
    return false;
  }

  Future<void> tokenSaves(String accessToken, String refreshToken) async {
    await Future.wait([
      _secureStorage.write(key: "accessToken", value: accessToken),
      _secureStorage.write(key: "refreshToken", value: refreshToken),
    ]);
    log("finished");
  }

  Future<void> tokensClear() async {
    log("test");
    await _secureStorage.deleteAll();
    _accessToken = null;
  }

  bool isAccessTokenExpired(String token) {
    final parts = token.split(".");
    if (parts.length != 3) return true;

    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    final exp = payload["exp"] as int;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return exp < now;
  }

  Future<void> requestWithRetry(TokenFunction request) async {
    final accessToken = _accessToken;
    if (accessToken == null) {
      throw Exception("No access token.");
    }
    final isExpired = isAccessTokenExpired(accessToken);
    if (!isExpired) {
      await request(accessToken);
    } else {
      await postReissue();
      final newaccessToken = _accessToken;
      if (newaccessToken == null) {
        throw Exception("No new accessToken.");
      } else {
        await request(newaccessToken);
      }
    }
  }
}

final authRepo = Provider<AuthenticationRepository>((ref) {
  throw UnimplementedError();
});
