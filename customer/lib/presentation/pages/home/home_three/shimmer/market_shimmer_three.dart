import 'package:dingtea/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarketShimmerThree extends StatelessWidget {
  final bool isSimpleShop;
  final bool isShop;

  const MarketShimmerThree(
      {super.key, this.isSimpleShop = false, this.isShop = false});

  @override
  Widget build(BuildContext context) {
    return isShop
        ? Container(
            margin: EdgeInsets.only(right: 8.r),
            width: 134.w,
            height: 130.h,
            decoration: BoxDecoration(
                color: AppStyle.shimmerBase,
                borderRadius: BorderRadius.circular(10.r)),
          )
        : Container(
            margin: isSimpleShop
                ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h)
                : EdgeInsets.only(right: 8.r),
            width: 268.w,
            height: 260.h,
            decoration: BoxDecoration(
                color: AppStyle.shimmerBase,
                borderRadius: BorderRadius.circular(10.r)),
          );
  }
}
