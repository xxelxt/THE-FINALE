import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dingtea/domain/di/dependency_manager.dart';

import 'currency_notifier.dart';
import 'currency_state.dart';

final currencyProvider = StateNotifierProvider<CurrencyNotifier, CurrencyState>(
  (ref) => CurrencyNotifier(currenciesRepository),
);
