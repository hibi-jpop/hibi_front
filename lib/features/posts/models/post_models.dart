import 'package:hidi/features/artists/models/artist_model.dart';

class Post {
  final int id;
  final String title;
  final String bio;
  final String songUrl;
  final DateTime postedAt;
  final Artist artist;

  Post({
    required this.id,
    required this.title,
    required this.bio,
    required this.songUrl,
    required this.postedAt,
    required this.artist,
  });

  Post.empty()
    : id = 0,
      title = "title hibi",
      bio = "bio hibi",
      songUrl = "",
      postedAt = DateTime.now(),
      artist = Artist.empty();

  Post copyWith({
    int? id,
    String? title,
    String? bio,
    String? songUrl,
    DateTime? postedAt,
    Artist? artist,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      songUrl: songUrl ?? this.songUrl,
      postedAt: postedAt ?? this.postedAt,
      artist: artist ?? this.artist,
    );
  }

  Post.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      bio = json['bio'],
      songUrl = json['songUrl'],
      postedAt = DateTime.parse(json['postedAt']),
      artist = Artist.fromJson(json['artist']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'bio': bio,
      'songUrl': songUrl,
      'postedAt':
          "${postedAt.year.toString().padLeft(4, '0')}-${postedAt.month.toString().padLeft(2, '0')}-${postedAt.day.toString().padLeft(2, '0')}",
      'artist': artist.toJson(),
    };
  }
}
