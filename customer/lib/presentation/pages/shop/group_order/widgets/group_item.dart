import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupItem extends StatelessWidget {
  final String name;
  final bool isChoosing;
  final num? price;
  final bool isDeleteButton;
  final VoidCallback onDelete;

  const GroupItem(
      {super.key,
      required this.name,
      required this.price,
      required this.isChoosing,
      required this.onDelete,
      this.isDeleteButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.h),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: const BoxDecoration(
                        color: AppStyle.bgGrey, shape: BoxShape.circle),
                    padding: EdgeInsets.all(6.r),
                    child: SvgPicture.asset("assets/svgs/avatar.svg")),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    name,
                    style: AppStyle.interNormal(
                      size: 14,
                      color: AppStyle.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                "${isChoosing ? AppHelpers.getTranslation(TrKeys.choosing) : AppHelpers.getTranslation(TrKeys.done)} — ",
                style: AppStyle.interNormal(
                  size: 14,
                  color: AppStyle.black,
                ),
              ),
              Text(
                AppHelpers.numberFormat(number: price),
                style: AppStyle.interSemi(
                  size: 14,
                  color: AppStyle.black,
                ),
              ),
              isDeleteButton
                  ? GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        color: AppStyle.transparent,
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Icon(
                            FlutterRemix.close_fill,
                            size: 20.r,
                            color: AppStyle.black,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
