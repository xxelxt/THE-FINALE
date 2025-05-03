import 'package:auto_route/auto_route.dart';
import 'package:dingtea/infrastructure/models/data/shop_data.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/shop_avarat.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/badge_item.dart';

class RestaurantItem extends StatelessWidget {
  final ShopData shop;

  const RestaurantItem({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          context.pushRoute(
            ShopRoute(
              shopId: (shop.id ?? 0).toString(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppStyle.white.withOpacity(0.04),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              children: [
                ShopAvatar(
                  shopImage: shop.logoImg ?? "",
                  size: 50,
                  padding: 6,
                  bgColor: AppStyle.blackWithOpacity,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          (shop.translation?.title?.length ?? 0) > 24
                              ? "${shop.translation?.title?.substring(0, 24) ?? " "}..."
                              : shop.translation?.title ?? "",
                          style: AppStyle.interSemi(
                            size: 15,
                            color: AppStyle.black,
                          ),
                        ),
                        if (shop.verify ?? false)
                          Padding(
                            padding: EdgeInsets.only(left: 4.r),
                            child: const BadgeItem(),
                          )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - 200.h,
                      child: Text(
                        shop.bonus != null
                            ? ((shop.bonus?.type ?? "sum") == "sum")
                                ? "${AppHelpers.getTranslation(TrKeys.under)} ${AppHelpers.numberFormat(number: shop.bonus?.value)} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                                : "${AppHelpers.getTranslation(TrKeys.under)} ${shop.bonus?.value ?? 0} + ${shop.bonus?.bonusStock?.product?.translation?.title ?? ""}"
                            : shop.translation?.description ?? "",
                        style: AppStyle.interNormal(
                          size: 12,
                          color: AppStyle.black,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
