import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dingtea/application/home/home_provider.dart';
import 'package:dingtea/infrastructure/models/data/story_data.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/components/loading.dart';
import 'package:dingtea/presentation/components/shop_avarat.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/app_style.dart';

@RoutePage()
class StoryListPage extends StatefulWidget {
  final RefreshController controller;
  final int index;

  const StoryListPage(
      {super.key, required this.index, required this.controller});

  @override
  State<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return PageView.builder(
        controller: pageController,
        itemCount: ref.watch(homeProvider).story?.length ?? 0,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) {
          return StoryPage(
            story: ref.watch(homeProvider).story?[index],
            nextPage: () {
              if (index == ref.watch(homeProvider).story!.length - 2) {
                ref
                    .read(homeProvider.notifier)
                    .fetchStorePage(context, widget.controller);
              }
              if (index != ref.watch(homeProvider).story!.length - 1) {
                pageController!.animateToPage(++index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
                setState(() {});
              } else {
                context.maybePop();
              }
            },
            prevPage: () {
              if (index != 0) {
                pageController!.animateToPage(--index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
                setState(() {});
              } else {
                context.maybePop();
              }
            },
          );
        },
      );
    });
  }
}

class StoryPage extends StatefulWidget {
  final List<StoryModel?>? story;
  final VoidCallback nextPage;
  final VoidCallback prevPage;

  const StoryPage(
      {super.key,
      required this.story,
      required this.nextPage,
      required this.prevPage});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with TickerProviderStateMixin {
  late AnimationController controller;
  final pageController = PageController(initialPage: 0);
  GlobalKey imageKey = GlobalKey();
  int currentIndex = 0;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..addListener(() {
        if (controller.status == AnimationStatus.completed) {
          if (currentIndex == widget.story!.length - 1) {
            widget.nextPage();
          } else {
            currentIndex++;
            controller.reset();
            controller.forward();
          }
        }
        setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.story?[currentIndex]?.url ?? "",
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          fit: BoxFit.cover,
          imageBuilder: (context, image) {
            return Stack(
              key: imageKey,
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: image, fit: BoxFit.fitWidth),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Container(
                      height: 4.h,
                      color: AppStyle.transparent,
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.story?.length ?? 0,
                          itemBuilder: (context, index) {
                            return AnimatedContainer(
                              margin: EdgeInsets.only(right: 8.w),
                              height: 4.h,
                              width: (MediaQuery.sizeOf(context).width -
                                      (36.w +
                                          ((widget.story!.length == 1
                                                  ? widget.story!.length
                                                  : (widget.story!.length -
                                                      1)) *
                                              8.w))) /
                                  widget.story!.length,
                              decoration: BoxDecoration(
                                color: currentIndex >= index
                                    ? AppStyle.primary
                                    : AppStyle.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(122.r)),
                              ),
                              duration: const Duration(milliseconds: 500),
                              child: currentIndex == index
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(122.r)),
                                      child: LinearProgressIndicator(
                                        value: controller.value,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                AppStyle.primary),
                                        backgroundColor: AppStyle.white,
                                      ),
                                    )
                                  : currentIndex > index
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(122.r)),
                                          child: const LinearProgressIndicator(
                                            value: 1,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppStyle.primary),
                                            backgroundColor: AppStyle.white,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            );
          },
          progressIndicatorBuilder: (context, url, progress) {
            return const Loading();
          },
          errorWidget: (context, url, error) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppStyle.textGrey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FlutterRemix.image_line,
                        color: AppStyle.white,
                        size: 32.r,
                      ),
                      8.verticalSpace,
                      Text(
                        AppHelpers.getTranslation(TrKeys.notFound),
                        style: AppStyle.interNormal(color: AppStyle.white),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Container(
                      height: 4.h,
                      color: AppStyle.transparent,
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.only(left: 20.w, top: 10.h),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.story?.length ?? 0,
                          itemBuilder: (context, index) {
                            return AnimatedContainer(
                              margin: EdgeInsets.only(right: 8.w),
                              height: 4.h,
                              width: (MediaQuery.sizeOf(context).width -
                                      (36.w +
                                          ((widget.story!.length == 1
                                                  ? widget.story!.length
                                                  : (widget.story!.length -
                                                      1)) *
                                              8.w))) /
                                  widget.story!.length,
                              decoration: BoxDecoration(
                                color: currentIndex >= index
                                    ? AppStyle.primary
                                    : AppStyle.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(122.r)),
                              ),
                              duration: const Duration(milliseconds: 500),
                              child: currentIndex == index
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(122.r)),
                                      child: LinearProgressIndicator(
                                        value: controller.value,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                AppStyle.primary),
                                        backgroundColor: AppStyle.white,
                                      ),
                                    )
                                  : currentIndex > index
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(122.r)),
                                          child: const LinearProgressIndicator(
                                            value: 1,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppStyle.primary),
                                            backgroundColor: AppStyle.white,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Row(
          children: [
            GestureDetector(
              onLongPressStart: (s) {
                controller.stop();
              },
              onLongPressEnd: (s) {
                controller.forward();
              },
              onTap: () {
                if (currentIndex != 0) {
                  currentIndex--;
                  controller.reset();
                  controller.forward();
                  setState(() {});
                } else {
                  widget.prevPage();
                }
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).height,
                color: AppStyle.transparent,
              ),
            ),
            GestureDetector(
              onLongPressStart: (s) {
                controller.stop();
              },
              onLongPressEnd: (s) {
                controller.forward();
              },
              onTap: () {
                if (currentIndex != widget.story!.length - 1) {
                  currentIndex++;
                  controller.reset();
                  controller.forward();
                  setState(() {});
                } else {
                  widget.nextPage();
                }
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).height,
                color: AppStyle.transparent,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushRoute(ShopRoute(
                          shopId:
                              (widget.story?.first?.shopId ?? 0).toString()));
                    },
                    child: Row(
                      children: [
                        6.horizontalSpace,
                        ShopAvatar(
                          shopImage: widget.story?.first?.logoImg ?? "",
                          size: 46.r,
                          padding: 5.r,
                          bgColor: AppStyle.tabBarBorderColor.withOpacity(0.6),
                        ),
                        6.horizontalSpace,
                        Text(
                          widget.story?.first?.title ?? "",
                          style: AppStyle.interNormal(
                              size: 14.sp, color: AppStyle.white),
                        ),
                        6.horizontalSpace,
                        Text(
                          Jiffy.parseFromDateTime(
                                  widget.story?[currentIndex]?.createdAt ??
                                      DateTime.now())
                              .fromNow(),
                          style: AppStyle.interNormal(
                              size: 10.sp, color: AppStyle.white),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.maybePop();
                    },
                    child: Container(
                      color: AppStyle.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 8.r, bottom: 8.r, left: 8.r, right: 4.r),
                        child: const Icon(
                          Icons.close,
                          color: AppStyle.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 32.h),
              child: CustomButton(
                title: AppHelpers.getTranslation(TrKeys.placeOrder),
                onPressed: () {
                  context.pushRoute(ShopRoute(
                      shopId:
                          (widget.story?[currentIndex]?.shopId ?? 0).toString(),
                      productId:
                          widget.story?[currentIndex]?.productUuid ?? ""));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
