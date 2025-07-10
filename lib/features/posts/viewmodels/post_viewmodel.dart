import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/posts/models/post_models.dart';

class PostViewmodel extends AsyncNotifier<Post> {
  @override
  FutureOr<Post> build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}

final postProvider = AsyncNotifierProvider<PostViewmodel, Post>(
  () => PostViewmodel(),
);
