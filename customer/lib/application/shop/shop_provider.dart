import 'package:dingtea/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shop_notifier.dart';
import 'shop_state.dart';

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>(
  (ref) => ShopNotifier(shopsRepository, productsRepository,
      categoriesRepository, drawRepository, brandsRepository),
);
