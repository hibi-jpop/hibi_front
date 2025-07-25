import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/artists/models/artist_model.dart';
import 'package:hidi/features/artists/repos/artist_repo.dart';

class ArtistViewModel extends AsyncNotifier<Artist> {
  late final ArtistRepository _artistRepo;
  @override
  FutureOr<Artist> build() {
    // TODO: implement build
    _artistRepo = ref.read(artistRepo);
    throw UnimplementedError();
  }

  Future<void> getArtist(int id) async {
    state = AsyncValue.loading();
    final artist = await _artistRepo.getArtistById(id);
    state = AsyncValue.data(artist);
  }
}

final artistProvider = AsyncNotifierProvider<ArtistViewModel, Artist>(
  () => ArtistViewModel(),
);
