import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/models/response/multi_gallery_upload_response.dart';
import 'package:dingtea/infrastructure/services/enums.dart';

abstract class GalleryRepositoryFacade {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
      String file, UploadType uploadType);

  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  );
}
