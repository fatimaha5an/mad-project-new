import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/Songs/getNewSongs.dart';
import 'package:spotify/presentation/pages/home/bloc/new_songs_state.dart';
import 'package:spotify/service_locater.dart';
import 'package:spotify/core/services/favorites_sync_service.dart';
import 'package:spotify/domain/entities/song/song.dart';

class NewSongsCubit extends Cubit<NewSongsState> {
  StreamSubscription? _favoritesSubscription;
  final _favoritesSync = FavoritesSyncService();

  NewSongsCubit() : super(NewSongLoading()) {
    // Listen for favorite changes
    _favoritesSubscription = _favoritesSync.favoritesStream.listen((event) {
      _updateSongFavoriteState(event.songId, event.isFavorite);
    });
  }

  Future<void> getNewSongs() async {
    var returnedSongs = await sl<GetnewsongsUseCase>().call();
    returnedSongs.fold((l) {
      emit(NewSongLoadFailure());
    }, (data) {
      emit(NewSongLoaded(songs: data));
    });
  }

  void _updateSongFavoriteState(String songId, bool isFavorite) {
    final currentState = state;
    if (currentState is NewSongLoaded) {
      final updatedSongs = currentState.songs.map((song) {
        if (song.songId == songId) {
          // Create new song entity with updated favorite status
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
      
      emit(NewSongLoaded(songs: updatedSongs));
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
