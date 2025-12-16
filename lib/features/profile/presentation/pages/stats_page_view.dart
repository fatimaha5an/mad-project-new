import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spotify/core/services/hive_service.dart';
import 'package:spotify/features/profile/data/models/listening_event.dart';
import 'package:spotify/features/snap_to_song/data/models/vibe_session.dart';

// --- LOCAL COLOR PALETTE (Echo Log) ---
class _QuavoColors {
  static const richBlack = Color(0xFF001219);
  static const midnightGreen = Color(0xFF005F73);
  static const blueMunsell = Color(0xFF0A9396);
  static const gamboge = Color(0xFFEE9B00);
}

class StatsPageView extends StatelessWidget {
  const StatsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _QuavoColors.richBlack,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSignalStrengthChart(),
            const SizedBox(height: 32),
            _buildRecurringSignalsSection(),
            const SizedBox(height: 32),
            _buildVibeLogSection(),
            const SizedBox(height: 24),
            _buildAnalysisFooter(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: _QuavoColors.richBlack.withOpacity(0.9),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Column(
        children: [
          const Text(
            "THE ECHO LOG",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 16,
            ),
          ),
          Text(
            "Data Range: Last 30 Cycles",
            style: TextStyle(
              color: _QuavoColors.blueMunsell,
              fontSize: 10,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // 1. SIGNAL STRENGTH (Chart with real data)
  Widget _buildSignalStrengthChart() {
    return ValueListenableBuilder(
      valueListenable: HiveService.listeningStatsBox.listenable(),
      builder: (context, box, _) {
        // Calculate listening time per day for last 7 days
        final now = DateTime.now();
        final List<double> dailyMinutes = List.filled(7, 0.0);
        final List<String> dayLabels = [];
        
        // Generate day labels (M, T, W, T, F, S, S)
        for (int i = 6; i >= 0; i--) {
          final day = now.subtract(Duration(days: i));
          final dayName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][day.weekday % 7];
          dayLabels.add(dayName);
        }
        
        // Calculate listening time for each day
        double totalMinutes = 0;
        for (int i = 0; i < box.length; i++) {
          final event = box.getAt(i) as ListeningEvent;
          final daysDiff = now.difference(event.timestamp).inDays;
          
          // Only count events from last 7 days
          if (daysDiff < 7 && daysDiff >= 0) {
            final dayIndex = 6 - daysDiff; // Reverse order (oldest to newest)
            dailyMinutes[dayIndex] += event.durationMinutes;
            totalMinutes += event.durationMinutes;
          }
        }
        
        // Find max for scaling
        final maxMinutes = dailyMinutes.reduce((a, b) => a > b ? a : b);
        
        // Convert to hours and minutes for display
        final hours = totalMinutes ~/ 60;
        final minutes = (totalMinutes % 60).round();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.show_chart, color: _QuavoColors.gamboge),
                    SizedBox(width: 8),
                    Text(
                      "SIGNAL STRENGTH",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _QuavoColors.midnightGreen,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: _QuavoColors.blueMunsell.withOpacity(0.3)),
                  ),
                  child: Text(
                    box.isNotEmpty ? "ACTIVE" : "IDLE",
                    style: TextStyle(color: _QuavoColors.blueMunsell, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _QuavoColors.richBlack,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _QuavoColors.gamboge, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL EXPOSURE (7 DAYS)",
                            style: TextStyle(color: _QuavoColors.blueMunsell, fontSize: 10, letterSpacing: 1.5),
                          ),
                          Text(
                            "${hours}h ${minutes}m",
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: _QuavoColors.gamboge,
                        child: Row(
                          children: [
                            const Icon(Icons.music_note, size: 12, color: _QuavoColors.richBlack),
                            Text(
                              " ${box.length} plays",
                              style: const TextStyle(color: _QuavoColors.richBlack, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Real bars based on actual listening data
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) {
                        final minutes = dailyMinutes[index];
                        final heightPct = maxMinutes > 0 ? (minutes / maxMinutes) : 0.0;
                        final isToday = index == 6; // Last bar is today
                        return _buildBar(
                          dayLabels[index],
                          heightPct,
                          isActive: isToday && minutes > 0,
                          minutes: minutes,
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBar(String label, double heightPct, {bool isActive = false, double minutes = 0}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Show time on hover/tooltip
        if (minutes > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              "${minutes.toInt()}m",
              style: TextStyle(
                color: _QuavoColors.blueMunsell,
                fontSize: 8,
                fontFamily: 'Monospace',
              ),
            ),
          ),
        Container(
          width: 24,
          height: heightPct > 0 ? (100 * heightPct).clamp(5.0, 100.0) : 5.0, // Min 5px for visibility
          decoration: BoxDecoration(
            color: minutes == 0 
                ? _QuavoColors.richBlack.withOpacity(0.3) 
                : (isActive ? _QuavoColors.gamboge : _QuavoColors.midnightGreen),
            border: Border.all(
              color: minutes == 0
                  ? Colors.grey.withOpacity(0.3)
                  : (isActive ? _QuavoColors.gamboge : _QuavoColors.blueMunsell),
            ),
            boxShadow: isActive && minutes > 0
                ? [BoxShadow(color: _QuavoColors.gamboge.withOpacity(0.5), blurRadius: 10)]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: minutes > 0 
                ? (isActive ? _QuavoColors.gamboge : Colors.white)
                : Colors.grey.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        )
      ],
    );
  }

  // 2. RECURRING SIGNALS (Top Songs from Hive)
  Widget _buildRecurringSignalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.repeat, color: _QuavoColors.gamboge),
            SizedBox(width: 8),
            Text(
              "RECURRING SIGNALS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: HiveService.listeningStatsBox.listenable(),
          builder: (context, box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    "No signals detected yet.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            // Count song frequencies
            Map<String, int> frequency = {};
            for (int i = 0; i < box.length; i++) {
              final event = box.getAt(i) as ListeningEvent;
              frequency[event.songTitle] = (frequency[event.songTitle] ?? 0) + 1;
            }

            // Sort and take top 5
            final sortedEntries = frequency.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final topSongs = sortedEntries.take(5).toList();

            return SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: topSongs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final entry = topSongs[index];
                  return _buildSignalCard(index + 1, entry.key, entry.value);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSignalCard(int rank, String songTitle, int playCount) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Stack(
            children: [
              // Offset Border (Hard Shadow)
              Transform.translate(
                offset: const Offset(4, 4),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: _QuavoColors.gamboge,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
              // Main Circle
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: _QuavoColors.midnightGreen,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: _QuavoColors.gamboge, width: 2),
                ),
                child: Center(
                  child: Text(
                    "#$rank",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            songTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: _QuavoColors.gamboge,
            ),
          ),
          Text(
            "$playCount detections",
            style: const TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'Monospace'),
          ),
        ],
      ),
    );
  }

  // 3. VIBE LOG (From Hive VibeSession)
  Widget _buildVibeLogSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: _QuavoColors.gamboge),
                SizedBox(width: 8),
                Text(
                  "VIBE LOG",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Text(
              "RECENT ACTIVITY",
              style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: HiveService.vibeHistoryBox.listenable(),
          builder: (context, box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    "No vibe history yet. Use AI DJ!",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            // Get sessions in reverse order (newest first)
            final sessions = <VibeSession>[];
            for (int i = box.length - 1; i >= 0 && sessions.length < 10; i--) {
              sessions.add(box.getAt(i) as VibeSession);
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final session = sessions[index];
                final timeAgo = _getTimeAgo(session.timestamp);
                return _buildVibeLogItem(
                  session.suggestedSongs.isNotEmpty ? session.suggestedSongs.first : "AI Mix",
                  timeAgo,
                  session.detectedLabels,
                );
              },
            );
          },
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  Widget _buildVibeLogItem(String title, String time, List<String> tags) {
    return Stack(
      children: [
        // Shadow
        Positioned.fill(
          child: Transform.translate(
            offset: const Offset(4, 4),
            child: Container(
              decoration: BoxDecoration(
                color: _QuavoColors.richBlack,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _QuavoColors.richBlack, width: 2),
              ),
            ),
          ),
        ),
        // Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _QuavoColors.midnightGreen,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _QuavoColors.gamboge, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _QuavoColors.richBlack,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: _QuavoColors.blueMunsell),
                ),
                child: const Icon(Icons.auto_awesome, color: _QuavoColors.gamboge),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Detected $time",
                      style: TextStyle(color: _QuavoColors.blueMunsell, fontSize: 10, fontFamily: 'Monospace'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tags.take(3).map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: _QuavoColors.blueMunsell,
                        child: Text(
                          tag.toUpperCase(),
                          style: const TextStyle(color: _QuavoColors.richBlack, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      )).toList(),
                    )
                  ],
                ),
              ),
              const Icon(Icons.play_circle, color: _QuavoColors.gamboge, size: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisFooter() {
    return ValueListenableBuilder(
      valueListenable: HiveService.listeningStatsBox.listenable(),
      builder: (context, box, _) {
        // Find most played genre/song
        String dominantSignal = "Unknown";
        if (box.isNotEmpty) {
          Map<String, int> frequency = {};
          for (int i = 0; i < box.length; i++) {
            final event = box.getAt(i) as ListeningEvent;
            frequency[event.songTitle] = (frequency[event.songTitle] ?? 0) + 1;
          }
          if (frequency.isNotEmpty) {
            dominantSignal = frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: const Border(left: BorderSide(color: _QuavoColors.gamboge, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "/// ANALYSIS COMPLETE",
                style: TextStyle(color: _QuavoColors.gamboge, fontFamily: 'Monospace', fontSize: 12),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  children: [
                    const TextSpan(text: "Signal consistency: "),
                    TextSpan(
                      text: "${box.length > 0 ? 98 : 0}%",
                      style: const TextStyle(color: _QuavoColors.blueMunsell, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ". Dominant frequency: "),
                    TextSpan(
                      text: dominantSignal,
                      style: const TextStyle(color: _QuavoColors.blueMunsell, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
