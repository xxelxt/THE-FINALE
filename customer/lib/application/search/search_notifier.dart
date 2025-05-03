import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dingtea/domain/interface/products.dart';
import 'package:dingtea/domain/interface/shops.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/services/app_connectivity.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';

import 'search_state.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  final ShopsRepositoryFacade _shopsRepository;
  final ProductsRepositoryFacade _productsRepository;

  SearchNotifier(this._shopsRepository, this._productsRepository)
      : super(const SearchState());
  int productIndex = 1;

  init() {
    List<String> list = LocalStorage.getSearchList();
    state = state.copyWith(searchHistory: list, search: "");
  }

  void setSelectCategory(int index, BuildContext context, {int? categoryId}) {
    if (state.selectIndexCategory == index) {
      state = state.copyWith(
        selectIndexCategory: -1,
      );
    } else {
      state = state.copyWith(
        selectIndexCategory: index,
      );
    }
    if (state.search.isNotEmpty) {
      searchProduct(context, state.search);
      searchShop(context, state.search, categoryId: categoryId);
    }
  }

  void changeSearch(String text) async {
    List<String> list = List.from(state.searchHistory);
    if (text.isNotEmpty && !list.contains(text)) {
      list.add(text);
    }
    state = state.copyWith(search: text, searchHistory: list);
    LocalStorage.setSearchHistory(list);
  }

  void clearAllHistory() {
    state = state.copyWith(searchHistory: []);
    LocalStorage.deleteSearchList();
  }

  void clearHistory(int index) {
    List<String> list = List.from(state.searchHistory);
    list.removeAt(index);
    state = state.copyWith(searchHistory: list);
    LocalStorage.setSearchHistory(list);
  }

  Future<void> searchShop(BuildContext context, String text,
      {int? categoryId}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isShopLoading: true);
      final response = await _shopsRepository.searchShops(
          text: text, categoryId: categoryId);
      response.when(
        success: (data) async {
          state = state.copyWith(isShopLoading: false, shops: data.data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isShopLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> searchProduct(BuildContext context, String text) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isProductLoading: true);
      final response = await _productsRepository.searchProducts(text: text);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isProductLoading: false, products: data.data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isProductLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> searchProductPage(BuildContext context, String text) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response = await _productsRepository.searchProducts(
          text: text, page: ++productIndex);
      response.when(
        success: (data) async {
          if (data.data != null) {
            List<ProductData> list = List.from(state.products);
            list.addAll(data.data!);
            state = state.copyWith(
              products: list,
            );
          } else {
            productIndex--;
          }
        },
        failure: (failure, status) {
          productIndex--;
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
