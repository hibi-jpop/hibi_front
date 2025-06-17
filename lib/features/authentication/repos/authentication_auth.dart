import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  bool get isLoggedIn => false;
}

final authRepo = Provider((ref) => AuthenticationRepository());
