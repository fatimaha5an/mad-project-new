// ignore: file_names
import 'package:dartz/dartz.dart';

abstract class Songrepo {
  Future<Either> getNewsSongs();
  Future<Either> getPlaylist();
  Future<Either> addOrRemoveFavourites(String songId);
  Future<bool> isFavouriteSong(String songId);
  Future<Either> getUserFavouriteSongs();
}
