import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/services/ytService.dart';
import '../views/demoExercise/exerciseDetailScreen.dart';

class YouTubeVideo {
  final String videoId;
  final String title;
  final String thumbnailUrl;

  YouTubeVideo({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      videoId: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['default']['url'],
    );
  }
}


final ytApiKeyProvider = Provider<String>((ref) => 'AIzaSyDiZnAtaDSlUY4-_zLwusE-zv-UvRClCsI');

final youTubeServiceProvider = Provider<YouTubeService>(
      (ref) => YouTubeService(ref.read(ytApiKeyProvider)),
);

final searchVideosProvider = FutureProvider.family<List<YouTubeVideo>, String>((ref, query) {
  return ref.read(youTubeServiceProvider).searchVideos('$query exercise tutorial');
});

