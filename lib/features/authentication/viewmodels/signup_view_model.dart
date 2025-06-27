import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hidi/features/authentication/repos/authentication_auth.dart';

class SignUpViewmodel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    state = await AsyncValue.guard(() async {
      await _authRepo.localSignup(
        form["email"],
        form["password"],
        form["nickname"],
      );
    });
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewmodel, void>(
  () => SignUpViewmodel(),
);
