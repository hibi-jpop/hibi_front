import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowView extends ConsumerStatefulWidget {
  const FollowView({super.key});

  @override
  ConsumerState<FollowView> createState() => _FollowViewState();
}

class _FollowViewState extends ConsumerState<FollowView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [SliverAppBar(centerTitle: true, title: Text("팔로우 목록"))],
        ),
      ),
    );
  }
}
