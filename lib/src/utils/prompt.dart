import 'dart:core';
class prompt {
 static String getPromt1({required String level,
    required String equipments,
    required String days,
    required String time,
    required String place,
    required String goals,
    required String age,
    required String gender,
    required String weight,
    required String height}) {
    final prompt = """
            Hello coach,
            Generate a structured JSON response for a personalized $level 1-week at $place workout plan focused on $goals for a $age-year-old $gender, weighing $weight kg and $height cm tall.
            This is the first week only — I will provide a report after completing this week, and based on my progress, I want you to generate the next week's plan accordingly.     
            $equipments
            
            Available days of workout this week:
            $days
            
            Guidelines:                    
            Each session should last about $time         
            Each day must include  warm_up, main exercises, and cool_down                        
            Use consistent field names: 'warm_up', 'exercise', 'cool_down', 'instruction', 'reps', 'duration', 'steps'
                        
            JSON Format:            
            'plan_name': A motivating name for the plan            
            'achievement': What transformation or benefit to expect after this week            
            'remark_1': General coach insight or advice            
            'remark_2': Motivational or lifestyle suggestion            
            'workouts': An object with keys: [$days] only available days of week. Each day should include:           
             'theme': A unique theme and cool theme (e.g. 'Fat Burn Monday')            
             'routine': A list of workout steps (objects) containing:            
                'warm_up', 'exercise', and 'cool_down'            
                'instruction': short how-to or tip            
                Optional fields: 'reps', 'duration', 'steps'            
            'coach_tip': A motivational or focus note from a personal trainer           
            'common_mistake': Mistake to avoid that day            
            'alternative': Easier version of one of the exercises if too difficult                       
            At the end of the response include:            
            'reflection_questions': A list of 3 short questions I should ask myself to evaluate my performance and progress
            Example :
                "Monday": {
                  "theme": "",
                  "routine": [
                    {
                      "warm-up": "",
                      "instruction": "",
                      "duration": ""
                    },
                    {
                      "exercise": "",
                      "instruction": "",
                      "reps": ""
                    },
                    {
                      "exercise": "",
                      "instruction": "",
                      "steps": ""
                    },                  
                    {
                      "cool-down": "",
                      "instruction": "",
                      "duration": ""
                    }
                  ],
                  "coach_tip": "",
                  "common_mistake": "",
                  "alternative": ""
                }
            Response Guidelines:            
            Respond with the structured JSON only — no markdown, no extra explanation, no text outside the JSON.            
            Make it feel like it was written by a human personal coach: motivating, insightful, personalized.
        """;

    return prompt;
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