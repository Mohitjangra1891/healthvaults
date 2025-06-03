import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthvaults/src/modals/TaskEntity.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../res/appColors.dart';
import '../../../goal/repo/taskRepo.dart';
import '../../controller/todayExcerciseController.dart';
import '../../controller/youTubeController.dart';

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
  final void Function(int durationInSeconds) onCompleted;

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
    widget.onCompleted(_seconds);
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
