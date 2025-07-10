import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hidi/features/artists/views/artist_view.dart';
import 'package:hidi/features/daily-song/viewmodels/song_list_viewmodel.dart';
import 'package:hidi/features/daily-song/viewmodels/song_viewmodel.dart';
import 'package:hidi/features/posts/views/post_view.dart';
import 'package:intl/intl.dart';

class DailySongView extends ConsumerStatefulWidget {
  const DailySongView({super.key});

  @override
  ConsumerState<DailySongView> createState() => _DailySongViewState();
}

class _DailySongViewState extends ConsumerState<DailySongView> {
  void _onPost() {
    context.pushNamed(PostView.routeName, pathParameters: {'postId': "1"});
  }

  void _onArtist() {
    context.pushNamed(ArtistView.routeName, pathParameters: {'artistId': "1"});
  }

  Future<void> getSongById(int id) async {
    log("start");
    await ref.read(songProvider.notifier).getSongById(id);
    log("end");
  }

  Future<void> getSongByDate(String date) async {
    log("start");
    await ref.read(songProvider.notifier).getSongByDate(date);
    log("end");
  }

  Future<void> getSongs() async {
    log("start");
    await ref.read(songsProvider.notifier).getSongs();
    log("end");
  }

  Future<void> getSongsByMonthAndYear(int month, int year) async {
    log("start");
    await ref.read(songsProvider.notifier).getSongsByMonthAndYear(month, year);
    log("end");
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
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: _onArtist,
                child: Text("go to artist"),
              ),
            ),
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: () => getSongById(1),
                child: Text("get a song by id"),
              ),
            ),
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: getSongs,
                child: Text("get all songs"),
              ),
            ),
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: () => getSongByDate("2025-07-10"),
                child: Text("get a song by date"),
              ),
            ),
            SliverToBoxAdapter(
              child: TextButton(
                onPressed: () => getSongsByMonthAndYear(7, 2025),
                child: Text("get all songs in specfic month"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
