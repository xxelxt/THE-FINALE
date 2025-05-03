import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dingtea/domain/di/dependency_manager.dart';
import 'register_confirmation_notifier.dart';
import 'register_confirmation_state.dart';

final registerConfirmationProvider = StateNotifierProvider.autoDispose<
    RegisterConfirmationNotifier, RegisterConfirmationState>(
  (ref) => RegisterConfirmationNotifier(authRepository, userRepository),
);
