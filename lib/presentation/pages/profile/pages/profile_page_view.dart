import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/pages/profile/bloc/profile_cubit.dart';
import 'package:spotify/presentation/pages/profile/bloc/profile_state.dart';
import 'package:spotify/presentation/pages/profile/bloc/fav_songs_cubit.dart';
import 'package:spotify/presentation/pages/profile/bloc/fav_songs_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/features/profile/presentation/pages/stats_page.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/presentation/settings/pages/settings_page.dart';

// --- LOCAL COLOR PALETTE (Quavo Archive) ---
class _QuavoColors {
  static const dark = Color(0xFF001219);
  static const green = Color(0xFF005F73);
  static const gold = Color(0xFFEE9B00);
  static const pink = Color(0xFFE9D8A6);
  static const blue = Color(0xFF94D2BD);
  static const teal = Color(0xFF0A9396);
  static const red = Color(0xFF9B2226);
}

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _QuavoColors.dark,
      body: Column(
        children: [
          // 1. THE HEADER (35% Height)
          _buildHeader(context, screenHeight),

          // 2. THE BODY (Collected Artifacts)
          Expanded(
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenHeight) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // Safe Data Access
        String name = "User";
        String email = "loading...";
        String? image;

        if (state is ProfileLoaded) {
          name = state.userEntity.fullname ?? "User";
          email = state.userEntity.email ?? "";
          image = state.userEntity.imageUrl;
        }

        return Container(
          height: screenHeight * 0.35,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_QuavoColors.dark, _QuavoColors.green],
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(60),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ],
          ),
          child: Stack(
            children: [
              // Top Bar Actions
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: _QuavoColors.pink, size: 28),
                        ),
                        // Stats & Settings Buttons
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsPage()));
                              },
                              icon: const Icon(Icons.bar_chart, color: _QuavoColors.gold, size: 28),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                              },
                              icon: const Icon(Icons.settings, color: _QuavoColors.blue, size: 28),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Profile Content (Centered)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Avatar with Glow
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _QuavoColors.gold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: _QuavoColors.gold.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: image != null
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => Container(
                                  color: _QuavoColors.green,
                                  child: const Icon(Icons.person, size: 60, color: _QuavoColors.gold),
                                ),
                              )
                            : Container(
                                color: _QuavoColors.green,
                                child: const Icon(Icons.person, size: 60, color: _QuavoColors.gold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Name
                    Text(
                      name,
                      style: const TextStyle(
                        color: _QuavoColors.pink,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Email Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _QuavoColors.dark.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        email,
                        style: const TextStyle(
                          color: _QuavoColors.blue,
                          fontSize: 12,
                          fontFamily: 'Monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        children: [
          // Section Header
          Row(
            children: [
              Text(
                "COLLECTED ARTIFACTS",
                style: TextStyle(
                  color: _QuavoColors.blue.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: _QuavoColors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Favorites List
          Expanded(
            child: BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
              builder: (context, state) {
                if (state is FavoriteSongsLoading) {
                  return const Center(child: CircularProgressIndicator(color: _QuavoColors.gold));
                }
                if (state is FavoriteSongsLoaded) {
                  if (state.favoriteSongs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No artifacts yet.",
                        style: TextStyle(color: _QuavoColors.blue),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 32),
                    itemCount: state.favoriteSongs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final song = state.favoriteSongs[index];
                      return _buildSongItem(context, song, index);
                    },
                  );
                }
                if (state is FavoriteSongsFailure) {
                  return const Center(child: Text("Could not load artifacts.", style: TextStyle(color: _QuavoColors.red)));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(BuildContext context, SongEntity song, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SongPlayerPage(songEntity: song)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Album Art
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _QuavoColors.green,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  '${AppUrls.coverfirestorage}${song.artist} - ${song.title}.png?${AppUrls.mediaAlt}',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) {
                    return Container(
                      color: _QuavoColors.green,
                      child: const Icon(Icons.music_note, color: _QuavoColors.gold, size: 32),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Text Info
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _QuavoColors.teal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Heart Icon (Remove from favorites)
            IconButton(
              onPressed: () {
                context.read<FavoriteSongsCubit>().removeSong(index);
              },
              icon: const Icon(Icons.favorite, color: _QuavoColors.red, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
