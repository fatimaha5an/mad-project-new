import 'dart:async';

/// Service to synchronize favorite song state across the entire app
/// Uses a broadcast stream to notify all listeners when a song is liked/unliked
class FavoritesSyncService {
  static final FavoritesSyncService _instance = FavoritesSyncService._internal();
  factory FavoritesSyncService() => _instance;
  FavoritesSyncService._internal();

  final _favoritesController = StreamController<FavoriteSongEvent>.broadcast();

  /// Stream that emits favorite song events
  Stream<FavoriteSongEvent> get favoritesStream => _favoritesController.stream;

  /// Notify all listeners that a song's favorite status changed
  void notifyFavoriteChanged(String songId, bool isFavorite) {
    if (!_favoritesController.isClosed) {
      _favoritesController.add(FavoriteSongEvent(
        songId: songId,
        isFavorite: isFavorite,
      ));
    }
  }

  /// Dispose the stream controller
  void dispose() {
    _favoritesController.close();
  }
}

/// Event representing a favorite song state change
class FavoriteSongEvent {
  final String songId;
  final bool isFavorite;

  FavoriteSongEvent({
    required this.songId,
    required this.isFavorite,
  });
}
