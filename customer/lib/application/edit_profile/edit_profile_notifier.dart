import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dingtea/domain/interface/gallery.dart';
import 'package:dingtea/domain/interface/user.dart';
import 'package:dingtea/infrastructure/models/models.dart';
import 'package:dingtea/infrastructure/models/request/edit_profile.dart';
import 'package:dingtea/infrastructure/services/app_connectivity.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/enums.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:dingtea/infrastructure/services/local_storage.dart';
import 'package:dingtea/infrastructure/services/marker_image_cropper.dart';
import 'edit_profile_state.dart';

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final UserRepositoryFacade _userRepository;
  final GalleryRepositoryFacade _galleryRepository;

  EditProfileNotifier(this._userRepository, this._galleryRepository)
      : super(const EditProfileState());

  void setUser(ProfileData user) {
    state = state.copyWith(
      email: user.email ?? "",
      firstName: user.firstname ?? "",
      lastName: user.lastname ?? "",
      phone: user.phone ?? "",
      secondPhone: user.secondPhone ?? "",
      gender: user.gender ?? "",
      birth: user.birthday ?? "",
    );
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void setSecondPhone(String phone) {
    state = state.copyWith(secondPhone: phone);
  }

  void setBirth(String birth) {
    state = state.copyWith(birth: birth);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  getPhotoWithUrl(String url) async {
    ImageCropperForMarker imageMarker = ImageCropperForMarker();
    final file = await imageMarker.urlToFile(url);
    state = state.copyWith(imagePath: file.path);
  }

  Future<void> getPhoto() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: AppStyle.white,
            toolbarWidgetColor: AppStyle.black,
            initAspectRatio: CropAspectRatioPreset.original,
          ),
          IOSUiSettings(title: 'Image Cropper', minimumAspectRatio: 1),
        ],
      );
      state = state.copyWith(imagePath: croppedFile?.path ?? "");
    }
  }

  Future<void> editProfile(BuildContext context, ProfileData user) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      if (state.imagePath.isNotEmpty) {
        if (context.mounted) {
          await updateProfileImage(context, state.imagePath);
        }
      }
      final response = await _userRepository.editProfile(
          user: EditProfile(
        firstname: state.firstName.isEmpty ? user.firstname : state.firstName,
        lastname: state.lastName.isEmpty ? user.lastname : state.lastName,
        birthday: state.birth.isEmpty ? user.birthday : state.birth,
        phone: state.phone.isEmpty ? user.phone : state.phone,
        email: state.email.isEmpty ? user.email : state.email,
        secondPhone: state.secondPhone,
        images: state.url.isEmpty ? user.img ?? "" : state.url,
        gender: state.gender.isEmpty ? user.gender : state.gender,
      ));
      response.when(
        success: (data) {
          LocalStorage.setUser(data.data);
          Navigator.pop(context);
          state = state.copyWith(
            userData: data.data,
            isLoading: false,
            isSuccess: true,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
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

  Future<void> updateProfileImage(BuildContext context, String path) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      String? url;
      final imageResponse =
          await _galleryRepository.uploadImage(path, UploadType.users);
      imageResponse.when(
        success: (data) {
          url = data.imageData?.title;
          state = state.copyWith(url: url ?? "");
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          debugPrint('==> upload profile image failure: $failure');
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        },
      );
    } else {
      if (context.mounted) {
        state = state.copyWith(isLoading: false);
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }
}
