import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthvaults/src/app.dart';
import 'package:healthvaults/src/modals/TaskEntity.dart';
import 'package:healthvaults/src/modals/workoutPlan.dart';
import 'package:path_provider/path_provider.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const apiKey = 'AIzaSyD9qInR8qPrJf77MSovq2op_e4XeNzzYnY'; // Replace with your actual API key

Future<void> main() async {
try{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Hive.initFlutter();

  }
  else{
    final appDocDir = await getApplicationDocumentsDirectory();
    // Hive.init(appDocDir.path);
    await Hive.initFlutter(appDocDir.path);

  }

  Hive.registerAdapter(WorkoutPlanAdapter());
  Hive.registerAdapter(WorkoutMonthAdapter());
  Hive.registerAdapter(TaskEntityAdapter());

  // Open a box for storing WorkoutPlan objects
  await Hive.openBox<WorkoutPlan>('workoutPlans');
  runApp(ProviderScope(child: const MyApp())); } catch (e) {
print('Error initializing Hive: $e');
}
}
