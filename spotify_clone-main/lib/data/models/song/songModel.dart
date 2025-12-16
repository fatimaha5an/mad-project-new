import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/song/song.dart';

class Songmodel {
  String? title;
  String? artist;
  num? duration;
  Timestamp? releaseDate;
  bool ? isFavourite;
  String? songId;

  Songmodel(
      {required this.artist,
      required this.duration,
      required this.title,
      required this.releaseDate,
      required this.isFavourite,
      required this.songId});

  Songmodel.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    artist = data['artist'];
    duration = data['duration'];
    releaseDate = data['releaseDate'];
  }
}

extension SongmodelX on Songmodel{
  SongEntity toEntity(){
    return SongEntity(
      artist: artist!,
       duration: duration!,
        title: title!,
         releaseDate: releaseDate!,
         isFavourite: isFavourite!,
         songId: songId!,
         );
  }
}