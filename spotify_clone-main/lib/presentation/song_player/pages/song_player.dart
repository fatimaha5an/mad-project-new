import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

import '../../../common/widgets/fav_btn/fav_btn.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text(
          'Now Playing',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        action: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.primary,
            )),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()
          ..loadSong(
              '${AppUrls.songfirestorage}${songEntity.artist} - ${songEntity.title}.mp3?${AppUrls.mediaAlt}'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _songCover(context),
              const SizedBox(
                height: 16,
              ),
              _songDetail(),
              const SizedBox(
                height: 10,
              ),
              _songPlayer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              '${AppUrls.coverfirestorage}${songEntity.artist} - ${songEntity.title}.png?${AppUrls.mediaAlt}'),
        ),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              songEntity.artist,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            ),
            const SizedBox(height: 2),
          ],
        ),
        FavBtn(
          songEntity: songEntity,
        ),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
        builder: (context, state) {
      if (state is SongPlayerLoading) {
        print('song player loading');
        return const CircularProgressIndicator();
      }
      if (state is SongPlayerFailure) {
        print('Song Player FAULURE>>>>>>');
      }
      if (state is SongPlayerLoaded) {
        print('song player Loaded');
        return Column(
          children: [
            Slider(
              activeColor:
                  context.isDarkMode ? AppColors.primary : AppColors.dark_bg,
              value: context
                  .read<SongPlayerCubit>()
                  .songPosition
                  .inSeconds
                  .toDouble(),
              min: 0.0,
              max: context
                  .read<SongPlayerCubit>()
                  .songDuration
                  .inSeconds
                  .toDouble(),
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDuration(
                    context.read<SongPlayerCubit>().songPosition)),
                Text(formatDuration(
                    context.read<SongPlayerCubit>().songDuration)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_previous_outlined,
                    size: 40,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<SongPlayerCubit>().playOrPauseSong();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: Icon(
                          context.read<SongPlayerCubit>().audioPlayer.playing
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_next_outlined,
                    size: 40,
                  ),
                ),
              ],
            )
          ],
        );
      }
      return Container();
    });
  }

  String formatDuration(Duration dur) {
    final minute = dur.inMinutes.remainder(60);
    final seconds = dur.inSeconds.remainder(60);
    return '${minute.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
