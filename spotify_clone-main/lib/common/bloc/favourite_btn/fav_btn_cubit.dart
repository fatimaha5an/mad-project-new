import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favourite_btn/fav_btn_state.dart';
import 'package:spotify/domain/usecases/Songs/get_add_or_remove_fav_songs.dart';
import 'package:spotify/service_locater.dart';

class FavBtnCubit extends Cubit<FavBtnState>{
  FavBtnCubit():super(FavBtnInit());
  void favBtnUpdated(String songId) async{
    var result = await sl<AddOrRemoveFavSongsUseCase>().call(params: songId);
  result.fold(
    (l){},
   (isFavorite){
    emit(FavBtnUpdated(isFav: isFavorite));
   }
   );
  }
}