import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/models/data/generate_image_model.dart';
import 'package:dingtea/infrastructure/models/data/help_data.dart';
import 'package:dingtea/infrastructure/models/data/notification_list_data.dart';
import 'package:dingtea/infrastructure/models/data/translation.dart';
import 'package:dingtea/infrastructure/models/models.dart';

abstract class SettingsRepositoryFacade {
  Future<ApiResult<GlobalSettingsResponse>> getGlobalSettings();

  Future<ApiResult<MobileTranslationsResponse>> getMobileTranslations();

  Future<ApiResult<LanguagesResponse>> getLanguages();

  Future<ApiResult<NotificationsListModel>> getNotificationList();

  Future<ApiResult<dynamic>> updateNotification(
      List<NotificationData>? notifications);

  Future<ApiResult<HelpModel>> getFaq();

  Future<ApiResult<Translation>> getTerm();

  Future<ApiResult<Translation>> getPolicy();

  Future<ApiResult<GenerateImageModel>> getGenerateImage(String name);
}
