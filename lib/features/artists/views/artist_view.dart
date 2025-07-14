import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtistView extends ConsumerStatefulWidget {
  static const String routeName = 'artists';
  static const String routeURL = '/artists/:artistId';
  final int artistId;

  const ArtistView({super.key, required this.artistId});

  @override
  ConsumerState<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends ConsumerState<ArtistView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ArtistName")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/hebi_ever.jpg"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "ArtistName",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Artist Bio",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Songs by this Artist',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Image.asset(
                      "assets/images/Samekosaba.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text("SongTitle"),
                    subtitle: Text("SongAlbum"),
                    trailing: Text("2025-07-14"),
                    onTap: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
