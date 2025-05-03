import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dingtea/domain/di/dependency_manager.dart';
import 'register_notifier.dart';
import 'register_state.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(authRepository, userRepository),
);
