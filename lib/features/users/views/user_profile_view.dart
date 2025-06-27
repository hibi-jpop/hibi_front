import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [SliverAppBar(centerTitle: true, title: Text("마이페이지"))],
        ),
      ),
    );
  }
}
