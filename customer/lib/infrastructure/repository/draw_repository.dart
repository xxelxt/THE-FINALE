import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dingtea/domain/di/dependency_manager.dart';
import 'package:dingtea/domain/handlers/network_exceptions.dart';
import 'package:dingtea/domain/interface/draw.dart';
import 'package:dingtea/infrastructure/models/response/draw_routing_response.dart';
import 'package:dingtea/app_constants.dart';

import 'package:dingtea/domain/handlers/api_result.dart';

class DrawRepository implements DrawRepositoryFacade {
  @override
  Future<ApiResult<DrawRouting>> getRouting({
    required LatLng start,
    required LatLng end,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false, routing: true);
      final response = await client.get(
        '/v2/directions/driving-car',
        queryParameters: {
          "api_key": AppConstants.routingKey,
          "start": (start.longitude, start.latitude),
          "end": (end.longitude, end.latitude)
        },
      );
      return ApiResult.success(
        data: DrawRouting.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
