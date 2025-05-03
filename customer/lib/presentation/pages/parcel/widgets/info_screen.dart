import 'package:auto_route/auto_route.dart';
import 'package:dingtea/app_constants.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class InfoPage extends StatelessWidget {
  final int index;

  const InfoPage({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppConstants.infoImage[index]),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppHelpers.getTranslation(AppConstants.infoTitle[index]),
                    style:
                        AppStyle.interNoSemi(size: 40, color: AppStyle.white),
                  ),
                  40.verticalSpace,
                  CustomButton(
                      title: index == 3
                          ? AppHelpers.getTranslation(TrKeys.back)
                          : AppHelpers.getTranslation(TrKeys.next),
                      onPressed: () {
                        if (index == 3) {
                          context.maybePop();
                          return;
                        }
                        context.replaceRoute(InfoRoute(
                          index: index + 1,
                        ));
                      }),
                  32.verticalSpace
                ],
              ),
            ),
          ),
          Positioned(
            top: 32.r,
            right: 8.r,
            child: IconButton(
                onPressed: () {
                  context.maybePop();
                },
                icon: Icon(
                  FlutterRemix.close_line,
                  color: AppStyle.white,
                  size: 32.r,
                )),
          )
        ],
      ),
    );
  }
}
