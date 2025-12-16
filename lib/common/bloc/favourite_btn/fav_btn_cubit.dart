import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favourite_btn/fav_btn_state.dart';
import 'package:spotify/domain/usecases/Songs/get_add_or_remove_fav_songs.dart';
import 'package:spotify/service_locater.dart';
import 'package:spotify/core/services/favorites_sync_service.dart';

class FavBtnCubit extends Cubit<FavBtnState> {
  FavBtnCubit() : super(FavBtnInit());
  
  final _favoritesSync = FavoritesSyncService();
  
  void favBtnUpdated(String songId) async {
    var result = await sl<AddOrRemoveFavSongsUseCase>().call(params: songId);
    result.fold(
      (l) {},
      (isFavorite) {
        // Emit state for this button
        emit(FavBtnUpdated(isFav: isFavorite));
        
        // Broadcast to all listeners across the app
        _favoritesSync.notifyFavoriteChanged(songId, isFavorite);
      },
    );
  }
}