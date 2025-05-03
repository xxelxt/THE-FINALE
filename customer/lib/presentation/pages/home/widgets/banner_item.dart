import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/presentation/components/custom_network_image.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'banner_screen.dart';

class BannerItem extends StatelessWidget {
  final BannerData banner;
  final bool isAds;

  const BannerItem({
    super.key,
    required this.banner,
    this.isAds = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHelpers.showCustomModalBottomSheet(
            context: context,
            modal: BannerScreen(
              isAds: isAds,
              bannerId: banner.id ?? 0,
              image: banner.img ?? "",
              desc: banner.translation?.description ?? "",
              list: banner.shops ?? [],
            ),
            isDarkMode: false);
      },
      child: Container(
          margin: EdgeInsets.only(right: 6.r),
          width: MediaQuery.sizeOf(context).width - 46,
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
          ),
          child: CustomNetworkImage(
            bgColor: AppStyle.white,
            url: banner.img ?? "",
            height: double.infinity,
            width: double.infinity,
            radius: 8.r,
          )),
    );
  }
}
