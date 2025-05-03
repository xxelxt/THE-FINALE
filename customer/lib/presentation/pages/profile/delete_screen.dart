// ignore_for_file: unused_result

import 'package:auto_route/auto_route.dart';
import 'package:dingtea/application/profile/profile_provider.dart';
import 'package:dingtea/application/shop_order/shop_order_provider.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteScreen extends StatelessWidget {
  final bool isDeleteAccount;
  final VoidCallback onDelete;

  const DeleteScreen(
      {super.key, this.isDeleteAccount = false, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppHelpers.getTranslation(TrKeys.areYouSure),
          style: AppStyle.interSemi(size: 16.sp),
          textAlign: TextAlign.center,
        ),
        isDeleteAccount
            ? Column(
                children: [
                  16.verticalSpace,
                  Consumer(builder: (context, ref, child) {
                    return CustomButton(
                        background: AppStyle.red,
                        textColor: AppStyle.white,
                        title: AppHelpers.getTranslation(TrKeys.deleteAccount),
                        onPressed: () {
                          ref.refresh(shopOrderProvider);
                          ref.refresh(profileProvider);
                          ref
                              .read(profileProvider.notifier)
                              .deleteAccount(context);
                        });
                  }),
                ],
              )
            : Column(
                children: [
                  24.verticalSpace,
                  Consumer(builder: (context, ref, child) {
                    return CustomButton(
                        title: AppHelpers.getTranslation(TrKeys.logout),
                        onPressed: () {
                          onDelete.call();
                          ref.read(profileProvider.notifier).logOut();
                          ref.refresh(shopOrderProvider);
                          ref.refresh(profileProvider);
                          context.router.popUntilRoot();
                          context.replaceRoute(const LoginRoute());
                        });
                  }),
                ],
              ),
        16.verticalSpace,
        CustomButton(
            borderColor: AppStyle.black,
            background: AppStyle.transparent,
            title: AppHelpers.getTranslation(TrKeys.cancel),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
