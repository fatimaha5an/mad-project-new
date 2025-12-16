import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/Songs/songFirebaseService.dart';
import 'package:spotify/domain/repository/songRepo/SongRepo.dart';
import 'package:spotify/service_locater.dart';

class SongRepoImpl extends Songrepo {
  @override
  Future<Either> getPlaylist() async {
    return await sl<Songfirebaseservice>().getPlayList();
  }

  @override
  Future<Either> getNewsSongs() async {
    return await sl<Songfirebaseservice>().getNewSongs();
  }

  @override
  Future<Either> addOrRemoveFavourites(String songId) async {
    return await sl<Songfirebaseservice>().addOrRemoveFavouriteSong(songId);
  }

  @override
  Future<bool> isFavouriteSong(String songId) async {
    return await sl<Songfirebaseservice>().isFavouriteSong(songId);
  }

  @override
  Future<Either> getUserFavouriteSongs() async {
    return await sl<Songfirebaseservice>().getUserFavSong();
  }
}
