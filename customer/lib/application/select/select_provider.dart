import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'select_notifier.dart';
import 'select_state.dart';

final selectProvider =
    StateNotifierProvider.autoDispose<SelectNotifier, SelectState>(
  (ref) => SelectNotifier(),
);
