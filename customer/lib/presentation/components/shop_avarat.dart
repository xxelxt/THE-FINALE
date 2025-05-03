import 'package:dingtea/presentation/components/custom_network_image.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ShopAvatar extends StatelessWidget {
  final String shopImage;
  final double size;
  final double padding;
  final double radius;
  Color bgColor;

  ShopAvatar({
    super.key,
    required this.shopImage,
    required this.size,
    required this.padding,
    this.bgColor = AppStyle.whiteWithOpacity,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      padding: EdgeInsets.all(padding.r),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(radius)),
      child: CustomNetworkImage(
        url: shopImage,
        height: size.r,
        width: size.r,
        radius: size.r / 2,
      ),
    );
  }
}
