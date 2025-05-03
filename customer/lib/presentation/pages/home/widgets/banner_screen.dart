import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingtea/infrastructure/models/data/shop_data.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/components/custom_network_image.dart';

import 'package:dingtea/infrastructure/services/app_helpers.dart';
import '../../../routes/app_router.dart';
import 'package:dingtea/presentation/theme/app_style.dart';

class BannerScreen extends StatelessWidget {
  final String image;
  final int bannerId;
  final String desc;
  final bool isAds;
  final List<ShopData> list;

  const BannerScreen(
      {super.key,
      required this.image,
      required this.desc,
      required this.list,
      required this.bannerId,
      this.isAds = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 192.h,
            width: MediaQuery.sizeOf(context).width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
              child: CustomNetworkImage(
                url: image,
                height: double.infinity,
                width: double.infinity,
                radius: 0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              desc,
              style:
                  AppStyle.interRegular(size: 14.sp, color: AppStyle.textGrey),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                      background: AppStyle.transparent,
                      borderColor: AppStyle.tabBarBorderColor,
                      title: AppHelpers.getTranslation(TrKeys.cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                10.horizontalSpace,
                Expanded(
                  child: CustomButton(
                      title: AppHelpers.getTranslation(TrKeys.orderNow),
                      onPressed: () {
                        context.pushRoute(ShopsBannerRoute(
                            bannerId: bannerId, title: desc, isAds: isAds));
                      }),
                ),
              ],
            ),
          ),
          16.verticalSpace
        ],
      ),
    );
  }
}
