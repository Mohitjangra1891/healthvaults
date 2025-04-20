import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/common/widgets/planScreen.dart';
import 'package:healthvaults/src/features/goal/views/widgets/difficulty_Buttton.dart';
import 'package:healthvaults/src/res/appColors.dart';
import 'package:healthvaults/src/res/appImages.dart';
import 'package:lottie/lottie.dart';

import '../../../common/services/loaclPlanStoreService.dart';
import '../../../res/const.dart';
import '../controller/workoutPlanController.dart';

class SetYourGoalScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _SetYourGoalScreenState();
}

class _SetYourGoalScreenState extends ConsumerState<SetYourGoalScreen> with SingleTickerProviderStateMixin {
  final ageController = TextEditingController(text: "22");
  final heightController = TextEditingController(text: "180");
  final weightController = TextEditingController(text: "80");

  String workoutLocation = '';
  final selectedGoals = <String>{};
  double weightLossGoal = 7;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool showDetails = true;
  bool isLoading = false;

  // bool hasGeneratedPlan = false;
  bool showPlan = false;
  String buttonText = "Show my personalized plan";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(planProvider.notifier).initChatSession();
    });
  }

  void toggleGoal(String goal) {
    setState(() {
      showPlan = false;
      buttonText = "Show my personalized plan";

      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
        if (goal == 'Lose Weight') _animationController.reverse();
      } else {
        selectedGoals.add(goal);
        if (goal == 'Lose Weight') _animationController.forward();
      }
    });
  }

  void _toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  String getPrompt({
    int? type,
    required String age,
    required String height,
    required String weight,
    required String gender,
    required String place,
    required String goals,
  }) {
    switch (type) {
      // case 0:
      //   return "Can you please generate again with some changes, I don't like it, response structure will be same";
      case 1:
        return "Can you please make it easier? Respond with the same JSON structure only, no explanation or formatting.";
      case 2:
        return "Can you please make it harder? Respond with the same JSON structure only, no explanation or formatting.";
      default:
        return Constants.getPromt(age: age, height: height, weight: weight, gender: gender, place: place, goals: goals);
    }
  }

  void _loadPlan({int? type}) async {
    setState(() {
      buttonText = "Show my personalized plan";
      showDetails = false;
      // hasGeneratedPlan = false;
      isLoading = true;
      showPlan = true;
    });

    final goalText = Constants.getGoalText(selectedGoals, weightLossGoal);

    final prompt = getPrompt(
        type: type,
        place: workoutLocation,
        age: ageController.text.trim(),
        gender: "male",
        height: heightController.text.trim(),
        weight: weightController.text.trim(),
        goals: goalText);

    print("prompt =$prompt");
    await ref.read(planProvider.notifier).fetchPlan(prompt: prompt);
    setState(() {
      // hasGeneratedPlan = true;
      showPlan = true;
      isLoading = false;
      buttonText = "Generate Again";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor = isDark ? Colors.white : AppColors.primaryColor;

    InputDecoration numberFieldDecoration() => InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1.8),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1.8),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 1.8),
            borderRadius: BorderRadius.circular(10),
          ),
        );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // no shadow on scroll

        automaticallyImplyLeading: false,
        title: Text('Set Your Goal', style: TextStyle(color: borderColor, fontWeight: FontWeight.w600, fontSize: 28)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: borderColor),
            onPressed: _toggleDetails,
            child: Row(
              children: [
                Text(showDetails ? "Hide Details" : "Show Details", style: TextStyle(color: !isDark ? Colors.white : AppColors.primaryColor)),
                Icon(showDetails ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up,
                    color: !isDark ? Colors.white : AppColors.primaryColor)
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: showDetails
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Age', style: TextStyle(color: borderColor, fontSize: 16)),
                                    SizedBox(height: 2),
                                    TextField(
                                      controller: ageController,
                                      keyboardType: TextInputType.number,
                                      decoration: numberFieldDecoration().copyWith(hintText: "years"),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Height', style: TextStyle(color: borderColor, fontSize: 16)),
                                    SizedBox(height: 2),
                                    TextField(
                                      controller: heightController,
                                      keyboardType: TextInputType.number,
                                      decoration: numberFieldDecoration().copyWith(hintText: "cm"),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Weight', style: TextStyle(color: borderColor, fontSize: 16)),
                                    SizedBox(height: 2),
                                    TextField(
                                      controller: weightController,
                                      keyboardType: TextInputType.number,
                                      decoration: numberFieldDecoration().copyWith(hintText: "kg"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          Text('Where would you like to workout:', style: TextStyle(color: borderColor, fontSize: 20, fontWeight: FontWeight.w400)),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildSelectableOption(
                                  'Home', appImages.homeWorkout, workoutLocation == 'Home', () => setState(() => workoutLocation = 'Home')),
                              SizedBox(width: screenWidth * 0.12),
                              buildSelectableOption('Gym', appImages.gym, workoutLocation == 'Gym', () => setState(() => workoutLocation = 'Gym')),
                            ],
                          ),
                          SizedBox(height: 24),
                          Text('What would you like to achieve:', style: TextStyle(color: borderColor, fontSize: 20, fontWeight: FontWeight.w400)),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildSelectableOption(
                                'Lose Weight',
                                appImages.weightLoss,
                                selectedGoals.contains('Lose Weight'),
                                () => toggleGoal('Lose Weight'),
                              ),
                              buildSelectableOption(
                                'Build Strength',
                                appImages.strength,
                                selectedGoals.contains('Strength Gain'),
                                () => toggleGoal('Strength Gain'),
                              ),
                              buildSelectableOption(
                                'Improve Flexibility',
                                appImages.flexibility,
                                selectedGoals.contains('flexibility'),
                                () => toggleGoal('flexibility'),
                              ),
                            ],
                          ),
                          SizeTransition(
                            sizeFactor: _fadeAnimation,
                            axisAlignment: -1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 24),
                                Text("What's your total weight loss goal: ${weightLossGoal.toInt()} kg", style: TextStyle(color: textColor)),
                                Slider(
                                  value: weightLossGoal,
                                  min: 2,
                                  max: 25,
                                  activeColor: borderColor,
                                  onChanged: (val) => setState(() => weightLossGoal = val),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      )
                    : SizedBox.shrink(),
              ),
              OutlinedButton(
                onPressed: () {
                  if (ageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Age should not be empty")),
                    );
                  } else if (heightController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Height should not be empty")),
                    );
                  } else if (weightController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Weight should not be empty")),
                    );
                  } else if (workoutLocation.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please choose a place for workout")),
                    );
                  } else if (selectedGoals.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please choose your goal")),
                    );
                  } else {
                    if (isLoading == false) _loadPlan();
                  }
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: BorderSide(color: borderColor, width: 1.8),
                  // minimumSize: Size(double.infinity, 50),
                ),
                child: Text(buttonText, style: TextStyle(color: borderColor, fontWeight: FontWeight.w500)),
              ),
              SizedBox(height: 16),
              showPlan
                  ? SizedBox.shrink()
                  : Text(
                      "Set your long term body transformation target. We'll create a manageable, personalized three months plan as your first milestone.",
                      style: TextStyle(color: textColor),
                    ),

              // Conditional UI below button
              if (showPlan)
                Consumer(
                  builder: (context, ref, _) {
                    final planAsync = ref.watch(planProvider);

                    return planAsync.when(
                      data: (plan) {
                        if (plan == null) {
                          return const Text("No workout plan available.");
                        }
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                difficulty_Buttton(
                                  onPressed: () => _loadPlan(type: 1),
                                  title: "Make it Easier",
                                  image: 'assets/svg/arrowDown.svg',
                                  color: Colors.greenAccent,
                                ),
                                difficulty_Buttton(
                                  onPressed: () => _loadPlan(type: 2),
                                  title: "Challenge Me More",
                                  image: 'assets/svg/arrowUp.svg',
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const SizedBox(height: 12),
                                Text(
                                  "* Kindly go through all exercise before adding.",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                planScreen(
                                  workoutPlan: plan!,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  DISCLAIMER,
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(height: 62),
                              ]),
                            ),
                          ],
                        );
                      },
                      loading: () => Lottie.asset('assets/loading.json'),
                      error: (error, stack) => Center(child: Text("Please Try Again .", style: TextStyle(fontSize: 24))),
                    );
                  },
                ),
            ],
          ),
          if (showPlan == true)
            Consumer(
              builder: (context, ref, _) {
                final planState = ref.watch(planProvider);
                return planState.maybeWhen(
                  data: (plan) => plan != null
                      ? Positioned(
                          bottom: 10,
                          left: 16,
                          right: 16,
                          child: ElevatedButton(
                            onPressed: () async {
                              await HiveService.saveWorkoutPlan('myPlan', plan);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              backgroundColor: borderColor,
                            ),
                            child: Text("Add This Plan",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: !isDark ? Colors.white : AppColors.primaryColor)),
                          ),
                        )
                      : const SizedBox.shrink(),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget buildSelectableOption(String label, String image, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(color: selected ? AppColors.primaryColor : Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
            child: Image.asset(
              image,
              height: 35,
            ),
          ),
          SizedBox(height: 4),
          Text(label)
        ],
      ),
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
