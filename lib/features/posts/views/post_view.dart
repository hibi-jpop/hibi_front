import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/posts/viewmodels/post_list_viewmodel.dart';
import 'package:hidi/features/posts/viewmodels/post_viewmodel.dart';

class PostView extends ConsumerStatefulWidget {
  static const String routeName = 'posts';
  static const String routeURL = '/posts/:postId';
  final int postId;
  const PostView({super.key, required this.postId});

  @override
  ConsumerState<PostView> createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  Future<void> getPost(int id) async {
    log("start");
    await ref.read(postProvider.notifier).getPost(id);
    log("end");
  }

  Future<void> getPosts() async {
    log("start");
    await ref.read(postsProvider.notifier).getPosts();
    log("end");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("post")),
      body: Column(
        children: [
          TextButton(
            onPressed: () => getPost(widget.postId),
            child: Text("getPost"),
          ),
          TextButton(onPressed: () => getPosts(), child: Text("getPosts")),
        ],
      ),
    );
  }
}
