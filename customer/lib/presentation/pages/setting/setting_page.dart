import 'package:auto_route/auto_route.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/app_bars/common_app_bar.dart';
import 'package:dingtea/presentation/components/buttons/pop_button.dart';
import 'package:dingtea/presentation/components/keyboard_dismisser.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'notification_page.dart';

@RoutePage()
class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  late bool isDarkMode;
  late bool isLtr;

  // final _tabs = [
  //   const Tab(text: 'Payment'),
  //   const Tab(text: 'Notification'),
  // ];

  @override
  void initState() {
    // _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(() {
    //   ref.read(settingProvider.notifier).changeIndex(_tabController.index.isOdd);
    // });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    isDarkMode = LocalStorage.getAppThemeMode();
    isLtr = LocalStorage.getLangLtr();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
          body: Column(
            children: [
              CommonAppBar(
                child: Text(
                  AppHelpers.getTranslation(TrKeys.notification),
                  style: AppStyle.interNoSemi(
                    size: 18,
                    color: AppStyle.black,
                  ),
                ),
              ),
              16.verticalSpace,
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const NotificationPage()
                  // Column(
                  //   children: [
                  //     CustomTabBar(
                  //       tabController: _tabController,
                  //       tabs: _tabs,
                  //     ),
                  //     SizedBox(
                  //       height: MediaQuery.sizeOf(context).height - 180.h,
                  //       child: TabBarView(controller: _tabController, children: [
                  //         Column(
                  //           children: [
                  //             24.verticalSpace,
                  //             const CardWidget(
                  //               number: "8278 3100 2002 6576",
                  //               startDate: "09 / 25",
                  //               name: "ANTONIO BANDERO",
                  //             ),
                  //           ],
                  //         ),
                  //         const NotificationPage()
                  //       ]),
                  //     )
                  //   ],
                  // ),
                  )
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopButton(),
                // !state.isChangeTabBar
                //     ? Expanded(
                //         child: Padding(
                //           padding: EdgeInsets.only(left: 10.w),
                //           child: CustomButton(
                //             background: Style.brandGreen,
                //             textColor: Style.black,
                //             title: AppHelpers.getTranslation(TrKeys.addNewCart),
                //             onPressed: () {
                //               AppHelpers.showCustomModalBottomSheet(
                //                 paddingTop: MediaQuery.of(context).padding.top,
                //                 context: context,
                //                 modal: const AddToScreen(),
                //                 isDarkMode: isDarkMode,
                //               );
                //             },
                //           ),
                //         ),
                //       )
                //     :
                SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
