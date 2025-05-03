import 'package:dingtea/domain/interface/settings.dart';
import 'package:dingtea/domain/interface/user.dart';
import 'package:dingtea/infrastructure/models/data/notification_list_data.dart';
import 'package:dingtea/infrastructure/services/app_connectivity.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'setting_state.dart';

class SettingNotifier extends StateNotifier<SettingState> {
  final SettingsRepositoryFacade _settingsRepository;
  final UserRepositoryFacade _userRepository;

  SettingNotifier(this._settingsRepository, this._userRepository)
      : super(const SettingState());

  void changeIndex(bool isChange) {
    state = state.copyWith(isLoading: isChange);
  }

  getNotificationList(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _settingsRepository.getNotificationList();

      response.when(
        success: (data) async {
          state = state.copyWith(notifications: data.data);
          final res = await _userRepository.getProfileDetails();
          res.when(
            success: (d) {
              for (int i = 0; i < data.data!.length; i++) {
                d.data?.notifications?.forEach((element) {
                  if (data.data?[i].id == element.id) {
                    updateData(context, i, element.active ?? false);
                  }
                });
              }

              state = state.copyWith(isLoading: false);
            },
            failure: (failure, status) {
              state = state.copyWith(isLoading: false);
              AppHelpers.showCheckTopSnackBar(
                context,
                failure,
              );
            },
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  updateData(BuildContext context, int index, bool active) async {
    List<NotificationData> list = List.from(state.notifications ?? []);
    NotificationData newNotification = list[index];
    newNotification.active = active;
    list.removeAt(index);
    list.insert(index, newNotification);
    state = state.copyWith(notifications: list);
    _settingsRepository.updateNotification(state.notifications);
  }
}
