import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidi/features/artists/viewmodels/artist_list_view_model.dart';
import 'package:hidi/features/artists/viewmodels/artist_view_model.dart';

class ArtistView extends ConsumerStatefulWidget {
  static const String routeName = 'artist';
  static const String routeURL = '/artist/:artistId';
  final int artistId;

  const ArtistView({super.key, required this.artistId});

  @override
  ConsumerState<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends ConsumerState<ArtistView> {
  Future<void> getArtist(int id) async {
    log("start");
    await ref.read(artistProvider.notifier).getArtist(id);
    log("end");
  }

  Future<void> getArtists() async {
    log("start");
    await ref.read(artistsProvider.notifier).getArtists();
    log("end");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("artist")),
      body: Column(
        children: [
          TextButton(
            onPressed: () => getArtist(widget.artistId),
            child: Text("get an artist"),
          ),
          TextButton(onPressed: getArtists, child: Text("get all artists")),
        ],
      ),
    );
  }
}
