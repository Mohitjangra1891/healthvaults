import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../common/ytService.dart';
import '../../res/appColors.dart';

final ytApiKeyProvider = Provider<String>((ref) => 'AIzaSyDiZnAtaDSlUY4-_zLwusE-zv-UvRClCsI');

final youTubeServiceProvider = Provider<YouTubeService>(
  (ref) => YouTubeService(ref.read(ytApiKeyProvider)),
);

final searchVideosProvider = FutureProvider.family<List<YouTubeVideo>, String>((ref, query) {
  return ref.read(youTubeServiceProvider).searchVideos('$query exercise tutorial');
});

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

class DemoScreen extends ConsumerStatefulWidget {
  final String type;
  final String excercise;
  final String duration;

  const DemoScreen({
    super.key,
    required this.type,
    required this.excercise,
    required this.duration,
  });

  @override
  ConsumerState<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends ConsumerState<DemoScreen> {
  YoutubePlayerController? _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _controller = YoutubePlayerController(
      params: YoutubePlayerParams(),
    );



  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller?.dispose();
    _controller?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ytVideosAsync = ref.watch(searchVideosProvider(widget.excercise));
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : AppColors.primaryColor;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight * 0.16,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                margin: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.type,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.excercise,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.duration,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              ytVideosAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
                data: (videos) {
                  if (videos.isEmpty) return const Center(child: Text("No videos found."));



                  _controller?.loadVideoById(videoId: videos[selectedIndex].videoId);
                  return Expanded(
                    child: Column(
                      children: [
                        // YouTube Player with rounded corners
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(controller: _controller!),
                          ),
                        ),
                        // YoutubePlayer(controller: _controller!),
                        const SizedBox(height: 22),

                        // Video title list
                        Expanded(
                          child: ListView.separated(
                            itemCount: videos.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final video = videos[index];

                              final isSelected = index == selectedIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    // _controller!.load(video.videoId);
                                    _controller?.loadVideoById(videoId: video.videoId);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? isSelected
                                            ? Colors.white
                                            : Colors.black12
                                        : isSelected
                                            ? Colors.blueAccent
                                            : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    video.title,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? isSelected
                                              ? Colors.blue
                                              : Colors.white
                                          : isSelected
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
