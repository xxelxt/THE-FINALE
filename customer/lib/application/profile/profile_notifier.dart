import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dingtea/domain/di/dependency_manager.dart';
import 'package:dingtea/domain/interface/user.dart';
import 'package:dingtea/infrastructure/models/data/address_new_data.dart';
import 'package:dingtea/infrastructure/models/data/address_old_data.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/services/app_connectivity.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/enums.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/presentation/routes/app_router.dart';

import 'package:dingtea/domain/interface/gallery.dart';
import 'package:dingtea/domain/interface/shops.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserRepositoryFacade _userRepository;
  final ShopsRepositoryFacade _shopsRepository;
  final GalleryRepositoryFacade _galleryRepository;

  ProfileNotifier(
      this._userRepository, this._shopsRepository, this._galleryRepository)
      : super(const ProfileState());
  int page = 1;

  getTerm({required BuildContext context}) async {
    state = state.copyWith(isTermLoading: state.term == null);
    final res = await settingsRepository.getTerm();
    res.when(
      success: (l) {
        state = state.copyWith(isTermLoading: false, term: l);
      },
      failure: (r, s) {
        state = state.copyWith(isTermLoading: false);
        AppHelpers.showCheckTopSnackBar(context, r.toString());
      },
    );
  }

  getPolicy({required BuildContext context}) async {
    state = state.copyWith(isPolicyLoading: state.policy == null);
    final res = await settingsRepository.getPolicy();
    res.when(
      success: (l) {
        state = state.copyWith(isPolicyLoading: false, policy: l);
      },
      failure: (r, s) {
        state = state.copyWith(isPolicyLoading: false);
        AppHelpers.showCheckTopSnackBar(context, r.toString());
      },
    );
  }

  resetShopData() {
    state = state.copyWith(
        bgImage: "", logoImage: "", addressModel: null, isSaveLoading: false);
  }

  findSelectIndex() {
    for (int i = 0; i < (state.userData?.addresses?.length ?? 0); i++) {
      if (state.userData?.addresses?[i].active ?? false) {
        state = state.copyWith(selectAddress: i);
        break;
      }
    }
  }

  void change(int index) {
    state = state.copyWith(selectAddress: index);
  }

  setAddress(dynamic data) {
    state = state.copyWith(addressModel: data);
  }

  setActiveAddress({int? id, required int index}) async {
    List<AddressNewModel> list = List.from(state.userData?.addresses ?? []);
    for (var element in list) {
      element.active = false;
    }
    list[index].active = true;
    ProfileData newUser = state.userData!.copyWith(addresses: list);
    state = state.copyWith(userData: newUser);
    _userRepository.setActiveAddress(id: id ?? 0);
  }

  deleteAddress({int? id, required int index}) async {
    List<AddressNewModel> list = List.from(state.userData?.addresses ?? []);
    list.removeAt(index);
    ProfileData newUser = state.userData!.copyWith(addresses: list);
    state = state.copyWith(userData: newUser);
    _userRepository.deleteAddress(id: id ?? 0);
  }

  setBgImage(String bgImage) {
    state = state.copyWith(bgImage: bgImage);
  }

  void setFile(String file) {
    List<String> list = List.from(state.filepath);
    list.add(file);
    state = state.copyWith(filepath: list);
  }

  void deleteFile(String value) {
    List<String> list = List.from(state.filepath);
    list.remove(value);
    state = state.copyWith(filepath: list);
  }

  setLogoImage(String logoImage) {
    state = state.copyWith(logoImage: logoImage);
  }

  Future<void> fetchUser(BuildContext context,
      {RefreshController? refreshController, VoidCallback? onSuccess}) async {
    if (LocalStorage.getToken().isNotEmpty) {
      final connected = await AppConnectivity.connectivity();
      if (connected) {
        if (refreshController == null) {
          state = state.copyWith(isLoading: true);
        }
        final response = await _userRepository.getProfileDetails();
        response.when(
          success: (data) async {
            LocalStorage.setWalletData(data.data?.wallet);
            LocalStorage.setUser(data.data);
            LocalStorage.setAddressSelected(AddressData(
                title: data.data?.addresses?.firstWhere(
                        (element) => element.active ?? false, orElse: () {
                      return AddressNewModel();
                    }).title ??
                    "",
                address: data.data?.addresses
                        ?.firstWhere((element) => element.active ?? false,
                            orElse: () {
                          return AddressNewModel();
                        })
                        .address
                        ?.address ??
                    "",
                location: LocationModel(
                    longitude: data.data?.addresses
                        ?.firstWhere((element) => element.active ?? false,
                            orElse: () {
                          return AddressNewModel();
                        })
                        .location
                        ?.last,
                    latitude: data.data?.addresses
                        ?.firstWhere((element) => element.active ?? false,
                            orElse: () {
                          return AddressNewModel();
                        })
                        .location
                        ?.first)));
            if (refreshController == null) {
              state = state.copyWith(isLoading: false, userData: data.data);
            } else {
              state = state.copyWith(userData: data.data);
            }
            refreshController?.refreshCompleted();
            onSuccess?.call();
            findSelectIndex();
          },
          failure: (failure, status) {
            if (refreshController == null) {
              state = state.copyWith(isLoading: false);
            }
            if (status == 401) {
              context.router.popUntilRoot();
              context.replaceRoute(const LoginRoute());
            }
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
  }

  Future<void> fetchReferral(BuildContext context,
      {RefreshController? refreshController}) async {
    if (LocalStorage.getToken().isNotEmpty) {
      final connected = await AppConnectivity.connectivity();
      if (connected) {
        if (refreshController == null) {
          state = state.copyWith(isReferralLoading: true);
        }
        final response = await _userRepository.getReferralDetails();
        response.when(
          success: (data) async {
            if (refreshController == null) {
              state =
                  state.copyWith(isReferralLoading: false, referralData: data);
            } else {
              state = state.copyWith(referralData: data);
            }
            refreshController?.refreshCompleted();
          },
          failure: (failure, status) {
            if (refreshController == null) {
              state = state.copyWith(isReferralLoading: false);
            }
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
  }

  Future<void> logOut() async {
    final fcm = await FirebaseMessaging.instance.getToken();
    _userRepository.logoutAccount(fcm: fcm ?? "");
  }

  Future<void> deleteAccount(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _userRepository.deleteAccount();
      response.when(
        success: (data) async {
          context.router.popUntilRoot();
          context.replaceRoute(const LoginRoute());
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

  void setUser(ProfileData user) async {
    state = state.copyWith(userData: user);
  }

  void getWallet(BuildContext context,
      {RefreshController? refreshController}) async {
    page = 1;
    if (LocalStorage.getToken().isNotEmpty) {
      final connected = await AppConnectivity.connectivity();
      if (connected) {
        if (refreshController == null) {
          state = state.copyWith(isLoadingHistory: true);
        }
        final response = await _userRepository.getWalletHistories(1);
        response.when(
          success: (data) async {
            if (refreshController == null) {
              state = state.copyWith(
                  isLoadingHistory: false, walletHistory: data.data);
            } else {
              state = state.copyWith(walletHistory: data.data);
            }
            refreshController?.refreshCompleted();
          },
          failure: (failure, status) {
            if (refreshController == null) {
              state = state.copyWith(isLoadingHistory: false);
            }
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
  }

  void getWalletPage(
      BuildContext context, RefreshController refreshController) async {
    if (LocalStorage.getToken().isNotEmpty) {
      final connected = await AppConnectivity.connectivity();
      if (connected) {
        final response = await _userRepository.getWalletHistories(++page);
        response.when(
          success: (data) async {
            List<WalletData> list = List.from(state.walletHistory ?? []);
            list.addAll(data.data ?? []);
            state = state.copyWith(walletHistory: list);
            refreshController.loadComplete();
            if (data.data?.isEmpty ?? true) {
              refreshController.loadNoData();
            } else {
              refreshController.loadComplete();
            }
          },
          failure: (failure, status) {
            refreshController.loadNoData();
            --page;
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
  }

  changeIndex(int index) {
    state = state.copyWith(typeIndex: index);
  }

  Future<void> createShop({
    required BuildContext context,
    required String tax,
    required String deliveryTo,
    required String deliveryFrom,
    required String phone,
    required String startPrice,
    required String name,
    required String desc,
    required String perKm,
    required AddressNewModel address,
    required String deliveryType,
    required num categoryId,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isSaveLoading: true);

      String? logoImage;
      String? backgroundImage;
      List<String>? files;
      final logoResponse = await _galleryRepository.uploadImage(
        state.logoImage,
        UploadType.shopsLogo,
      );
      logoResponse.when(
        success: (data) {
          logoImage = data.imageData?.title;
        },
        failure: (failure, s) {
          debugPrint('===> upload logo image failure: $failure');
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
      final backgroundResponse = await _galleryRepository.uploadImage(
        state.bgImage,
        UploadType.shopsBack,
      );
      backgroundResponse.when(
        success: (data) {
          backgroundImage = data.imageData?.title;
        },
        failure: (failure, s) {
          debugPrint('===> upload background image failure: $failure');
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
      final fileResponse = await _galleryRepository.uploadMultiImage(
        state.filepath,
        UploadType.shopsBack,
      );
      fileResponse.when(
        success: (data) {
          files = data.data?.title;
        },
        failure: (failure, s) {
          debugPrint('===> upload document failure: $failure');
          AppHelpers.showCheckTopSnackBar(context, failure);
        },
      );
      final response = await _shopsRepository.createShop(
        logoImage: logoImage,
        documents: files ?? [],
        backgroundImage: backgroundImage,
        tax: double.tryParse(tax) ?? 0,
        deliveryTo: double.tryParse(deliveryTo) ?? 0,
        deliveryFrom: double.tryParse(deliveryFrom) ?? 0,
        deliveryType: deliveryType,
        phone: phone,
        name: name,
        description: desc,
        startPrice: double.tryParse(startPrice) ?? 0,
        perKm: double.tryParse(perKm) ?? 0,
        address: address,
        category: categoryId,
      );
      response.when(
        success: (data) {
          state = state.copyWith(isSaveLoading: false);
          fetchUser(context, refreshController: RefreshController());
          context.maybePop();
        },
        failure: (failure, s) {
          state = state.copyWith(isSaveLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
          debugPrint('==> create shop failure: $failure');
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }
}
