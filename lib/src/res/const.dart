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

  static String getPromt(
      {required String place, required String goals, required String age, required String gender, required String weight, required String height}) {
    final prompt = """
       Generate a structured JSON response for a **Personalized 3-Month from $place for only $goals Workout Plan** tailored for a $age-year-old $gender, weighing $weight kg and $height cm tall.  
            There should be no rest day.
            Format:  
            1. "plan_name" (string): The name of the workout plan. 
            2. "achievement" (string): Expected result or transformation on body after completion.
            3. "weekly_schedule" (object): A key-value map where:  
               - Keys are days of the week ("Monday"-"Sunday").  
               - Value is the workout category (only one per day).  
               - insure sunday will be Active Recovery and only one day Active Recovery
            4. "workouts" (object): A key-value map where:  
               - Keys are "month_1", "month_2", and "month_3". 
               - Values are objects containing specific workout categories: "Strength Training", "HIIT", "Yoga/Flexibility", "Cardio", "Core & Mobility", 
                    "Yoga Flow", "Dynamic Stretching", "Strength & Mobility", "Cardio & Agility", "Deep Stretching","Balance & Stability" "Upper Body Strength", "Lower Body Strength",
                     "Full Body Strength" and "Active Recovery" (Choose only relevant workouts according to plan requirements).  
               - Each workout category contains worm-up, exercises and cool-down, where each warm-up, exercises and cool-down is an object with:  
                 - "exercise" or "warm-up" or "cool-down" (string): Name of the exercise.  
                 - "reps" (string, optional): Number of sets and repetitions (e.g., "3 sets of 12 reps").  
                 - "duration" (string, optional): Time-based exercises (e.g., "30 seconds", "10 minutes").  
                 - "steps" (string, optional): Number of steps for walking-based exercises (e.g., "5-10k steps").  
            
            Requirements:  
            - Each workout should have warm-up and cool down
            - Exercise for each day should wrap around one and half hour
            - Active Recovery should also have some exercises
            - The difficulty increases each month by progressively increasing reps, duration, or intensity.  
            - Ensure consistent field names ("warm-up","exercise","cool-down" "reps", "duration", "steps").  
            
            Example Progression:  
            - month_1: Standard reps/duration.  
            - month_2: Increase reps by 10%-20%, extend duration, or reduce rest time.  
            - month_3: Further increase reps/duration, introduce additional sets, or add higher intensity variations.  
            
            ### Response Guidelines 
            - Do not add "json" or any markdown formatting in the response.  
            - Ensure the JSON is valid and properly structured.  
            - The response must contain only the structured JSON object without any extra characters or explanations.  
            
            ### **Example Response Structure**  
            
            {  
              "plan_name": "",  
              "achievement":"",
              "weekly_schedule": {  
                "Monday": "",  
                "Tuesday": "",  
                "Wednesday": "",  
                "Thursday": "",  
                "Friday": "",  
                "Saturday": "",  
                "Sunday": ""  
              },  
              "workouts": {  
                "month_1": {  
                  "Strength Training": [ 
                    { "warm-up": "", "reps": "", "duration": "", "steps": "" },
                    { "exercise": "", "reps": "", "duration": "", "steps": "" },  
                    { "exercise": "", "reps": "", "duration": "", "steps": "" },
                    { "cool-down": "", "reps": "", "duration": "", "steps": "" } 
                  ],  
                  "HIIT": [  
                    { "warm-up": "", "reps": "", "duration": "", "steps": "" },
                    { "exercise": "", "reps": "", "duration": "", "steps": "" },  
                    { "cool-down": "", "reps": "", "duration": "", "steps": "" }   
                  ],  
                  "Cardio": [  
                    { "warm-up": "", "reps": "", "duration": "", "steps": "" }, 
                    { "exercise": "", "reps": "", "duration": "", "steps": "" },  
                    { "cool-down": "", "reps": "", "duration": "", "steps": "" }   
                  ]  
                },  
                "month_2": {  
                  "Strength Training": [  
                    { "warm-up": "", "reps": "", "duration": "", "steps": "" }, 
                    { "exercise": "", "reps": "", "duration": "", "steps": "" },  
                    { "cool-down": "", "reps": "", "duration": "", "steps": "" } 
                  ]  
                },  
                "month_3": {  
                  "Core & Mobility": [  
                    { "warm-up": "", "reps": "", "duration": "", "steps": "" }, 
                    { "exercise": "", "reps": "", "duration": "", "steps": "" },
                    { "exercise": "", "reps": "", "duration": "", "steps": "" },
                    { "cool-down": "", "reps": "", "duration": "", "steps": "" }  
                  ]  
                }  
              }  
            }  

        """;

    return prompt;
  }
}
