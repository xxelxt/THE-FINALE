import 'package:dingtea/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'orders_list_notifier.dart';
import 'orders_list_state.dart';

final ordersListProvider =
    StateNotifierProvider<OrdersListNotifier, OrdersListState>(
  (ref) => OrdersListNotifier(ordersRepository),
);
