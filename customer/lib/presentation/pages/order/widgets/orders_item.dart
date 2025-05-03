import 'package:auto_route/auto_route.dart';
import 'package:dingtea/infrastructure/models/data/order_active_model.dart';
import 'package:dingtea/infrastructure/models/data/refund_data.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/enums.dart';
import 'package:dingtea/infrastructure/services/time_service.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/shop_avarat.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrdersItem extends StatelessWidget {
  final OrderActiveModel? order;
  final RefundModel? refund;
  final bool isActive;
  final bool isRefund;

  const OrdersItem(
      {super.key,
      required this.isActive,
      this.isRefund = false,
      this.order,
      this.refund});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(
          OrderProgressRoute(
            orderId: isRefund ? (refund?.order?.id ?? 0) : (order?.id ?? 0),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
            color: AppStyle.white, borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: isRefund
                        ? ((refund?.status ?? "") == "pending"
                            ? AppStyle.primary
                            : AppStyle.bgGrey)
                        : (isActive ? AppStyle.primary : AppStyle.bgGrey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: isRefund
                      ? Center(
                          child: (refund?.status ?? "") == "pending"
                              ? Stack(
                                  children: [
                                    Center(
                                        child: SvgPicture.asset(
                                            "assets/svgs/orderTime.svg")),
                                    Center(
                                      child: Text(
                                        "15",
                                        style: AppStyle.interNoSemi(
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  (refund?.status ?? "") == "accepted"
                                      ? Icons.done_all
                                      : Icons.cancel_outlined,
                                  size: 16.r,
                                ),
                        )
                      : Center(
                          child: isActive
                              ? Stack(
                                  children: [
                                    Center(
                                        child: SvgPicture.asset(
                                            "assets/svgs/orderTime.svg")),
                                    Center(
                                      child: Text(
                                        "15",
                                        style: AppStyle.interNoSemi(
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  AppHelpers.getOrderStatus(
                                              order?.status ?? "") ==
                                          OrderStatus.delivered
                                      ? Icons.done_all
                                      : Icons.cancel_outlined,
                                  size: 16.r,
                                ),
                        ),
                ),
                6.horizontalSpace,
                ShopAvatar(
                  shopImage: isRefund
                      ? (refund?.order?.shop?.logoImg ?? "")
                      : (order?.shop?.logoImg ?? ""),
                  size: 36,
                  padding: 4,
                  radius: 6,
                  bgColor: AppStyle.bgGrey,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 220.w,
                      child: Text(
                        isRefund
                            ? (refund?.order?.shop?.translation?.title ?? "")
                            : (order?.shop?.translation?.title ?? ""),
                        style: AppStyle.interNoSemi(
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        isRefund
                            ? (refund?.order?.shop?.translation?.description ??
                                "")
                            : (order?.shop?.translation?.description ?? ""),
                        style: AppStyle.interRegular(
                          size: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                )
              ],
            ),
            22.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRefund
                          ? AppHelpers.getTranslation(TrKeys.cause)
                          : AppHelpers.numberFormat(
                              isOrder: order?.currencyModel?.symbol != null,
                              symbol: order?.currencyModel?.symbol,
                              number: isRefund
                                  ? 0
                                  : (order?.totalPrice?.isNegative ?? true)
                                      ? 0
                                      : (order?.totalPrice ?? 0)),
                      style: AppStyle.interNoSemi(
                        size: 16,
                      ),
                    ),
                    isRefund
                        ? Text(
                            refund?.cause ?? "",
                            style: AppStyle.interRegular(
                              size: 12,
                            ),
                          )
                        : Text(
                            TimeService.dateFormatMDHm(order?.createdAt),
                            style: AppStyle.interRegular(size: 12),
                          )
                  ],
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: const BoxDecoration(
                      color: AppStyle.enterOrderButton, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
