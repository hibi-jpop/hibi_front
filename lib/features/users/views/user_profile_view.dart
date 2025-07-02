import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hidi/constants/sizes.dart';
import 'package:hidi/features/authentication/repos/authentication_repo.dart';
import 'package:hidi/features/authentication/viewmodels/login_view_model.dart';
import 'package:hidi/features/users/viewmodels/user_profile_view_model.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  late final TextEditingController _nicknameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
  }

  void signOut(int id) async {
    await ref.read(loginProvider.notifier).signOut(context, id);
  }

  void reIssue() async {
    await ref.read(authRepo).postReissue();
  }

  void _onClearTap(TextEditingController controller) {
    controller.clear();
  }

  void _onSubmit() async {
    await ref
        .read(userProfileProvider.notifier)
        .patchCurrentUser(formData["nickname"], formData["password"]);
  }

  void deleteUser() async {
    await ref.read(userProfileProvider.notifier).deleteCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProfileProvider);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(centerTitle: true, title: Text("마이페이지")),
            SliverToBoxAdapter(
              child: TextButton(
                child: Text("SignOut"),
                onPressed: () => signOut(10),
              ),
            ),
            SliverToBoxAdapter(
              child: TextButton(
                child: Text("ReIssue"),
                onPressed: () => reIssue(),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  userState.when(
                    data: (user) {
                      return Column(
                        children: [
                          Text("${user.id}"),
                          Text("${user.email}"),
                          Text("${user.nickname}"),
                        ],
                      );
                    },
                    error:
                        (error, stackTrace) =>
                            Center(child: Text("Error: $error")),
                    loading:
                        () =>
                            Center(child: CircularProgressIndicator.adaptive()),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: TextButton(onPressed: deleteUser, child: Text("delete")),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  TextField(
                    controller: _nicknameController,
                    onChanged: (value) {
                      formData['nickname'] = value;
                    },
                    decoration: InputDecoration(
                      hintText: "nickname",
                      // errorText:  ,
                      suffix: GestureDetector(
                        onTap: () => _onClearTap(_nicknameController),
                        child: const FaIcon(FontAwesomeIcons.circleXmark),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    onChanged: (value) {
                      formData['password'] = value;
                    },
                    decoration: InputDecoration(
                      hintText: "password",
                      // errorText:  ,
                      suffix: GestureDetector(
                        onTap: () => _onClearTap(_passwordController),
                        child: const FaIcon(FontAwesomeIcons.circleXmark),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _onSubmit,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizes.size5),
                          color: Colors.orange.shade300,
                        ),
                        child: AnimatedDefaultTextStyle(
                          style: TextStyle(color: Colors.black),
                          duration: Duration(milliseconds: 300),
                          child: Text("edit", textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
