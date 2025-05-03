import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dingtea/application/help/help_provider.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/components/loading.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/app_bars/common_app_bar.dart';
import 'package:dingtea/presentation/components/buttons/pop_button.dart';
import 'package:dingtea/presentation/theme/app_style.dart';

@RoutePage()
class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> {
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(helpProvider.notifier).fetchHelp(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(helpProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: state.isLoading
            ? const Loading()
            : Column(
                children: [
                  CommonAppBar(
                    child: Text(
                      AppHelpers.getTranslation(TrKeys.help),
                      style: AppStyle.interNoSemi(
                        size: 18,
                        color: AppStyle.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            top: 24.h,
                            right: 16.w,
                            left: 16.w,
                            bottom:
                                MediaQuery.of(context).padding.bottom + 72.h),
                        itemCount: (state.data?.data?.length ?? 0) + 1,
                        itemBuilder: (context, index) {
                          return index != state.data?.data?.length
                              ? GestureDetector(
                                  onTap: () {
                                    AppHelpers.showCustomModalBottomSheet(
                                        context: context,
                                        modal: Container(
                                          decoration: BoxDecoration(
                                              color: AppStyle.bgGrey
                                                  .withOpacity(0.96),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16.r),
                                                topRight: Radius.circular(16.r),
                                              )),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24.w),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                8.verticalSpace,
                                                Center(
                                                  child: Container(
                                                    height: 4.h,
                                                    width: 48.w,
                                                    decoration: BoxDecoration(
                                                        color: AppStyle
                                                            .dragElement,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    40.r))),
                                                  ),
                                                ),
                                                18.verticalSpace,
                                                Text(
                                                  state
                                                          .data
                                                          ?.data?[index]
                                                          .translation
                                                          ?.question ??
                                                      "",
                                                  style: AppStyle.interSemi(
                                                      size: 18.sp),
                                                ),
                                                14.verticalSpace,
                                                Text(
                                                  state
                                                          .data
                                                          ?.data?[index]
                                                          .translation
                                                          ?.answer ??
                                                      "",
                                                  style: AppStyle.interRegular(
                                                      size: 14.sp,
                                                      color: AppStyle.textGrey),
                                                ),
                                                24.verticalSpace
                                              ],
                                            ),
                                          ),
                                        ),
                                        isDarkMode: false);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    padding: EdgeInsets.all(16.r),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: AppStyle.white,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              state.data?.data?[index]
                                                      .translation?.question ??
                                                  "",
                                              style: AppStyle.interNormal(
                                                  size: 16.sp),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_right,
                                              color: AppStyle.textGrey,
                                            )
                                          ],
                                        ),
                                        10.verticalSpace,
                                        Text(
                                          state.data?.data?[index].translation
                                                  ?.answer ??
                                              "",
                                          style: AppStyle.interRegular(
                                              size: 12.sp,
                                              color: AppStyle.textGrey),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 16.h),
                                  padding: EdgeInsets.all(16.r),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppStyle.transparent,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border:
                                          Border.all(color: AppStyle.textGrey)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svgs/contact.svg"),
                                      20.horizontalSpace,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppHelpers.getTranslation(
                                                TrKeys.stillHaveQuestions),
                                            style:
                                                AppStyle.interSemi(size: 14.sp),
                                          ),
                                          10.verticalSpace,
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                1.5,
                                            child: Text(
                                              AppHelpers.getTranslation(
                                                  TrKeys.cantFindTheAnswer),
                                              style: AppStyle.interRegular(
                                                  size: 12.sp),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                        }),
                  ),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              const PopButton(),
              10.horizontalSpace,
              Expanded(
                  child: CustomButton(
                background: AppStyle.black,
                textColor: AppStyle.white,
                title: AppHelpers.getTranslation(TrKeys.callToSupport),
                onPressed: () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: AppHelpers.getAppPhone(),
                  );
                  await launchUrl(launchUri);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
