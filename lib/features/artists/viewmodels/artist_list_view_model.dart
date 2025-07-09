import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/artists/models/artist_model.dart';
import 'package:hidi/features/artists/repos/artist_repo.dart';

class ArtistListViewModel extends AsyncNotifier<List<Artist>> {
  late final ArtistRepository _artistRepo;
  @override
  FutureOr<List<Artist>> build() {
    // TODO: implement build
    _artistRepo = ref.read(artistRepo);
    throw UnimplementedError();
  }

  Future<void> getArtists() async {
    state = AsyncValue.loading();
    final artists = await _artistRepo.getArtists();
    state = AsyncValue.data(artists);
  }
}

final artistsProvider =
    AsyncNotifierProvider<ArtistListViewModel, List<Artist>>(
      () => ArtistListViewModel(),
    );
