import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/Songs/get_fav_song.dart';
import 'package:spotify/presentation/pages/profile/bloc/fav_songs_state.dart';
import 'package:spotify/service_locater.dart';
import 'package:spotify/core/services/favorites_sync_service.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  StreamSubscription? _favoritesSubscription;
  final _favoritesSync = FavoritesSyncService();

  FavoriteSongsCubit() : super(FavoriteSongsLoading()) {
    _favoritesSubscription = _favoritesSync.favoritesStream.listen((event) {
      _handleFavoriteChange(event.songId, event.isFavorite);
    });
  }

  List<SongEntity> favoriteSongs = [];

  Future<void> getFavoriteSongs() async {
    var result = await sl<GetFavoriteSongsUseCase>().call();
    result.fold((l) {
      emit(FavoriteSongsFailure());
    }, (r) {
      favoriteSongs = r;
      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    });
  }

  void _handleFavoriteChange(String songId, bool isFavorite) {
    if (!isFavorite) {
      // Song was unfavorited - remove it from the list
      favoriteSongs.removeWhere((song) => song.songId == songId);
      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    }
  }

  void removeSong(int index) {
    if (index >= 0 && index < favoriteSongs.length) {
      favoriteSongs.removeAt(index);
      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    }
  }

  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
