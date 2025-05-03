import 'package:dingtea/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_notifier.dart';
import 'order_state.dart';

final orderProvider =
    StateNotifierProvider.autoDispose<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(ordersRepository, shopsRepository, paymentsRepository,
      cartRepository, drawRepository),
);
