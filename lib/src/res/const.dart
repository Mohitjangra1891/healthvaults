import 'package:healthvaults/src/res/appImages.dart';

final String gemini_Api_key = "AIzaSyD9qInR8qPrJf77MSovq2op_e4XeNzzYnY";
class GoalKeys {
  static const loseWeight = "Lose Weight";
  static const strengthGain = "Strength Gain";
  static const flexibility = "flexibility";
}
final String DISCLAIMER = "Disclaimer:- This app provides AI-generated exercise recommendations " +
    "based on general fitness principles. It is not a substitute for professional medical or " +
    "fitness advice. Always consult with a qualified healthcare provider before beginning any new " +
    "exercise program, especially if you have underlying health conditions. The app developers are not " +
    "responsible for any injuries, health complications, or adverse effects resulting from the exercises " +
    "suggested. Exercise carefully and listen to your body";

class Constants {

 static String getTaskIcon(String type) {
    switch (type) {
      case 'EXERCISE':
        return 'assets/images/bosu_ball.png';
      case 'WARM-UP':
        return 'assets/images/warm_up.png';
      case 'COOL-DOWN':
        return 'assets/images/cool_down.png';
      default:
        return 'assets/images/bosu_ball.png';
    }
  }
  static String getWorkoutIcon(String day) {
    switch (day) {
      case 'Monday':
        return appImages.exe1;
      case 'Tuesday':
        return appImages.exe2;
      case 'Wednesday':
        return appImages.exe3;
      case 'Thursday':
        return appImages.exe4;
      case 'Friday':
        return appImages.exe5;
      case 'Saturday':
        return appImages.exe6;
      default:
        return appImages.exe7;
    }
  }


  static String getIconPath(String icon) {
    switch (icon) {
      case "Strength Training":
      case "Strength & Mobility":
        return 'assets/images/arm.png';
      case "HIIT":
        return 'assets/images/fire.png';
      case "Cardio":
      case "Cardio & Agility":
        return 'assets/images/running.png';
      case "Yoga/Flexibility":
      case "Yoga Flow":
        return 'assets/images/yoga.png';
      case "Core & Mobility":
        return 'assets/images/weightlifting.png';
      case "Active Recovery":
        return 'assets/images/recovery.png';
      case "Rest":
        return 'assets/images/rest_icon.png';
      case "Dynamic Stretching":
        return 'assets/images/refresh.png';
      case "Deep Stretching":
        return 'assets/images/spiral.png';
      case "Balance & Stability":
        return 'assets/images/target.png';
      case "Upper Body Strength":
        return 'assets/images/upper_body.png';
      case "Lower Body Strength":
        return 'assets/images/leg.png';
      case "Full Body Strength":
        return 'assets/images/full_body.png';
      default:
        return 'assets/images/arm.png';
    }
  }
 static String getGoalText(Set<String> goals, double? loseWeight) {
    final hasLoseWeight = goals.contains(GoalKeys.loseWeight);
    final hasStrength = goals.contains(GoalKeys.strengthGain);
    final hasFlexibility = goals.contains(GoalKeys.flexibility);

    final lw = loseWeight == null || !hasLoseWeight
        ? ""
        : "around ${loseWeight.toInt()} kg";

    final sum = [
      if (hasLoseWeight) 1,
      if (hasStrength) 2,
      if (hasFlexibility) 3,
    ].fold(0, (prev, el) => prev + (el * el));

    switch (sum) {
      case 1:
        return lw.isEmpty ? "Weight Lose" : "Weight Lose $lw";
      case 4:
        return "Strength Gain";
      case 9:
        return lw.isEmpty ? "Body Flexibility" : "Body Flexibility and Mobility";
      case 5:
        return lw.isEmpty
            ? "Weight Lose and Strength Gain"
            : "Weight Lose $lw and Strength Gain";
      case 13:
        return lw.isEmpty
            ? "Strength Gain and Flexibility"
            : "Strength Gain and Body Flexibility and Mobility";
      case 10:
        return lw.isEmpty
            ? "Weight Lose and Gain Body Flexibility"
            : "Weight Lose $lw and Gain Body Flexibility & Mobility";
      case 14:
        return lw.isEmpty
            ? "Weight Lose, Strength Gain and Body Flexibility"
            : "Weight Lose $lw, Strength Gain and Body Flexibility & Mobility";
      default:
        return "";
    }
  }

}
