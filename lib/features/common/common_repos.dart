import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

class CommonRepos {
  static void reponsePrint(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      log('Response: $responseData');
    } else {
      log('Failed with status code: ${response.statusCode}');
      log('Response: ${response.body}');
    }
  }
}
