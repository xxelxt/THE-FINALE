import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingtea/infrastructure/models/data/bonus_data.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';

import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/components/title_icon.dart';
import 'package:dingtea/presentation/theme/app_style.dart';

class BonusScreen extends StatelessWidget {
  final BonusModel? bonus;

  const BonusScreen({super.key, required this.bonus});

  @override
  Widget build(BuildContext context) {
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: AppStyle.bgGrey.withOpacity(0.96),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            )),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.verticalSpace,
              Center(
                child: Container(
                  height: 4.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                      color: AppStyle.dragElement,
                      borderRadius: BorderRadius.all(Radius.circular(40.r))),
                ),
              ),
              14.verticalSpace,
              TitleAndIcon(
                title: AppHelpers.getTranslation(TrKeys.bonus),
                paddingHorizontalSize: 0,
              ),
              10.verticalSpace,
              Text(
                bonus != null
                    ? ((bonus?.type ?? "sum") == "sum")
                        ? "${bonus?.bonusStock?.product?.translation?.title ?? ""} ${AppHelpers.getTranslation(TrKeys.giftBuy)} ${AppHelpers.numberFormat(
                            number: bonus?.value,
                          )}"
                        : "${bonus?.bonusStock?.product?.translation?.title ?? ""} ${AppHelpers.getTranslation(TrKeys.giftBuy)} ${bonus?.value ?? 0} ${AppHelpers.getTranslation(TrKeys.count)} "
                    : AppHelpers.getTranslation(TrKeys.bonus),
                style: AppStyle.interRegular(
                  size: 14,
                  color: AppStyle.black,
                ),
              ),
              30.verticalSpace,
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: CustomButton(
                  title: AppHelpers.getTranslation(TrKeys.wantIt),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
