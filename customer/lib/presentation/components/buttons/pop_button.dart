import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingtea/presentation/theme/theme.dart';

import 'animation_button_effect.dart';

class PopButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PopButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      child: AnimationButtonEffect(
        child: Container(
          decoration: BoxDecoration(
              color: AppStyle.black, borderRadius: BorderRadius.circular(10.r)),
          padding: EdgeInsets.all(14.h),
          child: const Icon(
            Icons.keyboard_arrow_left,
            color: AppStyle.white,
          ),
        ),
      ),
    );
  }
}
