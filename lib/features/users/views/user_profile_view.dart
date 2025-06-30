import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/authentication/viewmodels/login_view_model.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  

  void signOut() async {
    await ref.read(LoginProvider.notifier).SignOut(context, 10);
  }

  void reIssue() async {
    await ref.read(authRepo).postReissue();
  }

  void getCurrentUser() async {
    await ref.read(User)
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(centerTitle: true, title: Text("마이페이지")),
            SliverToBoxAdapter(
              child: TextButton(
                child: Text("SignOut"),
                onPressed: () => signOut(),
              ),
            ),
            SliverToBoxAdapter(
              child: TextButton(
                child: Text("ReIssue"),
                onPressed: () => reIssue(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
