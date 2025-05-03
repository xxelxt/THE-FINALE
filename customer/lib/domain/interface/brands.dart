import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/models/models.dart';

abstract class BrandsRepositoryFacade {
  Future<ApiResult<BrandsPaginateResponse>> getBrandsPaginate(int page);

  Future<ApiResult<BrandsPaginateResponse>> searchBrands(String query);

  Future<ApiResult<SingleBrandResponse>> getSingleBrand(int id);

  Future<ApiResult<BrandsPaginateResponse>> getAllBrands(
      {required int categoryId});
}
