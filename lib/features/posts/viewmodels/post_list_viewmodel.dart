import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/posts/models/post_models.dart';
import 'package:hidi/features/posts/repos/post_repo.dart';

class PostListViewmodel extends AsyncNotifier<List<Post>> {
  late final PostRepository _postRepo;
  @override
  FutureOr<List<Post>> build() {
    // TODO: implement build
    _postRepo = PostRepository();
    throw UnimplementedError();
  }

  Future<void> getPosts() async {
    state = AsyncValue.loading();
    final posts = await _postRepo.getPosts();
    state = AsyncValue.data(posts);
  }
}

final postsProvider = AsyncNotifierProvider<PostListViewmodel, List<Post>>(
  () => PostListViewmodel(),
);
