import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hidi/features/posts/views/post_view.dart';

class DailySongView extends ConsumerStatefulWidget {
  const DailySongView({super.key});

  @override
  ConsumerState<DailySongView> createState() => _DailySongViewState();
}

class _DailySongViewState extends ConsumerState<DailySongView> {
  void _onPost() {
    context.pushNamed(PostView.routeName, pathParameters: {'postId': "1"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(centerTitle: true, title: Text("오늘의 곡")),
            SliverToBoxAdapter(
              child: TextButton(onPressed: _onPost, child: Text("go to post")),
            ),
          ],
        ),
      ),
    );
  }
}
