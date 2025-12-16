import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/common/widgets/fav_btn/fav_btn.dart';

// --- LOCAL COLOR PALETTE (Quavo Theme) ---
class _QuavoColors {
  static const red = Color(0xFF9B2226);
  static const darkRed = Color(0xFF5E1517);
  static const pink = Color(0xFFE9D8A6);
  static const gamboge = Color(0xFFEE9B00);
  static const black = Color(0xFF001219);
}

class SongPlayerView extends StatelessWidget {
  final SongEntity song;

  const SongPlayerView({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND LAYER
          _buildBackground(),

          // 2. CONTENT LAYER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                children: [
                  _buildAppBar(context),
                  const Spacer(flex: 1),
                  _buildAlbumArt(),
                  const Spacer(flex: 1),
                  _buildTrackInfo(context),
                  const SizedBox(height: 32),
                  _buildProgressBar(context),
                  const SizedBox(height: 16),
                  _buildControls(context),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        // Gradient Base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_QuavoColors.red, _QuavoColors.red, _QuavoColors.darkRed],
            ),
          ),
        ),
        // Ghost Overlay (Album Art Blown Up)
        Positioned.fill(
          child: Opacity(
            opacity: 0.3,
            child: Image.network(
              '${AppUrls.coverfirestorage}${song.artist} - ${song.title}.png?${AppUrls.mediaAlt}',
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Container(color: _QuavoColors.darkRed),
            ),
          ),
        ),
        // Blend Mode Overlay
        Positioned.fill(
          child: Container(
            color: _QuavoColors.red.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.expand_more, color: _QuavoColors.pink, size: 30),
        ),
        const Text(
          "NOW PLAYING",
          style: TextStyle(
            color: _QuavoColors.pink,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: _QuavoColors.pink, size: 28),
        ),
      ],
    );
  }

  Widget _buildAlbumArt() {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF001219).withOpacity(0.8),
            offset: const Offset(0, 30),
            blurRadius: 60,
            spreadRadius: -15,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          '${AppUrls.coverfirestorage}${song.artist} - ${song.title}.png?${AppUrls.mediaAlt}',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: _QuavoColors.darkRed,
              child: const Icon(Icons.music_note, color: _QuavoColors.pink, size: 80),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrackInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _QuavoColors.pink,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _QuavoColors.gamboge,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        FavBtn(songEntity: song),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final cubit = context.read<SongPlayerCubit>();
        final duration = cubit.songDuration;
        final position = cubit.songPosition;

        if (state is SongPlayerLoading) {
          return Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _QuavoColors.pink,
                  inactiveTrackColor: _QuavoColors.black,
                  thumbColor: _QuavoColors.gamboge,
                  trackHeight: 4.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                ),
                child: const Slider(
                  value: 0,
                  min: 0.0,
                  max: 1.0,
                  onChanged: null,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "00:00",
                      style: TextStyle(
                        color: _QuavoColors.pink,
                        fontSize: 12,
                        fontFamily: 'Monospace',
                      ),
                    ),
                    Text(
                      "00:00",
                      style: TextStyle(
                        color: _QuavoColors.pink,
                        fontSize: 12,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _QuavoColors.pink,
                inactiveTrackColor: _QuavoColors.black,
                thumbColor: _QuavoColors.gamboge,
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
                min: 0.0,
                max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 1.0,
                onChanged: (value) {
                  cubit.seekSong(Duration(seconds: value.toInt()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(
                      color: _QuavoColors.pink,
                      fontSize: 12,
                      fontFamily: 'Monospace',
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(
                      color: _QuavoColors.pink,
                      fontSize: 12,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControls(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final cubit = context.read<SongPlayerCubit>();
        final isPlaying = cubit.audioPlayer.playing;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Shuffle
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shuffle, color: _QuavoColors.black.withOpacity(0.7), size: 28),
            ),

            // Previous
            IconButton(
              onPressed: () {
                cubit.previous();
              },
              icon: const Icon(Icons.skip_previous, color: _QuavoColors.black, size: 40),
            ),

            // THE BLACK HOLE (Play/Pause)
            GestureDetector(
              onTap: () {
                cubit.playOrPauseSong();
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: _QuavoColors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    color: _QuavoColors.red,
                    size: 48,
                  ),
                ),
              ),
            ),

            // Next
            IconButton(
              onPressed: () {
                cubit.next();
              },
              icon: const Icon(Icons.skip_next, color: _QuavoColors.black, size: 40),
            ),

            // Repeat
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.repeat, color: _QuavoColors.black.withOpacity(0.7), size: 28),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
