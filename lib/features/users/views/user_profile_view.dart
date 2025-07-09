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

  final String userName = 'Hidi';
  final int followers = 1337;
  final int following = 42;
  final String profileImageUrl = ''; // Intentionally left blank for placeholder

  final List<Map<String, dynamic>> playlists = [
    {'name': 'Liked Songs', 'count': 128, 'icon': Icons.favorite},
    {'name': 'Liked Songs', 'count': 128, 'icon': Icons.favorite},
    {'name': 'Liked Songs', 'count': 128, 'icon': Icons.favorite},
    {'name': 'Liked Songs', 'count': 128, 'icon': Icons.favorite},
    {'name': 'Liked Songs', 'count': 128, 'icon': Icons.favorite},
  ];
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
    // final userState = ref.watch(userProfileProvider);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _buildSliverAppBar(),
            _buildUserInfo(),
            _buildSectionHeader('Public Playlists'),
            _buildPlaylists(),
            // SliverToBoxAdapter(
            //   child: TextButton(
            //     child: Text("SignOut"),
            //     onPressed: () => signOut(10),
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: TextButton(
            //     child: Text("ReIssue"),
            //     onPressed: () => reIssue(),
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       userState.when(
            //         data: (user) {
            //           return Column(
            //             children: [
            //               Text("${user.id}"),
            //               Text("${user.email}"),
            //               Text("${user.nickname}"),
            //             ],
            //           );
            //         },
            //         error:
            //             (error, stackTrace) =>
            //                 Center(child: Text("Error: $error")),
            //         loading:
            //             () =>
            //                 Center(child: CircularProgressIndicator.adaptive()),
            //       ),
            //     ],
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: TextButton(onPressed: deleteUser, child: Text("delete")),
            // ),
            // SliverToBoxAdapter(
            //   child: Column(
            //     children: [
            //       TextField(
            //         controller: _nicknameController,
            //         onChanged: (value) {
            //           formData['nickname'] = value;
            //         },
            //         decoration: InputDecoration(
            //           hintText: "nickname",
            //           // errorText:  ,
            //           suffix: GestureDetector(
            //             onTap: () => _onClearTap(_nicknameController),
            //             child: const FaIcon(FontAwesomeIcons.circleXmark),
            //           ),
            //           enabledBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.grey.shade400),
            //           ),
            //         ),
            //       ),
            //       TextField(
            //         controller: _passwordController,
            //         onChanged: (value) {
            //           formData['password'] = value;
            //         },
            //         decoration: InputDecoration(
            //           hintText: "password",
            //           // errorText:  ,
            //           suffix: GestureDetector(
            //             onTap: () => _onClearTap(_passwordController),
            //             child: const FaIcon(FontAwesomeIcons.circleXmark),
            //           ),
            //           enabledBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.grey.shade400),
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: _onSubmit,
            //         child: FractionallySizedBox(
            //           widthFactor: 1,
            //           child: AnimatedContainer(
            //             duration: Duration(milliseconds: 300),
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(Sizes.size5),
            //               color: Colors.orange.shade300,
            //             ),
            //             child: AnimatedDefaultTextStyle(
            //               style: TextStyle(color: Colors.black),
            //               duration: Duration(milliseconds: 300),
            //               child: Text("edit", textAlign: TextAlign.center),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.0,
      elevation: 0,
      actions: [
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade800, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.teal,
                  child: Text(
                    userName.substring(0, 1),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildUserInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildStatColumn('Followers', followers),
            _buildStatColumn('Following', following),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(number.toString(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4.0),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  SliverToBoxAdapter _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
      ),
    );
  }

  SliverList _buildPlaylists() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final playlist = playlists[index];
        return ListTile(
          leading: Icon(playlist['icon'], size: 30, color: Colors.greenAccent),
          title: Text(
            playlist['name'],
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${playlist['count']} songs',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        );
      }, childCount: playlists.length),
    );
  }
}
