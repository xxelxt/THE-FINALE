import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dingtea/app_constants.dart';
import 'package:dingtea/application/profile/profile_notifier.dart';
import 'package:dingtea/application/profile/profile_provider.dart';
import 'package:dingtea/application/profile/profile_state.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/img_service.dart';
import 'package:dingtea/infrastructure/services/input_formatter.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/app_bars/common_app_bar.dart';
import 'package:dingtea/presentation/components/blur_wrap.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/components/buttons/pop_button.dart';
import 'package:dingtea/presentation/components/keyboard_dismisser.dart';
import 'package:dingtea/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class CreateShopPage extends ConsumerStatefulWidget {
  const CreateShopPage({super.key});

  @override
  ConsumerState<CreateShopPage> createState() => _EditRestaurantState();
}

class _EditRestaurantState extends ConsumerState<CreateShopPage> {
  late ProfileNotifier event;
  late TextEditingController shopName;
  late TextEditingController descName;
  late TextEditingController phoneName;
  late TextEditingController tax;
  late TextEditingController deliveryTimeFrom;
  late TextEditingController deliveryTimeTo;
  late TextEditingController startPrice;
  late TextEditingController pricePerKm;
  dynamic data;

  List list = ["minute", "day", "month"];

  String value = "minute";

  @override
  void initState() {
    shopName = TextEditingController();
    descName = TextEditingController();
    phoneName = TextEditingController();
    deliveryTimeFrom = TextEditingController();
    deliveryTimeTo = TextEditingController();
    startPrice = TextEditingController();
    pricePerKm = TextEditingController();
    tax = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).resetShopData();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(profileProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    shopName.dispose();
    descName.dispose();
    phoneName.dispose();
    deliveryTimeFrom.dispose();
    deliveryTimeTo.dispose();
    startPrice.dispose();
    pricePerKm.dispose();
    tax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return KeyboardDismisser(
      child: Scaffold(
        body: Column(
          children: [
            CommonAppBar(
              child: Text(
                AppHelpers.getTranslation(TrKeys.becomeSeller),
                style: AppStyle.interNoSemi(
                  size: 18,
                  color: AppStyle.black,
                ),
              ),
            ),
            16.verticalSpace,
            state.userData?.shop == null
                ? Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          16.verticalSpace,
                          Expanded(
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: [
                                Column(
                                  children: [
                                    _setBgImage(state),
                                    24.verticalSpace,
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await ImgService.getPhotoGallery(
                                                event.setLogoImage);
                                          },
                                          child: Container(
                                            width: 50.r,
                                            height: 50.r,
                                            padding: EdgeInsets.all(6.r),
                                            decoration: state
                                                    .logoImage.isNotEmpty
                                                ? BoxDecoration(
                                                    color: AppStyle.black
                                                        .withOpacity(0.27),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.r),
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                          File(state.logoImage),
                                                        ),
                                                        fit: BoxFit.cover),
                                                  )
                                                : BoxDecoration(
                                                    color: AppStyle.black
                                                        .withOpacity(0.27),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.r),
                                                  ),
                                            child: const Center(
                                              child: Icon(
                                                FlutterRemix.camera_fill,
                                                color: AppStyle.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        16.horizontalSpace,
                                        Expanded(
                                          child: OutlinedBorderTextField(
                                            textController: shopName,
                                            label: AppHelpers.getTranslation(
                                                TrKeys.restaurantName),
                                          ),
                                        ),
                                      ],
                                    ),
                                    24.verticalSpace,
                                    OutlinedBorderTextField(
                                      textController: descName,
                                      label: AppHelpers.getTranslation(
                                          TrKeys.description),
                                    ),
                                    24.verticalSpace,
                                    OutlinedBorderTextField(
                                      textController: phoneName,
                                      inputType: TextInputType.phone,
                                      label: AppHelpers.getTranslation(
                                          TrKeys.phoneNumber),
                                    ),
                                    24.verticalSpace,
                                    OutlinedBorderTextField(
                                      textController: tax,
                                      inputType: TextInputType.number,
                                      label:
                                          AppHelpers.getTranslation(TrKeys.tax),
                                      inputFormatters: [
                                        InputFormatter.currency
                                      ],
                                    ),
                                    24.verticalSpace,
                                    DropdownButtonFormField(
                                      value: value,
                                      items: list
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (s) {
                                        if (s != null) {
                                          value = s.toString();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: AppHelpers.getTranslation(
                                            TrKeys.deliveryTimeType),
                                        labelStyle: AppStyle.interNormal(
                                          size: 12,
                                          color: AppStyle.black,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.merge(
                                                const BorderSide(
                                                    color: AppStyle
                                                        .differBorderColor),
                                                const BorderSide(
                                                    color: AppStyle
                                                        .differBorderColor))),
                                        errorBorder: InputBorder.none,
                                        border: const UnderlineInputBorder(),
                                        focusedErrorBorder:
                                            const UnderlineInputBorder(),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.merge(
                                                const BorderSide(
                                                    color: AppStyle
                                                        .differBorderColor),
                                                const BorderSide(
                                                    color: AppStyle
                                                        .differBorderColor))),
                                        focusedBorder:
                                            const UnderlineInputBorder(),
                                      ),
                                    ),
                                    24.verticalSpace,
                                    OutlinedBorderTextField(
                                      textController: deliveryTimeFrom,
                                      inputType: TextInputType.number,
                                      label: AppHelpers.getTranslation(
                                          TrKeys.deliveryTimeFrom),
                                      inputFormatters: [
                                        InputFormatter.digitsOnly
                                      ],
                                    ),
                                    24.verticalSpace,
                                    OutlinedBorderTextField(
                                      inputType: TextInputType.number,
                                      textController: deliveryTimeTo,
                                      label: AppHelpers.getTranslation(
                                          TrKeys.deliveryTimeTo),
                                      inputFormatters: [
                                        InputFormatter.digitsOnly
                                      ],
                                    ),
                                    24.verticalSpace,
                                    OutlinedBorderTextField(
                                      textController: startPrice,
                                      inputType: TextInputType.number,
                                      label: AppHelpers.getTranslation(
                                          TrKeys.startPrice),
                                      inputFormatters: [
                                        InputFormatter.currency
                                      ],
                                    ),
                                    24.verticalSpace,
                                    OutlinedBorderTextField(
                                      inputType: TextInputType.number,
                                      textController: pricePerKm,
                                      label: AppHelpers.getTranslation(
                                          TrKeys.pricePerKm),
                                      inputFormatters: [
                                        InputFormatter.currency
                                      ],
                                    ),
                                  ],
                                ),
                                24.verticalSpace,
                                _setDoc(state),
                                24.verticalSpace,
                                const Divider(),
                                GestureDetector(
                                  onTap: () async {
                                    data = await context.pushRoute(ViewMapRoute(
                                        isShopLocation: true, isParcel: true));
                                    event.setAddress(data);
                                  },
                                  child: Container(
                                    color: AppStyle.transparent,
                                    child: Padding(
                                      padding: EdgeInsets.all(16.r),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FlutterRemix.navigation_fill,
                                            size: 20.r,
                                          ),
                                          8.horizontalSpace,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppHelpers.getTranslation(
                                                    TrKeys.address),
                                                style: AppStyle.interNormal(
                                                    size: 12.sp,
                                                    color: AppStyle.black),
                                              ),
                                              SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width /
                                                        2,
                                                child: Text(
                                                  "${state.addressModel?.title ?? ""}, ${state.addressModel?.address?.address ?? ""}",
                                                  style: AppStyle.interNormal(
                                                      size: 12.sp,
                                                      color: AppStyle.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            FlutterRemix.arrow_right_s_line,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(),
                                24.verticalSpace,
                                Padding(
                                  padding: EdgeInsets.only(bottom: 32.h),
                                  child: CustomButton(
                                    isLoading: state.isSaveLoading,
                                    title:
                                        AppHelpers.getTranslation(TrKeys.save),
                                    onPressed: () {
                                      event.createShop(
                                          context: context,
                                          tax: tax.text,
                                          deliveryTo: deliveryTimeTo.text,
                                          deliveryFrom: deliveryTimeFrom.text,
                                          phone: phoneName.text,
                                          startPrice: startPrice.text,
                                          name: shopName.text,
                                          desc: descName.text,
                                          perKm: pricePerKm.text,
                                          address: data,
                                          deliveryType: value,
                                          categoryId: 0);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : state.userData?.shop?.status == "new"
                    ? Column(
                        children: [
                          Lottie.asset('assets/lottie/processing.json'),
                          Text(
                            AppHelpers.getTranslation(
                              TrKeys.yourRequest,
                            ),
                            style: AppStyle.interNoSemi(
                              size: 18,
                              color: AppStyle.black,
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.all(24.r),
                        child: CustomButton(
                            title: AppHelpers.getTranslation(
                                TrKeys.goToAdminPanel),
                            onPressed: () async {
                              final Uri launchUri =
                                  Uri.parse(AppConstants.adminPageUrl);
                              await launchUrl(launchUri);
                            }),
                      ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const PopButton(),
          ),
        ),
      ),
    );
  }

  Container _setBgImage(ProfileState state) {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: state.bgImage.isNotEmpty
          ? Stack(
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.file(
                      File(state.bgImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 16.w,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await ImgService.getPhotoGallery(event.setBgImage);
                        },
                        child: BlurWrap(
                          radius: BorderRadius.circular(20.r),
                          child: Container(
                            height: 40.r,
                            width: 40.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppStyle.white.withOpacity(0.15),
                            ),
                            child: const Icon(
                              FlutterRemix.image_add_fill,
                              color: AppStyle.white,
                            ),
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      InkWell(
                        onTap: () {
                          event.setBgImage("");
                        },
                        child: BlurWrap(
                          radius: BorderRadius.circular(20.r),
                          child: Container(
                            height: 40.r,
                            width: 40.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppStyle.white.withOpacity(0.15),
                            ),
                            child: const Icon(
                              FlutterRemix.delete_bin_fill,
                              color: AppStyle.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: () async {
                await ImgService.getPhotoGallery(event.setBgImage);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FlutterRemix.upload_cloud_2_line,
                    size: 42.r,
                    color: AppStyle.primary,
                  ),
                  16.verticalSpace,
                  Text(
                    AppHelpers.getTranslation(TrKeys.bgPicture),
                    style: AppStyle.interSemi(
                      size: 14,
                      color: AppStyle.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    AppHelpers.getTranslation(TrKeys.recommendedSize),
                    style: AppStyle.interRegular(
                      size: 14,
                      color: AppStyle.black,
                      letterSpacing: -0.3,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  _setDoc(ProfileState state) {
    return Column(
      children: [
        Container(
          height: 80.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            onTap: () async => await ImgService.getFilePdf(event.setFile),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FlutterRemix.file_pdf_line,
                  size: 42.r,
                  color: AppStyle.primary,
                ),
                16.verticalSpace,
                Text(
                  AppHelpers.getTranslation(TrKeys.uploadDocuments),
                  style: AppStyle.interNoSemi(
                    size: 14,
                    color: AppStyle.black,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        4.verticalSpace,
        ...state.filepath.map(
          (e) => Container(
            decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
            padding: REdgeInsets.symmetric(horizontal: 6, vertical: 6),
            margin: REdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e,
                    style: AppStyle.interRegular(size: 12.sp),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    event.deleteFile(e);
                  },
                  icon: Icon(
                    FlutterRemix.close_circle_line,
                    size: 21.r,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
