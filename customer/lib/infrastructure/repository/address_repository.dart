import 'package:flutter/material.dart';
import 'package:dingtea/domain/di/dependency_manager.dart';
import 'package:dingtea/domain/interface/address.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/domain/handlers/handlers.dart';

class AddressRepository implements AddressRepositoryFacade {
  @override
  Future<ApiResult<AddressesResponse>> getUserAddresses() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/user/addresses');
      return ApiResult.success(
        data: AddressesResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get user addresses failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteAddress(int addressId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete('/api/v1/dashboard/user/addresses/$addressId');
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> delete address failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleAddressResponse>> createAddress(
    LocalAddressData address,
  ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/user/addresses',
        data: address.toJson(),
      );
      return ApiResult.success(
        data: SingleAddressResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create address failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
