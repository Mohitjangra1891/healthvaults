import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthvaults/src/features/healthTab/views/demoExercise/timer_widget.dart';
import 'package:healthvaults/src/modals/TaskEntity.dart';
import 'package:healthvaults/src/modals/WeeklyWorkoutPlan.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../res/appColors.dart';
import '../../../goal/repo/taskRepo.dart';
import '../../controller/planController.dart';
import '../../controller/todayExcerciseController.dart';
import '../../controller/youTubeController.dart';

class DemoScreen extends ConsumerStatefulWidget {
  final List<RoutineItem> exercises;
  final int currentIndex;

  const DemoScreen({
    required this.exercises,
    required this.currentIndex,
  });

  @override
  ConsumerState<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends ConsumerState<DemoScreen> {
  // late final YoutubePlayerController _controller;
  bool playerReady = false;
  int selectedIndex = 0;
  bool isListExpanded = false;

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[currentIndex];

    final ytVideosAsync = ref.watch(searchVideosProvider(currentExercise.name));
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : AppColors.primaryColor;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    // height: screenHeight * 0.45,
                    padding: EdgeInsets.only(top: screenHeight * 0.06, left: 16, right: 16),

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade300, Colors.cyanAccent.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentExercise.type,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ytVideosAsync.when(
                            loading: () => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: double.infinity,
                                  height: (MediaQuery.of(context).size.width) * 9 / 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            error: (e, _) => Center(child: Text("Error: $e")),
                            data: (videos) {
                              if (videos.isEmpty) return const Center(child: Text("No videos found."));
                              final selectedVideoId = videos[selectedIndex].videoId;

                              // _controller?.loadVideoById(videoId: videos[selectedIndex].videoId);
                              return Expanded(
                                child: Column(
                                  children: [
                                    // YouTube Player with rounded corners
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(16),
                                    //   child: AspectRatio(
                                    //     aspectRatio: 16 / 9,
                                    //     child: YoutubePlayer(controller: _controller!),
                                    //   ),
                                    // ),
                                    // 1) The isolated player
                                    SafeYoutubePlayer(videoId: selectedVideoId),
                                    // Video title list
                                    AnimatedSize(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: isListExpanded
                                          ? SizedBox(
                                              height: 150,
                                              child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: videos.length,
                                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                                itemBuilder: (context, index) {
                                                  final video = videos[index];

                                                  final isSelected = index == selectedIndex;
                                                  final thumbUrl = 'https://img.youtube.com/vi/${video.videoId}/hqdefault.jpg';

                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedIndex = index;
                                                        // _controller!.load(video.videoId);
                                                        // _controller?.loadVideoById(videoId: video.videoId);
                                                      });
                                                    },
                                                    child: Container(
                                                      width: screenWidth * 0.46,
                                                      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                                                      decoration: BoxDecoration(
                                                        color: isDark
                                                            ? isSelected
                                                                ? Colors.white
                                                                : Colors.black12
                                                            : isSelected
                                                                ? Colors.purple.shade200
                                                                : Colors.grey[200],
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          // Thumbnail
                                                          Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: ClipRRect(
                                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                                              child: Image.network(
                                                                thumbUrl,
                                                                height: 80,
                                                                width: double.infinity,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(4.0),
                                                            child: Text(
                                                              video.title,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
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
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isListExpanded = !isListExpanded;
                                  });
                                },
                                child: SvgPicture.asset(
                                  isListExpanded ? appImages.arrowUp : appImages.arrowDown,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue.shade400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              currentExercise.name,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
                            )),
                            Text(currentExercise.reps ?? currentExercise.duration ?? " ", style: TextStyle(fontSize: 18, color: Colors.white)),
                            Text(currentExercise.instruction, style: TextStyle(fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TimerScreen(
                    isCompleted: currentExercise.isCompleted,
                    onCompleted: (durationInSeconds) async {
                      // // update your local DB here, e.g.:
                      // currentExercise.isCompleted = true;
                      // currentExercise.completedIN = durationInSeconds;
                      // // myLocalDb.update(myExercise);
                      // final updatedTask = currentExercise;
                      // await TaskService.updateTask(updatedTask);
                      // ref.invalidate(todayTaskProvider);
                      final todayKey = DateFormat('EEEE').format(DateTime.now());

                      ref.read(workoutPlanProvider.notifier).markExerciseComplete(
                            dayKey: todayKey,
                            index: currentIndex,
                            isCompleted: true,
                            completedInSeconds: durationInSeconds,
                          );
                    },
                  ),
                  SizedBox(height: 56),
                  FeedbackCard(),
                  SizedBox(height: 36),
                ],
              ),
            ),
          ),

          // Fixed Bottom Buttons
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: currentIndex > 0 ? Colors.blue : Colors.grey,
                      ),
                      onPressed: currentIndex > 0 ? () => setState(() => currentIndex--) : null,
                      child: Text(
                        "Previous",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: currentIndex < widget.exercises.length - 1 ? Colors.blue : Colors.grey,
                      ),
                      onPressed: currentIndex < widget.exercises.length - 1 ? () => setState(() => currentIndex++) : null,
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SafeYoutubePlayer extends StatefulWidget {
  final String videoId;

  const SafeYoutubePlayer({super.key, required this.videoId});

  @override
  State<SafeYoutubePlayer> createState() => _SafeYoutubePlayerState();
}

class _SafeYoutubePlayerState extends State<SafeYoutubePlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _controller.loadVideoById(videoId: widget.videoId);
  }

  @override
  void didUpdateWidget(covariant SafeYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // load a new video when videoId changes
    if (oldWidget.videoId != widget.videoId) {
      _controller.loadVideoById(videoId: widget.videoId);
    }
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(controller: _controller),
      ),
    );
  }
}
