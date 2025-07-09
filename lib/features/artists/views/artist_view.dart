import 'package:flutter/material.dart';

class ArtistView extends StatefulWidget {
  static const String routeName = 'artist';
  static const String routeURL = '/artist/:artistId';
  final String artistId;

  const ArtistView({super.key, required this.artistId});

  @override
  State<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends State<ArtistView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("artist")));
  }
}
