import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:dingtea/app_constants.dart';
import 'package:dingtea/application/map/view_map_provider.dart';
import 'package:dingtea/application/map/view_map_state.dart';
import 'package:dingtea/application/order/order_notifier.dart';
import 'package:dingtea/application/order/order_provider.dart';
import 'package:dingtea/application/order/order_state.dart';
import 'package:dingtea/application/orders_list/orders_list_notifier.dart';
import 'package:dingtea/application/orders_list/orders_list_provider.dart';
import 'package:dingtea/application/payment_methods/payment_provider.dart';
import 'package:dingtea/application/payment_methods/payment_state.dart';
import 'package:dingtea/application/profile/profile_provider.dart';
import 'package:dingtea/application/profile/profile_state.dart';
import 'package:dingtea/application/shop_order/shop_order_notifier.dart';
import 'package:dingtea/application/shop_order/shop_order_provider.dart';
import 'package:dingtea/application/shop_order/shop_order_state.dart';
import 'package:dingtea/infrastructure/models/data/order_body_data.dart';
import 'package:dingtea/infrastructure/models/data/shop_data.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/enums.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/components/web_view.dart';
import 'package:dingtea/presentation/pages/order/order_check/price_information.dart';
import 'package:dingtea/presentation/pages/order/order_check/widgets/auto_order_modal.dart';
import 'package:dingtea/presentation/pages/order/order_screen/widgets/image_dialog.dart';
import 'package:dingtea/presentation/pages/profile/phone_verify.dart';
import 'package:dingtea/presentation/routes/app_router.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/card_and_promo.dart';
import 'widgets/delivery_info.dart';
import 'widgets/order_button.dart';
import 'widgets/order_info.dart';

class OrderCheck extends StatefulWidget {
  final bool isActive;
  final bool isOrder;
  final GlobalKey<ScaffoldState>? globalKey;

  final OrderStatus orderStatus;
  final ConfettiController? controllerCenter;

  const OrderCheck({
    super.key,
    required this.isActive,
    required this.isOrder,
    required this.orderStatus,
    this.globalKey,
    this.controllerCenter,
  });

  @override
  State<OrderCheck> createState() => _OrderCheckState();
}

class _OrderCheckState extends State<OrderCheck> {
  _createOrder(
      {required OrderState state,
      required OrderNotifier event,
      required ShopOrderState stateOrderShop,
      required ShopOrderNotifier eventShopOrder,
      required ViewMapState stateMap,
      required PaymentState paymentState,
      required ProfileState stateProfile,
      required OrdersListNotifier eventOrderList}) {
    if ((state.shopData?.minAmount ?? 0) > (state.calculateData?.price ?? 0)) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        "${AppHelpers.getTranslation(TrKeys.yourOrderDidNotReachMinAmountMinAmountIs)} ${AppHelpers.numberFormat(number: (state.shopData?.minAmount ?? 0))}",
      );
      return;
    }
    if (state.sendOtherUser &&
        (state.username?.isEmpty ?? true) &&
        (state.phoneNumber?.isEmpty ?? true) &&
        state.tabIndex == 0) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.youWritePhoneAndFirstname),
      );
      return;
    }
    if (!((AppHelpers.getPaymentType() == "admin")
        ? (paymentState.payments.isNotEmpty)
        : (state.shopData?.shopPayments?.isNotEmpty ?? false))) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.youCantCreateOrder),
      );
    } else if (state.selectDate == null) {
      AppHelpers.showCheckTopSnackBarInfo(
        context,
        AppHelpers.getTranslation(TrKeys.notWorkTodayAndTomorrow),
      );
    } else {
      if ((LocalStorage.getUser()?.phone == null ||
              (LocalStorage.getUser()?.phone?.isEmpty ?? true)) &&
          AppHelpers.getPhoneRequired()) {
        AppHelpers.showCustomModalBottomSheet(
            context: context,
            modal: const PhoneVerify(),
            isDarkMode: false,
            paddingTop: MediaQuery.of(context).padding.top);
        return;
      }
      event.createOrder(
          context: context,
          data: OrderBodyData(
              paymentId: ((AppHelpers.getPaymentType() == "admin")
                  ? (paymentState.payments[paymentState.currentIndex].id)
                  : state.shopData?.shopPayments?[paymentState.currentIndex]
                      ?.payment?.id),
              username: state.username,
              phone: state.phoneNumber ?? LocalStorage.getUser()?.phone,
              notes: state.notes,
              cartId: stateOrderShop.cart?.id ?? 0,
              shopId: state.shopData?.id ?? 0,
              coupon: state.promoCode,
              deliveryFee: state.calculateData?.deliveryFee ?? 0,
              deliveryType: state.tabIndex == 0
                  ? DeliveryTypeEnum.delivery
                  : DeliveryTypeEnum.pickup,
              location: Location(
                  longitude: stateMap.place?.location?.last ??
                      LocalStorage.getAddressSelected()?.location?.longitude ??
                      AppConstants.demoLongitude,
                  latitude: stateMap.place?.location?.first ??
                      LocalStorage.getAddressSelected()?.location?.latitude ??
                      AppConstants.demoLatitude),
              address: AddressModel(
                address: LocalStorage.getAddressSelected()?.address ?? "",
                house: state.house,
                floor: state.floor,
                office: state.office,
              ),
              note: state.note,
              deliveryDate:
                  "${state.selectDate?.year ?? 0}-${(state.selectDate?.month ?? 0).toString().padLeft(2, '0')}-${(state.selectDate?.day ?? 0).toString().padLeft(2, '0')}",
              deliveryTime: state.selectTime.hour.toString().length == 2
                  ? "${state.selectTime.hour}:${state.selectTime.minute.toString().padLeft(2, '0')}"
                  : "0${state.selectTime.hour}:${state.selectTime.minute.toString().padLeft(2, '0')}"),
          payment: ((AppHelpers.getPaymentType() == "admin")
              ? (paymentState.payments[paymentState.currentIndex])
              : state
                  .shopData?.shopPayments?[paymentState.currentIndex]?.payment),
          onSuccess: () {
            widget.controllerCenter?.play();
            eventShopOrder.getCart(context, () {});
            eventOrderList.fetchActiveOrders(context);
          },
          onWebview: (s, v) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WebViewPage(url: s)),
            ).whenComplete(() {});
          });
    }
  }

  _checkShopOrder() {
    AppHelpers.showAlertDialog(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.allPreviouslyAdded),
              style: AppStyle.interNormal(),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      title: AppHelpers.getTranslation(TrKeys.cancel),
                      background: AppStyle.transparent,
                      borderColor: AppStyle.borderColor,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                10.horizontalSpace,
                Expanded(child: Consumer(builder: (contextTwo, ref, child) {
                  return CustomButton(
                      isLoading: ref.watch(shopOrderProvider).isDeleteLoading,
                      title: AppHelpers.getTranslation(TrKeys.clearAll),
                      onPressed: () {
                        ref
                            .read(shopOrderProvider.notifier)
                            .deleteCart(context);
                        ref.read(orderProvider.notifier).repeatOrder(
                              context: context,
                              shopId: 0,
                              listOfProduct:
                                  ref.watch(orderProvider).orderData?.details ??
                                      [],
                              onSuccess: () {
                                ref
                                    .read(shopOrderProvider.notifier)
                                    .getCart(context, () {
                                  context.maybePop();
                                  context.pushRoute(const OrderRoute());
                                });
                              },
                            );
                      });
                })),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Consumer(builder: (context, ref, child) {
        final state = ref.watch(orderProvider);
        final event = ref.read(orderProvider.notifier);
        ref.listen(orderProvider, (previous, next) {
          if (next.isCheckShopOrder &&
              (next.isCheckShopOrder !=
                  (previous?.isCheckShopOrder ?? false))) {
            _checkShopOrder();
          }
        });
        num subTotal = 0;
        state.orderData?.details?.forEach((element) {
          subTotal = subTotal + (element.totalPrice ?? 0);
        });
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isOrder ? const OrderInfo() : const CardAndPromo(),
            PriceInformation(isOrder: widget.isOrder, state: state),
            const DeliveryInfo(),
            26.verticalSpace,
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                  right: 16.w,
                  left: 16.w),
              child: OrderButton(
                autoOrder: () {
                  AppHelpers.showCustomModalBottomSheet(
                      context: context,
                      modal: AutoOrderModal(
                        repeatData: state.orderData?.repeat,
                        orderId: state.orderData?.id ?? 0,
                        time: DateFormat("HH:MM").format(
                            state.orderData?.createdAt ?? DateTime.now()),
                      ),
                      isDarkMode: false);
                },
                isRepeatLoading: state.isAddLoading,
                isLoading: ref.watch(shopOrderProvider).isAddAndRemoveLoading ||
                    state.isButtonLoading,
                isOrder: widget.isOrder,
                orderStatus: widget.orderStatus,
                createOrder: () => _createOrder(
                  state: state,
                  stateMap: ref.watch(viewMapProvider),
                  stateOrderShop: ref.watch(shopOrderProvider),
                  event: event,
                  eventShopOrder: ref.read(shopOrderProvider.notifier),
                  paymentState: ref.watch(paymentProvider),
                  stateProfile: ref.watch(profileProvider),
                  eventOrderList: ref.read(ordersListProvider.notifier),
                ),
                cancelOrder: () {
                  event.cancelOrder(context, state.orderData?.id ?? 0, () {
                    ref
                        .read(ordersListProvider.notifier)
                        .fetchActiveOrders(context);
                    ref
                        .read(ordersListProvider.notifier)
                        .fetchHistoryOrders(context);
                    ref
                        .read(ordersListProvider.notifier)
                        .fetchRefundOrders(context);
                  });
                },
                callShop: () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: state.orderData?.shop?.phone ?? "",
                  );
                  await launchUrl(launchUri);
                },
                callDriver: () async {
                  if (state.orderData?.deliveryMan != null) {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: state.orderData?.deliveryMan?.phone ?? "",
                    );
                    await launchUrl(launchUri);
                  } else {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.noDriver),
                    );
                  }
                },
                sendSmsDriver: () async {
                  if (state.orderData?.deliveryMan != null) {
                    final Uri launchUri = Uri(
                      scheme: 'sms',
                      path: state.orderData?.deliveryMan?.phone ?? "",
                    );
                    await launchUrl(launchUri);
                  } else {
                    AppHelpers.showCheckTopSnackBarInfo(
                      context,
                      AppHelpers.getTranslation(TrKeys.noDriver),
                    );
                  }
                },
                isRefund: (state.orderData?.refunds?.isEmpty ?? true) ||
                    state.orderData?.refunds?.last.status == "canceled",
                repeatOrder: () {
                  event.repeatOrder(
                    context: context,
                    shopId: ref.watch(shopOrderProvider).cart?.shopId ?? 0,
                    listOfProduct: state.orderData?.details ?? [],
                    onSuccess: () {
                      ref.read(shopOrderProvider.notifier).getCart(context, () {
                        context.maybePop();
                        context.pushRoute(const OrderRoute());
                      });
                    },
                  );
                },
                showImage: state.orderData?.afterDeliveredImage != null
                    ? () {
                        AppHelpers.showAlertDialog(
                          context: context,
                          child: ImageDialog(
                            img: state.orderData?.afterDeliveredImage,
                          ),
                        );
                      }
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }
}
