// ignore_for_file: unused_result

import 'package:auto_route/auto_route.dart';
import 'package:dingtea/application/auth/auth.dart';
import 'package:dingtea/application/edit_profile/edit_profile_provider.dart';
import 'package:dingtea/application/profile/profile_provider.dart';
import 'package:dingtea/infrastructure/models/data/user.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/app_bars/app_bar_bottom_sheet.dart';
import 'package:dingtea/presentation/components/buttons/custom_button.dart';
import 'package:dingtea/presentation/components/keyboard_dismisser.dart';
import 'package:dingtea/presentation/pages/auth/reset/set_password_page.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../register/register_page.dart';

@RoutePage()
class RegisterConfirmationPage extends ConsumerStatefulWidget {
  final UserModel userModel;
  final bool isResetPassword;
  final String verificationId;
  final bool editPhone;

  const RegisterConfirmationPage({
    super.key,
    required this.userModel,
    this.isResetPassword = false,
    required this.verificationId,
    this.editPhone = false,
  });

  @override
  ConsumerState<RegisterConfirmationPage> createState() =>
      _RegisterConfirmationPageState();
}

class _RegisterConfirmationPageState
    extends ConsumerState<RegisterConfirmationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(registerConfirmationProvider);
      ref.read(registerConfirmationProvider.notifier).startTimer();
    });
  }

  @override
  void deactivate() {
    ref.read(registerConfirmationProvider.notifier).disposeTimer();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(registerConfirmationProvider.notifier);
    final state = ref.watch(registerConfirmationProvider);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    ref.listen(registerConfirmationProvider, (previous, next) {
      if (previous!.isSuccess != next.isSuccess && next.isSuccess) {
        Navigator.pop(context);
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: RegisterPage(
            isOnlyEmail: false,
          ),
          isDarkMode: isDarkMode,
        );
      }
      if (previous.isResetPasswordSuccess != next.isResetPasswordSuccess &&
          next.isResetPasswordSuccess) {
        Navigator.pop(context);
        AppHelpers.showCustomModalBottomSheet(
          context: context,
          modal: const SetPasswordPage(),
          isDarkMode: isDarkMode,
        );
      }
    });
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: AbsorbPointer(
        absorbing: state.isLoading || state.isResending,
        child: KeyboardDismisser(
          child: Container(
            margin: MediaQuery.of(context).viewInsets,
            decoration: BoxDecoration(
                color: AppStyle.bgGrey.withOpacity(0.96),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                )),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        AppBarBottomSheet(
                          title: AppHelpers.getTranslation(TrKeys.enterOtp),
                        ),
                        Text(
                          AppHelpers.getTranslation(TrKeys.sendOtp),
                          style: AppStyle.interRegular(
                            size: 14,
                            color: AppStyle.black,
                          ),
                        ),
                        Text(
                          widget.userModel.email ?? "",
                          style: AppStyle.interRegular(
                            size: 14,
                            color: AppStyle.black,
                          ),
                        ),
                        40.verticalSpace,
                        SizedBox(
                          height: 64,
                          child: PinFieldAutoFill(
                            codeLength: 6,
                            currentCode: state.confirmCode,
                            onCodeChanged: notifier.setCode,
                            cursor: Cursor(
                              width: 1,
                              height: 24,
                              color:
                                  isDarkMode ? AppStyle.white : AppStyle.black,
                              enabled: true,
                            ),
                            decoration: BoxLooseDecoration(
                              gapSpace: 10.r,
                              textStyle: AppStyle.interNormal(
                                size: 15.sp,
                                color: isDarkMode
                                    ? AppStyle.white
                                    : AppStyle.black,
                              ),
                              bgColorBuilder: FixedColorBuilder(
                                isDarkMode
                                    ? AppStyle.mainBackDark
                                    : AppStyle.transparent,
                              ),
                              strokeColorBuilder: FixedColorBuilder(
                                state.isCodeError
                                    ? AppStyle.red
                                    : isDarkMode
                                        ? AppStyle.borderDark
                                        : AppStyle.outlineButtonBorder,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                          top: 120.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            isLoading: state.isResending,
                            title: state.isTimeExpired
                                ? AppHelpers.getTranslation(TrKeys.resendOtp)
                                : state.timerText,
                            onPressed: () {
                              if (state.isTimeExpired) {
                                if (widget.isResetPassword) {
                                  widget.verificationId.isEmpty
                                      ? notifier.resendConfirmation(
                                          context, widget.userModel.email ?? "",
                                          isResetPassword:
                                              widget.isResetPassword)
                                      : notifier.resendResetConfirmation(
                                          context,
                                          widget.userModel.email ?? "",
                                        );
                                  return;
                                } else {
                                  widget.verificationId.isEmpty
                                      ? notifier.resendConfirmation(
                                          context, widget.userModel.email ?? "",
                                          isResetPassword:
                                              widget.isResetPassword)
                                      : notifier.sendCodeToNumber(
                                          context,
                                          widget.userModel.email ?? "",
                                        );
                                }
                                notifier.startTimer();
                              }
                            },
                            weight: (MediaQuery.sizeOf(context).width - 40) / 3,
                            background: AppStyle.black,
                            textColor: AppStyle.white,
                          ),
                          CustomButton(
                            isLoading: state.isLoading,
                            title:
                                AppHelpers.getTranslation(TrKeys.confirmation),
                            onPressed: () {
                              if (state.confirmCode.length == 6) {
                                if (widget.isResetPassword) {
                                  widget.verificationId.isEmpty
                                      ? notifier.confirmCodeResetPassword(
                                          context, widget.userModel.email ?? "")
                                      : notifier
                                          .confirmCodeResetPasswordWithPhone(
                                              context,
                                              widget.userModel.email ?? "",
                                              widget.verificationId);
                                } else {
                                  widget.verificationId.isEmpty
                                      ? notifier.confirmCode(context)
                                      : notifier.confirmCodeWithPhone(
                                          context: context,
                                          verificationId: widget.verificationId,
                                          onSuccess: widget.editPhone
                                              ? () {
                                                  if (widget.editPhone) {
                                                    ref
                                                        .read(
                                                            editProfileProvider
                                                                .notifier)
                                                        .editProfile(
                                                            context,
                                                            ProfileData(
                                                                phone: widget
                                                                    .userModel
                                                                    .email,
                                                                firstname: ref
                                                                        .watch(
                                                                            profileProvider)
                                                                        .userData
                                                                        ?.firstname ??
                                                                    ""));
                                                    return;
                                                  }
                                                }
                                              : null);
                                }
                              }
                            },
                            weight:
                                2 * (MediaQuery.sizeOf(context).width - 40) / 3,
                            background: state.isConfirm
                                ? AppStyle.primary
                                : AppStyle.white,
                            textColor: state.isConfirm
                                ? AppStyle.black
                                : AppStyle.textGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
