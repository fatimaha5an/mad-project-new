import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });
    audioPlayer.durationStream.listen((duration) {
      songDuration = duration!;
    });
  }

  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }
  void next(){
    audioPlayer.seekToNext();
    emit(SongPlayerNext());
  }
  void previous(){
    audioPlayer.seekToPrevious();
    emit(SongPlayerPrevious());
  }

  Future<void> loadSong(String url) async {
    //print('URL LOADED :  $url');
    try {
      await audioPlayer.setUrl(url);
      emit(
        SongPlayerLoaded(),
      );
    } catch (e) {
      print('Song Player failure due to:: $e');
      emit(
        SongPlayerFailure(),
      );
    }
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.stop();
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }
}
