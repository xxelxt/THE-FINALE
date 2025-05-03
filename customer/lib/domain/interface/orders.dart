import 'package:dingtea/domain/handlers/handlers.dart';
import 'package:dingtea/infrastructure/models/data/get_calculate_data.dart';
import 'package:dingtea/infrastructure/models/data/order_active_model.dart';
import 'package:dingtea/infrastructure/models/data/refund_data.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/services/enums.dart';

abstract class OrdersRepositoryFacade {
  Future<ApiResult<GetCalculateModel>> getCalculate(
      {required int cartId,
      required double lat,
      required double long,
      required DeliveryTypeEnum type,
      String? coupon});

  Future<ApiResult<OrderActiveModel>> createOrder(OrderBodyData orderBody);

  Future<ApiResult> createAutoOrder(String from, String to, int orderId);

  Future<ApiResult> deleteAutoOrder(int orderId);

  Future<ApiResult<OrderPaginateResponse>> getCompletedOrders(int page);

  Future<ApiResult<OrderPaginateResponse>> getActiveOrders(int page);

  Future<ApiResult<OrderPaginateResponse>> getHistoryOrders(int page);

  Future<ApiResult<RefundOrdersModel>> getRefundOrders(int page);

  Future<ApiResult<OrderActiveModel>> getSingleOrder(num orderId);

  Future<ApiResult<LocalLocation>> getDriverLocation(int deliveryId);

  Future<ApiResult<void>> cancelOrder(num orderId);

  Future<ApiResult<void>> refundOrder(num orderId, String title);

  Future<ApiResult<void>> addReview(
    num orderId, {
    required double rating,
    required String comment,
  });

  Future<ApiResult<String>> process(OrderBodyData orderBody, String name);

  Future<ApiResult<String>> tipProcess(
      int? orderId, String paymentName, int? paymentId, num? tips);

  Future<ApiResult<CouponResponse>> checkCoupon({
    required String coupon,
    required int shopId,
  });

  Future<ApiResult<CashbackResponse>> checkCashback(
      {required double amount, required int shopId});
}
