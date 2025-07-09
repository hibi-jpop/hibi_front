import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hidi/features/users/models/user.dart';
import 'package:hidi/features/users/repos/users_repos.dart';
import 'package:http/http.dart' as http;

typedef TokenFunction<T> = Future<T> Function(String token);

class AuthenticationRepository {
  final basehost = '${dotenv.env["API_BASE_URL"]}';
  final basepath = '/api/v1/auth';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final UserRepository userRepo = UserRepository();
  String? _accessToken;
  User? _user;

  Future<void> initToken() async {
    _accessToken = await _secureStorage.read(key: "accessToken");
  }

  bool get isLoggedIn => _accessToken != null;
  String? get accessToken => _accessToken;
  User? get user => _user;

  Future<bool> postLocalSignup(
    String email,
    String password,
    String nickname,
  ) async {
    final uri = Uri.http(basehost, "$basepath/sign-up");

    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "nickname": nickname,
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    log("${response.statusCode}");
    final resBody = jsonDecode(response.body);
    log("body : ${resBody}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return resBody["success"];
    } else {
      log("Error: postLocalSignup");
      return false;
    }
  }

  Future<void> postSignin(String email, String password) async {
    final uri = Uri.http(basehost, "$basepath/sign-in");

    final Map<String, dynamic> body = {"email": email, "password": password};
    final response = await http.post(
      uri,
      headers: {'Content-Type': "application/json"},
      body: jsonEncode(body),
    );

    log("${response.statusCode}");
    final resBody = jsonDecode(response.body);
    log("body : ${resBody}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = resBody["data"];
      await tokenSaves(data["accessToken"], data["refreshToken"]);
      _accessToken = data["accessToken"];
      _user = await userRepo.getCurrentUser(_accessToken!);
    }
    log("Error: postSignin");
  }

  Future<void> postSignOut(int uid) async {
    final Map<String, dynamic> queryParams = {"memberId": uid.toString()};

    final uri = Uri.http(basehost, "$basepath/sign-out", queryParams);

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode <= 200 && response.statusCode > 300) {
      await tokensClear();
    }

    log("Error: postSignOut");
    // CommonRepos.reponsePrint(response);
  }

  Future<bool> postReissue() async {
    final _refreshToken = await _secureStorage.read(key: "refreshToken");
    log("${_refreshToken}");

    log("old");
    log("${_accessToken}");
    final Map<String, dynamic> queryParams = {"refreshToken": _refreshToken};
    final uri = Uri.http(basehost, "$basepath/reissue", queryParams);

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    log("${response.statusCode}");
    final resBody = jsonDecode(response.body);
    log("body : ${resBody}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(resBody)["data"];
      final accessToken = data["accessToken"];

      await _secureStorage.write(key: "accessToken", value: accessToken);
      _accessToken = accessToken;
      log("new");
      log("${_accessToken}");
      return resBody["success"];
    }
    log("Error: postReissue");
    return false;
  }

  Future<bool> checkEmail(String email) async {
    log("checkEmail");
    final Map<String, dynamic> queryParams = {"email": email};
    final uri = Uri.http(basehost, "$basepath/check-email", queryParams);

    final response = await http.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );
    log("${response.statusCode}");
    final resBody = jsonDecode(response.body);
    log("body : ${resBody}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return resBody["success"];
    } else {
      log("Error: checkEmail");
      return false;
    }
  }

  Future<bool> checkNickname(String nickname) async {
    final Map<String, dynamic> queryParams = {"nickname": nickname};
    final uri = Uri.http(basehost, "$basepath/check-nickname", queryParams);

    final response = await http.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    log("${response.statusCode}");
    final resBody = jsonDecode(response.body);
    log("body : ${resBody}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return resBody["success"];
    } else {
      log("Error: checkNickname");
      return false;
    }
  }

  Future<void> tokenSaves(String accessToken, String refreshToken) async {
    await Future.wait([
      _secureStorage.write(key: "accessToken", value: accessToken),
      _secureStorage.write(key: "refreshToken", value: refreshToken),
    ]);
  }

  Future<void> tokensClear() async {
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

  Future<T> requestWithRetry<T>(TokenFunction request) async {
    final accessToken = _accessToken;
    if (accessToken == null) {
      throw Exception("No access token.");
    }
    final isExpired = isAccessTokenExpired(accessToken);
    if (!isExpired) {
      return await request(accessToken);
    } else {
      await postReissue();
      final newaccessToken = _accessToken;
      if (newaccessToken == null) {
        throw Exception("No new accessToken.");
      } else {
        return await request(newaccessToken);
      }
    }
  }
}

final authRepo = Provider<AuthenticationRepository>((ref) {
  throw UnimplementedError();
});
