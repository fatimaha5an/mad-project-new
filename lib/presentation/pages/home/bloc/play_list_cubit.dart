import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/Songs/get_playList.dart';
import 'package:spotify/presentation/pages/home/bloc/play_list_state.dart';
import 'package:spotify/service_locater.dart';
import 'package:spotify/core/services/favorites_sync_service.dart';
import 'package:spotify/domain/entities/song/song.dart';

class PlayListCubit extends Cubit<PlayListState> {
  StreamSubscription? _favoritesSubscription;
  final _favoritesSync = FavoritesSyncService();

  PlayListCubit() : super(PlayListLoading()) {
    _favoritesSubscription = _favoritesSync.favoritesStream.listen((event) {
      _updateSongFavoriteState(event.songId, event.isFavorite);
    });
  }

  Future<void> getPlayList() async {
    var returnedSongs = await sl<GetPlaylistUseCase>().call();
    returnedSongs.fold((l) {
      emit(PlayListLoadFailure());
    }, (data) {
      emit(PlayListLoaded(song: data));
    });
  }

  void _updateSongFavoriteState(String songId, bool isFavorite) {
    final currentState = state;
    if (currentState is PlayListLoaded) {
      final updatedSongs = currentState.song.map((song) {
        if (song.songId == songId) {
          return SongEntity(
            songId: song.songId,
            title: song.title,
            artist: song.artist,
            duration: song.duration,
            releaseDate: song.releaseDate,
            isFavourite: isFavorite,
          );
        }
        return song;
      }).toList();
      
      emit(PlayListLoaded(song: updatedSongs));
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
