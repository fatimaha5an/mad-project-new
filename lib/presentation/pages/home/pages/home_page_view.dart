import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/pages/home/bloc/new_songs_cubit.dart';
import 'package:spotify/presentation/pages/home/bloc/new_songs_state.dart';
import 'package:spotify/presentation/pages/home/bloc/play_list_cubit.dart';
import 'package:spotify/presentation/pages/home/bloc/play_list_state.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify/features/ai_dj/presentation/cubit/ai_dj_cubit.dart';
import 'package:spotify/features/ai_dj/presentation/cubit/ai_dj_state.dart';
import 'package:spotify/features/snap_to_song/data/datasources/ml_service.dart';
import 'package:spotify/presentation/pages/profile/profile.dart';
import 'package:spotify/presentation/search/pages/search_page.dart';
import 'package:spotify/common/widgets/color_scheme_toggle/color_scheme_toggle_button.dart';
import 'package:spotify/core/theme/color_scheme_cubit.dart';

// --- LOCAL COLOR PALETTE (Aldrich Theme) ---
class _AldrichColors {
  static const backgroundDark = Color(0xFF181111);
  static const champagnePink = Color(0xFFF3D5C9);
  static const blueMunsell = Color(0xFF0093AF);
  static const midnightGreen = Color(0xFF004953);
  static const richBlack = Color(0xFF010B13);
  static const cambridgeBlue = Color(0xFFA3C1AD);
  static const gamboge = Color(0xFFE49B0F);
  static const alloyOrange = Color(0xFFC46210);
  static const auburnRed = Color(0xFFA52A2A);
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorSchemeCubit, ColorSchemeState>(
      builder: (context, colorState) {
        return Scaffold(
          backgroundColor: colorState.background,
          floatingActionButton: _buildFloatingActionButtons(context, colorState),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(context, colorState),
                  const SizedBox(height: 24),
                  _buildHeroCard(colorState),
                  const SizedBox(height: 24),
                  _buildTabs(colorState),
                  const SizedBox(height: 24),
                  _buildNewSongsSection(colorState),
                  const SizedBox(height: 24),
                  _buildPlaylistSection(colorState),
                  const SizedBox(height: 100), // Bottom padding for FABs
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 1. APP BAR
  Widget _buildAppBar(BuildContext context, ColorSchemeState colorState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Quavo",
            style: TextStyle(
              color: colorState.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              // Color Scheme Toggle
              const ColorSchemeToggleButton(size: 22),
              const SizedBox(width: 8),
              // Search Button
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorState.surface.withOpacity(0.5),
                  ),
                  child: Icon(Icons.search, color: colorState.primary, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              // Profile Avatar
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorState.primary, width: 2),
                    color: colorState.surface,
                    boxShadow: [
                      BoxShadow(
                        color: colorState.primary.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(Icons.person, color: colorState.textPrimary, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. HERO CARD (Billie Eilish)
  Widget _buildHeroCard(ColorSchemeState colorState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _AldrichColors.cambridgeBlue.withOpacity(0.3)),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_AldrichColors.midnightGreen, _AldrichColors.richBlack],
          ),
        ),
        child: Stack(
          children: [
            // Right Side Image
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              width: 160,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    color: _AldrichColors.midnightGreen,
                    child: const Icon(Icons.music_note, size: 80, color: _AldrichColors.cambridgeBlue),
                  ),
                ),
              ),
            ),
            // Left Side Text
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _AldrichColors.auburnRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _AldrichColors.auburnRed.withOpacity(0.3)),
                    ),
                    child: const Text(
                      "Artist of the Month",
                      style: TextStyle(color: _AldrichColors.auburnRed, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Billie Eilish",
                    style: TextStyle(
                      color: _AldrichColors.champagnePink,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Listen to the new exclusive album.",
                    style: TextStyle(color: _AldrichColors.cambridgeBlue, fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 3. TABS
  Widget _buildTabs(ColorSchemeState colorState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem("New", isActive: true),
          _buildTabItem("Trending"),
          _buildTabItem("For You"),
          _buildTabItem("Genres"),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, {bool isActive = false}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? _AldrichColors.champagnePink : _AldrichColors.cambridgeBlue.withOpacity(0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        if (isActive)
          Container(
            height: 4,
            width: 20,
            decoration: BoxDecoration(
              color: _AldrichColors.gamboge,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: _AldrichColors.gamboge.withOpacity(0.6),
                  blurRadius: 8,
                )
              ],
            ),
          )
      ],
    );
  }

  // 4. NEW SONGS CAROUSEL (Horizontal)
  Widget _buildNewSongsSection(ColorSchemeState colorState) {
    return BlocBuilder<NewSongsCubit, NewSongsState>(
      builder: (context, state) {
        if (state is NewSongLoading) {
          return const Center(child: CircularProgressIndicator(color: _AldrichColors.gamboge));
        }
        if (state is NewSongLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "New Songs",
                  style: TextStyle(color: _AldrichColors.champagnePink, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 190,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.songs.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final song = state.songs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SongPlayerPage(songEntity: song)));
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _AldrichColors.midnightGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: _AldrichColors.richBlack,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    '${AppUrls.coverfirestorage}${song.artist} - ${song.title}.png?${AppUrls.mediaAlt}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: _AldrichColors.richBlack,
                                        child: const Icon(Icons.music_note, color: _AldrichColors.cambridgeBlue, size: 40),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator(color: _AldrichColors.gamboge));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: _AldrichColors.champagnePink, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: _AldrichColors.cambridgeBlue, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  // 5. PLAYLIST SECTION (Vertical)
  Widget _buildPlaylistSection(ColorSchemeState colorState) {
    return BlocBuilder<PlayListCubit, PlayListState>(
      builder: (context, state) {
        if (state is PlayListLoading) return const SizedBox();
        if (state is PlayListLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Playlist",
                  style: TextStyle(color: _AldrichColors.champagnePink, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.song.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final song = state.song[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SongPlayerPage(songEntity: song)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _AldrichColors.midnightGreen.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: _AldrichColors.auburnRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song.title,
                                    style: const TextStyle(color: _AldrichColors.champagnePink, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${song.artist} • ${song.duration.toString().replaceAll('.', ':')}",
                                    style: const TextStyle(color: _AldrichColors.cambridgeBlue, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                song.isFavourite ? Icons.favorite : Icons.favorite_border,
                                color: song.isFavourite ? _AldrichColors.auburnRed : _AldrichColors.champagnePink,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  // 6. FLOATING ACTION BUTTONS
  Widget _buildFloatingActionButtons(BuildContext context, ColorSchemeState colorState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Camera FAB
        FloatingActionButton(
          heroTag: "cam_btn",
          onPressed: () => _showImageSourceDialog(context),
          backgroundColor: _AldrichColors.cambridgeBlue,
          child: const Icon(Icons.photo_camera, color: _AldrichColors.richBlack),
        ),
        const SizedBox(height: 16),
        // AI DJ FAB (Larger)
        SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            heroTag: "sparkle_btn",
            onPressed: () => _showAiDjDialog(context),
            backgroundColor: _AldrichColors.gamboge,
            child: const Icon(Icons.smart_toy, color: _AldrichColors.richBlack, size: 32),
          ),
        ),
      ],
    );
  }

  // Camera Image Source Selection
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _AldrichColors.richBlack,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: _AldrichColors.gamboge, width: 2)),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: _AldrichColors.gamboge),
                title: const Text("Take Photo", style: TextStyle(color: _AldrichColors.champagnePink)),
                onTap: () => _handleImageResult(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: _AldrichColors.gamboge),
                title: const Text("Pick from Gallery", style: TextStyle(color: _AldrichColors.champagnePink)),
                onTap: () => _handleImageResult(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleImageResult(BuildContext context, ImageSource source) async {
    Navigator.pop(context);
    try {
      final labels = await ImageLabelingService().pickAndAnalyzeImage(source);
      if (labels.isNotEmpty) {
        final String visualMood = "I see: ${labels.join(', ')}";
        if (context.mounted) {
          _showAiDjDialog(context, initialMood: visualMood, mlLabels: labels);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not identify anything! Try again.")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Snap-to-Song only works on Mobile! ($e)")),
        );
      }
    }
  }

  // AI DJ Dialog
  void _showAiDjDialog(BuildContext context, {String? initialMood, List<String>? mlLabels}) {
    final TextEditingController moodController = TextEditingController(text: initialMood);
    const String apiKey = "AIzaSyAPX41_xSvld5zIHHf9XgNhnbIhZxTjEWo";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider(
          create: (_) => AiDjCubit(apiKey: apiKey),
          child: Builder(
            builder: (context) {
              return AlertDialog(
                backgroundColor: _AldrichColors.richBlack,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: _AldrichColors.gamboge, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  "AI DJ 💿",
                  style: TextStyle(color: _AldrichColors.gamboge, fontFamily: 'monospace'),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "What's the vibe?",
                      style: TextStyle(color: _AldrichColors.champagnePink),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: moodController,
                      style: const TextStyle(color: _AldrichColors.champagnePink),
                      decoration: InputDecoration(
                        hintText: "e.g., Sad, Party, Study",
                        hintStyle: TextStyle(color: _AldrichColors.cambridgeBlue.withOpacity(0.5)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: _AldrichColors.champagnePink),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: _AldrichColors.gamboge),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AiDjCubit, AiDjState>(
                      builder: (context, state) {
                        if (state is AiDjLoading) {
                          return const CircularProgressIndicator(color: _AldrichColors.gamboge);
                        }
                        if (state is AiDjError) {
                          return Text(
                            "Error: ${state.message}",
                            style: const TextStyle(color: _AldrichColors.auburnRed),
                          );
                        }
                        if (state is AiDjLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.songs
                                .map((song) => Text(
                                      "🎵 $song",
                                      style: const TextStyle(color: _AldrichColors.champagnePink),
                                    ))
                                .toList(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text("Close", style: TextStyle(color: _AldrichColors.champagnePink)),
                  ),
                  TextButton(
                    onPressed: () async {
                      final songs = [
                        "Digital Dreams",
                        "Neon Nights",
                        "Glitch Horizon",
                        "Synthwave Sunrise",
                        "Terminal Velocity",
                        "Happier Than Ever"
                      ];
                      context.read<AiDjCubit>().getRecommendations(
                            moodController.text,
                            songs,
                            detectedLabels: mlLabels,
                          );
                    },
                    child: const Text(
                      "Mix It",
                      style: TextStyle(color: _AldrichColors.gamboge, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
