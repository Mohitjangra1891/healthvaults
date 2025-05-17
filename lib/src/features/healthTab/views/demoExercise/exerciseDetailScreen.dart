import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/modals/TaskEntity.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../res/appColors.dart';
import '../../../goal/repo/taskRepo.dart';
import '../../controller/todayExcerciseController.dart';
import '../../controller/youTubeController.dart';

class DemoScreen extends ConsumerStatefulWidget {
  final List<TaskEntity> exercises;
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

    final ytVideosAsync = ref.watch(searchVideosProvider(currentExercise.value));
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
                          currentExercise.title,
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
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isListExpanded = !isListExpanded;
                                });
                              },
                              icon: Icon(isListExpanded ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)),
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
                              currentExercise.value,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
                            )),
                            Text(currentExercise.description, style: TextStyle(fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TimerScreen(
                    isCompleted: currentExercise.isCompleted,
                    onCompleted: () async {
                      // update your local DB here, e.g.:
                      currentExercise.isCompleted = true;
                      // myLocalDb.update(myExercise);
                      final updatedTask = currentExercise..isCompleted = true;
                      await TaskService.updateTask(updatedTask);
                      ref.invalidate(todayTaskProvider);
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

class FeedbackCard extends StatefulWidget {
  const FeedbackCard({super.key});

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  String selectedOption = '';

  final List<String> options = ['Too\nEasy', 'Just\nRight', 'Too\nHard'];

  @override
  Widget build(BuildContext context) {
    return Card(

      color: Colors.white,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 19,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How do you feel about this exercise?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: options.map((option) {
                final isSelected = selectedOption == option;

                // Split the option into two parts for display
                final parts = option.split(' ');
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isSelected ? Colors.blue : Colors.lightBlue.shade50,
                        foregroundColor:
                        isSelected ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedOption = option;
                        });
                      },
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical:0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${parts.first}\n${parts.length > 1 ? parts.last : ''}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// A full-screen timer widget as described.
class TimerScreen extends StatefulWidget {
  /// Whether this exercise is already completed.
  final bool isCompleted;

  /// Called when user taps "Done".
  final VoidCallback onCompleted;

  /// If you ever want to start from non-zero.
  final int initialSeconds;

  const TimerScreen({
    Key? key,
    required this.isCompleted,
    required this.onCompleted,
    this.initialSeconds = 0,
  }) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late bool _isCompleted;
  late int _seconds;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
    _seconds = widget.initialSeconds;
  }

  @override
  void didUpdateWidget(covariant TimerScreen old) {
    super.didUpdateWidget(old);
    // If the parent gave us a new `isCompleted`, reset our UI:
    if (widget.isCompleted != old.isCompleted) {
      _timer?.cancel();
      setState(() {
        _isCompleted = widget.isCompleted;
        _isRunning = false;
        _seconds = widget.initialSeconds;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _restart() {
    _stopTimer();
    setState(() {
      _seconds = 0;
    });
  }

  void _markDone() {
    _stopTimer();
    widget.onCompleted();
    setState(() {
      _isCompleted = true;
    });
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isCompleted
          // → Green “Completed” state
          ? Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 8),
              ),
              alignment: Alignment.center,
              child: const Text(
                'COMPLETED',
                style: TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          // → Timer + controls
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Blue circular timer
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _formattedTime,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                // If not started, only ▶️
                if (!_isRunning)
                  IconButton(
                    iconSize: 64,
                    icon: const Icon(Icons.play_circle_fill),
                    color: Colors.blue,
                    onPressed: _startTimer,
                  ),
                // Once running, show 🔄 and ✔️
                if (_isRunning)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(
                          Icons.replay,
                          color: Colors.blue,
                        ),
                        onPressed: _restart,
                      ),
                      const SizedBox(width: 22),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Colors.blue),
                          onPressed: _markDone,
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
              ],
            ),
    );
  }
}

//
// class DemoScreen extends ConsumerStatefulWidget {
//   final String type;
//   final String excercise;
//   final String duration;
//
//   const DemoScreen({
//     super.key,
//     required this.type,
//     required this.excercise,
//     required this.duration,
//   });
//
//   @override
//   ConsumerState<DemoScreen> createState() => _DemoScreenState();
// }
//
// class _DemoScreenState extends ConsumerState<DemoScreen> {
//   // late final YoutubePlayerController _controller;
//   bool playerReady = false;
//   int selectedIndex = 0;
//   bool isListExpanded = false;
//
//   //
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   _controller = YoutubePlayerController(
//   //     params: YoutubePlayerParams(),
//   //   );
//   // }
//   //
//   // @override
//   // void dispose() {
//   //   // TODO: implement dispose
//   //   // _controller?.dispose();
//   //   _controller?.close();
//   //
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final ytVideosAsync = ref.watch(searchVideosProvider(widget.excercise));
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final borderColor = isDark ? Colors.white : AppColors.primaryColor;
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             // height: screenHeight * 0.45,
//             padding: EdgeInsets.only(top: screenHeight * 0.06, left: 16, right: 16),
//
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.green.shade300, Colors.cyanAccent.shade100],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.type,
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 18),
//                 // Text(
//                 //   widget.excercise,
//                 //   style: TextStyle(
//                 //     fontSize: 20,
//                 //     fontWeight: FontWeight.bold,
//                 //   ),
//                 // ),
//                 // Text(
//                 //   widget.duration,
//                 //   style: TextStyle(
//                 //     fontSize: 18,
//                 //   ),
//                 // ),
//
//                 Padding(
//                   padding: const EdgeInsets.all(0.0),
//                   child: ytVideosAsync.when(
//                     loading: () =>
//                     Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Container(
//                           width: double.infinity,
//                           height: (MediaQuery.of(context).size.width) * 9/16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     error: (e, _) => Center(child: Text("Error: $e")),
//                     data: (videos) {
//                       if (videos.isEmpty) return const Center(child: Text("No videos found."));
//                       final selectedVideoId = videos[selectedIndex].videoId;
//
//                       // _controller?.loadVideoById(videoId: videos[selectedIndex].videoId);
//                       return Expanded(
//                         child: Column(
//                           children: [
//                             // YouTube Player with rounded corners
//                             // ClipRRect(
//                             //   borderRadius: BorderRadius.circular(16),
//                             //   child: AspectRatio(
//                             //     aspectRatio: 16 / 9,
//                             //     child: YoutubePlayer(controller: _controller!),
//                             //   ),
//                             // ),
//                             // 1) The isolated player
//                             SafeYoutubePlayer(videoId: selectedVideoId),
//                             // Video title list
//                             AnimatedSize(
//                               duration: Duration(milliseconds: 300),
//                               curve: Curves.easeInOut,
//                               child: isListExpanded
//                                   ? SizedBox(
//                                       height: 150,
//                                       child: ListView.separated(
//                                         scrollDirection: Axis.horizontal,
//                                         itemCount: videos.length,
//                                         separatorBuilder: (_, __) => const SizedBox(width: 12),
//                                         itemBuilder: (context, index) {
//                                           final video = videos[index];
//
//                                           final isSelected = index == selectedIndex;
//                                           final thumbUrl = 'https://img.youtube.com/vi/${video.videoId}/hqdefault.jpg';
//
//                                           return GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 selectedIndex = index;
//                                                 // _controller!.load(video.videoId);
//                                                 // _controller?.loadVideoById(videoId: video.videoId);
//                                               });
//                                             },
//                                             child: Container(
//                                               width: screenWidth * 0.46,
//                                               margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
//                                               decoration: BoxDecoration(
//                                                 color: isDark
//                                                     ? isSelected
//                                                         ? Colors.white
//                                                         : Colors.black12
//                                                     : isSelected
//                                                         ? Colors.purple.shade200
//                                                         : Colors.grey[200],
//                                                 borderRadius: BorderRadius.circular(12),
//                                               ),
//                                               child: Column(
//                                                 children: [
//                                                   // Thumbnail
//                                                   Padding(
//                                                     padding: const EdgeInsets.all(2.0),
//                                                     child: ClipRRect(
//                                                       borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                                                       child: Image.network(
//                                                         thumbUrl,
//                                                         height: 80,
//                                                         width: double.infinity,
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.all(4.0),
//                                                     child: Text(
//                                                       video.title,
//                                                       maxLines: 1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                       style: TextStyle(
//                                                         fontSize: 18,
//                                                         fontWeight: FontWeight.w600,
//                                                         color: isDark
//                                                             ? isSelected
//                                                                 ? Colors.blue
//                                                                 : Colors.white
//                                                             : isSelected
//                                                                 ? Colors.white
//                                                                 : Colors.black,
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     )
//                                   : SizedBox.shrink(),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Center(
//                   child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           isListExpanded = !isListExpanded;
//                         });
//                       },
//                       icon: Icon(isListExpanded ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded)),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

/// The isolated YouTube player widget
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
