import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/authentication/views/login_view.dart';

class SignUpViewmodel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;
  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    state = await AsyncValue.guard(() async {
      await _authRepo.postLocalSignup(
        form["email"],
        form["password"],
        form["nickname"],
      );
    });
    if (state.hasError) {
      log("${state.error}");
    } else {
      context.go(LoginView.routeURL);
    }
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewmodel, void>(
  () => SignUpViewmodel(),
);
