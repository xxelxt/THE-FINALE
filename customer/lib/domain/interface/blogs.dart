import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/domain/handlers/handlers.dart';

abstract class BlogsRepositoryFacade {
  Future<ApiResult<BlogsPaginateResponse>> getBlogs(int page, String type);

  Future<ApiResult<BlogDetailsResponse>> getBlogDetails(String uuid);
}
