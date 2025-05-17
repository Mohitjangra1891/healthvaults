import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/app.dart';
import 'package:healthvaults/src/modals/TaskEntity.dart';
import 'package:healthvaults/src/modals/WeeklyWorkoutPlan.dart';
import 'package:healthvaults/src/modals/workoutPlan.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

const apiKey = 'AIzaSyD9qInR8qPrJf77MSovq2op_e4XeNzzYnY'; // Replace with your actual API key

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      // Hive.init(appDocDir.path);
      await Hive.initFlutter(appDocDir.path);
    }

    Hive.registerAdapter(WorkoutPlan2Adapter());
    Hive.registerAdapter(WorkoutDayAdapter());
    Hive.registerAdapter(RoutineItemAdapter());



    Hive.registerAdapter(WorkoutPlanAdapter());
    Hive.registerAdapter(WorkoutMonthAdapter());
    Hive.registerAdapter(TaskEntityAdapter());

    // Open a box for storing WorkoutPlan objects
    await Hive.openBox<WorkoutPlan>('workoutPlans');
    await Hive.openBox<WorkoutPlan2>('workoutPlan2');
    runApp(ProviderScope(child: const MyApp()));
  } catch (e) {
    print('Error initializing Hive: $e');
  }
}
