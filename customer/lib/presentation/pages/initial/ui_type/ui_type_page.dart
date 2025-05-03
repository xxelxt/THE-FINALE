import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingtea/application/main/main_provider.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/animation_button_effect.dart';
import 'package:dingtea/presentation/components/buttons/pop_button.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/app_style.dart';

@RoutePage()
class UiTypePage extends StatelessWidget {
  final bool isBack;

  const UiTypePage({super.key, this.isBack = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppHelpers.getTranslation(TrKeys.useAppNow),
          style: AppStyle.interNoSemi(),
        ),
      ),
      // body: GridView.builder(
      //   itemCount: 4,
      //   padding: REdgeInsets.symmetric(horizontal: 16, vertical: 24),
      //   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //   //   crossAxisCount: 2,
      //   //   mainAxisExtent: MediaQuery.sizeOf(context).height / 2 - 64.h,
      //   //   crossAxisSpacing: 12,
      //   //   mainAxisSpacing: 12,
      //   // ),
      //   itemBuilder: (context, index) {
      //     return AnimationButtonEffect(
      //       child: Consumer(
      //         builder: (BuildContext context, WidgetRef ref, Widget? child) {
      //           return GestureDetector(
      //             onTap: () async {
      //               await LocalStorage.setUiType(index);
      //               if (context.mounted) {
      //                 ref.read(mainProvider.notifier).selectIndex(0);
      //                 context.replaceRoute(const MainRoute());
      //               }
      //             },
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 border: Border.all(
      //                     color: AppHelpers.getType() == index
      //                         ? AppStyle.primary
      //                         : AppStyle.transparent,
      //                     width: 3),
      //                 borderRadius: BorderRadius.circular(12.r),
      //               ),
      //               child: ClipRRect(
      //                 borderRadius: BorderRadius.circular(12.r),
      //                 child: Image.asset(
      //                   "assets/images/ui$index.png",
      //                 ),
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ),
      body: ListView.builder(
        itemCount: 1,
        padding: REdgeInsets.symmetric(horizontal: 30, vertical: 30),
        itemBuilder: (context, index) {
          return AnimationButtonEffect(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return GestureDetector(
                  onTap: () async {
                    await LocalStorage.setUiType(index);
                    if (context.mounted) {
                      ref.read(mainProvider.notifier).selectIndex(0);
                      context.replaceRoute(const MainRoute());
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    // Khoảng cách giữa các item
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppHelpers.getType() == index
                              ? AppStyle.primary
                              : AppStyle.transparent,
                          width: 3),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Center(
                        child: Image.asset(
                          "assets/images/ui$index.png",
                          width: 280.r,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: isBack
          ? Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: const PopButton(),
            )
          : const SizedBox.shrink(),
    );
  }
}
