import 'package:hive/hive.dart';

part 'listening_event.g.dart';

@HiveType(typeId: 1)
class ListeningEvent extends HiveObject {
  @HiveField(0)
  final String songTitle;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final double durationMinutes; // How many minutes the song was played

  ListeningEvent({
    required this.songTitle,
    required this.timestamp,
    this.durationMinutes = 3.0, // Default ~3 minutes per song
  });
}
