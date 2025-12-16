import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/Songs/getNewSongs.dart';
import 'package:spotify/presentation/pages/home/bloc/new_songs_state.dart';
import 'package:spotify/service_locater.dart';

class NewSongsCubit extends Cubit<NewSongsState> {
  NewSongsCubit() : super(NewSongLoading());

  Future<void> getNewSongs() async {
    var returnedSongs = await sl<GetnewsongsUseCase>().call();
    returnedSongs.fold((l) {
      emit(
        NewSongLoadFailure(),
      );
    }, (data) {
      emit(
        NewSongLoaded(songs: data),
      );
    });
  }
}
