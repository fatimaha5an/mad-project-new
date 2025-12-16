import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/core/services/hive_service.dart';
import 'package:spotify/features/profile/data/models/listening_event.dart';
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

  void seekSong(Duration position) {
    audioPlayer.seek(position);
  }

  String? currentSongTitle;

  Future<void> loadSong(String url, String title) async {
    //print('URL LOADED :  $url');
    currentSongTitle = title;
    try {
      if (audioPlayer.playing) {
        logEvent(title); // Log previous song if strictly following "completes or next", but loading new song implies next.
      }
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

  void logEvent(String title) {
    try {
      final event = ListeningEvent(songTitle: title, timestamp: DateTime.now());
      HiveService.listeningStatsBox.add(event);
      print("Logged ListeningEvent: $title");
    } catch (e) {
      print("Error logging stats: $e");
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
