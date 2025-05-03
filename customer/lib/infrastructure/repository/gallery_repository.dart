import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dingtea/domain/di/dependency_manager.dart';
import 'package:dingtea/domain/interface/gallery.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/models/response/multi_gallery_upload_response.dart';
import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/enums.dart';

class GalleryRepository implements GalleryRepositoryFacade {
  @override
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String file,
    UploadType uploadType,
  ) async {
    String type = '';
    switch (uploadType) {
      case UploadType.brands:
        type = 'brands';
        break;
      case UploadType.extras:
        type = 'extras';
        break;
      case UploadType.categories:
        type = 'categories';
        break;
      case UploadType.shopsLogo:
        type = 'shops/logo';
        break;
      case UploadType.shopsBack:
        type = 'shops/background';
        break;
      case UploadType.products:
        type = 'products';
        break;
      case UploadType.reviews:
        type = 'reviews';
        break;
      case UploadType.users:
        type = 'users';
        break;
      default:
        type = 'extras';
        break;
    }
    final data = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(file),
        'type': type,
      },
    );
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/galleries',
        data: data,
      );
      return ApiResult.success(
        data: GalleryUploadResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> upload image failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  ) async {
    String type = '';
    switch (uploadType) {
      case UploadType.shopsLogo:
        type = 'shops/logo';
        break;
      case UploadType.shopsBack:
        type = 'shops/background';
        break;
      default:
        type = uploadType.name;
        break;
    }
    final data = FormData.fromMap(
      {
        for (int i = 0; i < filePaths.length; i++)
          if (filePaths[i] != null)
            'images[$i]': await MultipartFile.fromFile(filePaths[i]!),
        'type': type,
      },
    );
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/galleries/store-many',
        data: data,
      );
      return ApiResult.success(
        data: MultiGalleryUploadResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> upload multi image failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
