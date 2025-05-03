import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/models/response/categories_paginate_response.dart';

abstract class CategoriesRepositoryFacade {
  Future<ApiResult<CategoriesPaginateResponse>> getAllCategories(
      {required int page});

  Future<ApiResult<CategoriesPaginateResponse>> searchCategories({
    required String text,
  });

  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesByShop(
      {required String shopId});
}
