import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';

// --- ALDRICH COLOR PALETTE (The Radar) ---
class _AldrichColors {
  static const voidBlack = Color(0xFF001219);
  static const midnightGreen = Color(0xFF005F73);
  static const darkTeal = Color(0xFF004953);
  static const cambridgeBlue = Color(0xFF94D2BD);
  static const champagnePink = Color(0xFFE9D8A6);
  static const gamboge = Color(0xFFEE9B00);
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  
  List<SongEntity> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Songs')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      final songs = snapshot.docs.map((doc) {
        final data = doc.data();
        return SongEntity(
          songId: doc.id,
          title: data['title'] ?? '',
          artist: data['artist'] ?? '',
          duration: (data['duration'] ?? 0).toDouble(),
          releaseDate: data['releaseDate'] ?? Timestamp.now(),
          isFavourite: false,
        );
      }).toList();

      setState(() {
        _searchResults = songs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Search error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AldrichColors.midnightGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            _buildSearchHeader(),
            
            // Results or Empty State
            Expanded(
              child: _buildResultsArea(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _AldrichColors.voidBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button & Title
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _AldrichColors.champagnePink),
              ),
              const SizedBox(width: 8),
              const Text(
                "THE RADAR",
                style: TextStyle(
                  color: _AldrichColors.champagnePink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: _AldrichColors.midnightGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _focusNode.hasFocus 
                    ? _AldrichColors.gamboge 
                    : _AldrichColors.cambridgeBlue.withOpacity(0.3),
                width: _focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              style: const TextStyle(color: _AldrichColors.champagnePink),
              decoration: InputDecoration(
                hintText: "Search frequencies...",
                hintStyle: TextStyle(
                  color: _AldrichColors.cambridgeBlue.withOpacity(0.5),
                  fontFamily: 'Monospace',
                ),
                prefixIcon: const Icon(Icons.search, color: _AldrichColors.gamboge),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: _AldrichColors.cambridgeBlue),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _hasSearched = false;
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onTap: () => setState(() {}),
              onSubmitted: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: _AldrichColors.gamboge),
            SizedBox(height: 16),
            Text(
              "SCANNING...",
              style: TextStyle(
                color: _AldrichColors.cambridgeBlue,
                fontFamily: 'Monospace',
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return _buildEmptyState();
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.signal_cellular_no_sim,
              size: 80,
              color: _AldrichColors.darkTeal,
            ),
            const SizedBox(height: 16),
            const Text(
              "NO SIGNAL DETECTED",
              style: TextStyle(
                color: _AldrichColors.cambridgeBlue,
                fontFamily: 'Monospace',
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try different frequencies",
              style: TextStyle(
                color: _AldrichColors.cambridgeBlue.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final song = _searchResults[index];
        return _buildSongTile(song);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.radar,
            size: 100,
            color: _AldrichColors.darkTeal,
          ),
          const SizedBox(height: 24),
          const Text(
            "SCANNING FREQUENCIES...",
            style: TextStyle(
              color: _AldrichColors.cambridgeBlue,
              fontFamily: 'Monospace',
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter a signal to begin search",
            style: TextStyle(
              color: _AldrichColors.cambridgeBlue.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(SongEntity song) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SongPlayerPage(songEntity: song)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _AldrichColors.voidBlack.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _AldrichColors.cambridgeBlue.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _AldrichColors.darkTeal,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${AppUrls.coverfirestorage}${song.artist} - ${song.title}.png?${AppUrls.mediaAlt}',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.music_note,
                    color: _AldrichColors.gamboge,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _AldrichColors.champagnePink,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _AldrichColors.cambridgeBlue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Play Icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _AldrichColors.gamboge,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: _AldrichColors.voidBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
