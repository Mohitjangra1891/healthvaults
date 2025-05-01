import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNameProvider = StateProvider<String>((ref) => '');
final loaderProvider = StateProvider<bool>((ref) => false);
final selectedIndexProvider = StateProvider<int>((ref) => 0);

