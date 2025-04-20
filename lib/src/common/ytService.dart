import 'dart:convert';
import 'package:http/http.dart' as http;

import '../features/healthTab/exerciseDetailScreen.dart';

class YouTubeService {
  final String apiKey;

  YouTubeService(this.apiKey);

  Future<List<YouTubeVideo>> searchVideos(String query) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search'
          '?part=snippet&type=video&maxResults=5&q=$query&key=$apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['items'] as List)
          .map((item) => YouTubeVideo.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}

