import 'package:spotify/domain/entities/song/song.dart';

abstract class NewSongsState {}

class NewSongLoading extends NewSongsState {}

class NewSongLoaded extends NewSongsState {
  final List<SongEntity> songs;
  NewSongLoaded({required this.songs});
}
class NewSongLoadFailure extends NewSongsState {}