import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/posts/models/post_models.dart';
import 'package:hidi/features/posts/repos/post_repo.dart';

class PostViewmodel extends AsyncNotifier<Post> {
  late final PostRepository _postRepo;
  @override
  FutureOr<Post> build() {
    // TODO: implement build
    _postRepo = PostRepository();
    throw UnimplementedError();
  }

  Future<void> getPost(int id) async {
    state = AsyncValue.loading();
    final post = await _postRepo.getPost(id);
    state = AsyncValue.data(post);
  }
}

final postProvider = AsyncNotifierProvider<PostViewmodel, Post>(
  () => PostViewmodel(),
);
