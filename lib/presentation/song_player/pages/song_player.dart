import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player_view.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SongPlayerCubit()
        ..loadSong(
          '${AppUrls.songfirestorage}${songEntity.artist} - ${songEntity.title}.mp3?${AppUrls.mediaAlt}',
          songEntity.title,
        ),
      child: SongPlayerView(song: songEntity),
    );
  }
}
