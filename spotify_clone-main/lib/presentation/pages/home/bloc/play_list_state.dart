import 'package:spotify/domain/entities/song/song.dart';

abstract class PlayListState {}

class PlayListLoading extends PlayListState {}

class PlayListLoaded extends PlayListState {
  final List<SongEntity> song;
  PlayListLoaded({required this.song});
}
class PlayListLoadFailure extends PlayListState {}
