import 'package:dingtea/application/home/home_notifier.dart';
import 'package:dingtea/application/home/home_state.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/animation_button_effect.dart';
import 'package:dingtea/presentation/components/loading.dart';
import 'package:dingtea/presentation/components/title_icon.dart';
import 'package:dingtea/presentation/pages/home/filter/filter_page.dart';
import 'package:dingtea/presentation/pages/home/home_three/widgets/market_three_item.dart';
import 'package:dingtea/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'shimmer/news_shop_shimmer.dart';
import 'widgets/tab_bar_item_three.dart';

class FilterCategoryShopThree extends StatelessWidget {
  final HomeState state;
  final HomeNotifier event;
  final RefreshController shopController;

  const FilterCategoryShopThree(
      {super.key,
      required this.state,
      required this.event,
      required this.shopController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 46.r,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 8.r, left: 16.r),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount:
                (state.categories[state.selectIndexCategory].children?.length ??
                        0) +
                    1,
            itemBuilder: (BuildContext context, int index) {
              final category = state.categories[state.selectIndexCategory];
              return index == 0
                  ? AnimationButtonEffect(
                      child: InkWell(
                        onTap: () {
                          AppHelpers.showCustomModalBottomDragSheet(
                            context: context,
                            modal: (c) => FilterPage(
                              controller: c,
                              categoryId: (state.selectIndexSubCategory != -1
                                      ? (state
                                          .categories[state.selectIndexCategory]
                                          .children?[
                                              state.selectIndexSubCategory]
                                          .id)
                                      : state
                                          .categories[state.selectIndexCategory]
                                          .id) ??
                                  0,
                            ),
                            isDarkMode: false,
                            isDrag: false,
                            radius: 12,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8.r),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.r, vertical: 6.r),
                          decoration: BoxDecoration(
                            color: AppStyle.bgGrey,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/filter.svg"),
                              6.horizontalSpace,
                              Text(
                                AppHelpers.getTranslation(TrKeys.filter),
                                style: AppStyle.interNormal(
                                  size: 13,
                                  color: AppStyle.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : TabBarItemThree(
                      isShopTabBar: index - 1 == state.selectIndexSubCategory,
                      title: category.children?[index - 1].translation?.title ??
                          "",
                      index: index - 1,
                      currentIndex: state.selectIndexSubCategory,
                      onTap: () =>
                          event.setSelectSubCategory(index - 1, context),
                    );
            },
          ),
        ),
        state.isSelectCategoryLoading == -1
            ? const Loading()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state.isShopLoading
                      ? NewsShopShimmer(
                          title: AppHelpers.getTranslation(TrKeys.shops),
                        )
                      : state.filterMarket.isNotEmpty
                          ? Column(
                              children: [
                                TitleAndIcon(
                                  title:
                                      AppHelpers.getTranslation(TrKeys.shops),
                                  rightTitle:
                                      "${AppHelpers.getTranslation(TrKeys.found)} ${state.totalShops} ${AppHelpers.getTranslation(TrKeys.results)}",
                                ),
                                12.verticalSpace,
                                SizedBox(
                                    height: 246.h,
                                    child: SmartRefresher(
                                      scrollDirection: Axis.horizontal,
                                      controller: shopController,
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      onLoading: () async {},
                                      child: ListView.builder(
                                        padding: EdgeInsets.only(left: 16.r),
                                        shrinkWrap: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.filterMarket.length,
                                        itemBuilder: (context, index) =>
                                            MarketThreeItem(
                                          shop: state.filterMarket[index],
                                        ),
                                      ),
                                    )),
                                16.verticalSpace,
                              ],
                            )
                          : const SizedBox.shrink(),
                  TitleAndIcon(
                    title: AppHelpers.getTranslation(TrKeys.restaurants),
                    rightTitle:
                        "${AppHelpers.getTranslation(TrKeys.found)} ${state.filterShops.length.toString()} ${AppHelpers.getTranslation(TrKeys.results)}",
                  ),
                  state.filterShops.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.only(top: 6.h),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: state.filterShops.length,
                          itemBuilder: (context, index) => MarketThreeItem(
                            shop: state.filterShops[index],
                            isSimpleShop: true,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Center(child: _resultEmpty()),
                        ),
                ],
              ),
      ],
    );
  }
}

Widget _resultEmpty() {
  return Column(
    children: [
      Image.asset("assets/images/notFound.png"),
      Text(
        AppHelpers.getTranslation(TrKeys.nothingFound),
        style: AppStyle.interSemi(size: 18.sp),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
        ),
        child: Text(
          AppHelpers.getTranslation(TrKeys.trySearchingAgain),
          style: AppStyle.interRegular(size: 14.sp),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
