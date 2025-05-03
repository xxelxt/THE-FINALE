import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryBarItem extends StatelessWidget {
  final String image;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isActive;

  const CategoryBarItem(
      {super.key,
      required this.image,
      required this.title,
      required this.index,
      this.isActive = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: isActive ? AppStyle.primary : AppStyle.white,
            borderRadius: BorderRadius.circular(12.r)),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CustomNetworkImage(
              //   fit: BoxFit.contain,
              //   url: image,
              //   height: 48.r,
              //   width: 48.r,
              //   radius: 0,
              // ),
              // 4.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.r),
                child: Text(
                  title,
                  style: AppStyle.interNormal(
                    size: 14,
                    color: AppStyle.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }
}
