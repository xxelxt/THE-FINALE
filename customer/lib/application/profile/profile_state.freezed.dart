// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileState {
  bool get isLoading => throw _privateConstructorUsedError;

  bool get isReferralLoading => throw _privateConstructorUsedError;

  bool get isSaveLoading => throw _privateConstructorUsedError;

  bool get isLoadingHistory => throw _privateConstructorUsedError;

  int get typeIndex => throw _privateConstructorUsedError;

  int get selectAddress => throw _privateConstructorUsedError;

  String get bgImage => throw _privateConstructorUsedError;

  String get logoImage => throw _privateConstructorUsedError;

  AddressNewModel? get addressModel => throw _privateConstructorUsedError;

  ProfileData? get userData => throw _privateConstructorUsedError;

  ReferralModel? get referralData => throw _privateConstructorUsedError;

  List<WalletData>? get walletHistory => throw _privateConstructorUsedError;

  bool get isTermLoading => throw _privateConstructorUsedError;

  bool get isPolicyLoading => throw _privateConstructorUsedError;

  Translation? get policy => throw _privateConstructorUsedError;

  Translation? get term => throw _privateConstructorUsedError;

  List<String> get filepath => throw _privateConstructorUsedError;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res, ProfileState>;

  @useResult
  $Res call(
      {bool isLoading,
      bool isReferralLoading,
      bool isSaveLoading,
      bool isLoadingHistory,
      int typeIndex,
      int selectAddress,
      String bgImage,
      String logoImage,
      AddressNewModel? addressModel,
      ProfileData? userData,
      ReferralModel? referralData,
      List<WalletData>? walletHistory,
      bool isTermLoading,
      bool isPolicyLoading,
      Translation? policy,
      Translation? term,
      List<String> filepath});
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isReferralLoading = null,
    Object? isSaveLoading = null,
    Object? isLoadingHistory = null,
    Object? typeIndex = null,
    Object? selectAddress = null,
    Object? bgImage = null,
    Object? logoImage = null,
    Object? addressModel = freezed,
    Object? userData = freezed,
    Object? referralData = freezed,
    Object? walletHistory = freezed,
    Object? isTermLoading = null,
    Object? isPolicyLoading = null,
    Object? policy = freezed,
    Object? term = freezed,
    Object? filepath = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isReferralLoading: null == isReferralLoading
          ? _value.isReferralLoading
          : isReferralLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaveLoading: null == isSaveLoading
          ? _value.isSaveLoading
          : isSaveLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingHistory: null == isLoadingHistory
          ? _value.isLoadingHistory
          : isLoadingHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      typeIndex: null == typeIndex
          ? _value.typeIndex
          : typeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectAddress: null == selectAddress
          ? _value.selectAddress
          : selectAddress // ignore: cast_nullable_to_non_nullable
              as int,
      bgImage: null == bgImage
          ? _value.bgImage
          : bgImage // ignore: cast_nullable_to_non_nullable
              as String,
      logoImage: null == logoImage
          ? _value.logoImage
          : logoImage // ignore: cast_nullable_to_non_nullable
              as String,
      addressModel: freezed == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressNewModel?,
      userData: freezed == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as ProfileData?,
      referralData: freezed == referralData
          ? _value.referralData
          : referralData // ignore: cast_nullable_to_non_nullable
              as ReferralModel?,
      walletHistory: freezed == walletHistory
          ? _value.walletHistory
          : walletHistory // ignore: cast_nullable_to_non_nullable
              as List<WalletData>?,
      isTermLoading: null == isTermLoading
          ? _value.isTermLoading
          : isTermLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPolicyLoading: null == isPolicyLoading
          ? _value.isPolicyLoading
          : isPolicyLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      policy: freezed == policy
          ? _value.policy
          : policy // ignore: cast_nullable_to_non_nullable
              as Translation?,
      term: freezed == term
          ? _value.term
          : term // ignore: cast_nullable_to_non_nullable
              as Translation?,
      filepath: null == filepath
          ? _value.filepath
          : filepath // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileStateImplCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$ProfileStateImplCopyWith(
          _$ProfileStateImpl value, $Res Function(_$ProfileStateImpl) then) =
      __$$ProfileStateImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isReferralLoading,
      bool isSaveLoading,
      bool isLoadingHistory,
      int typeIndex,
      int selectAddress,
      String bgImage,
      String logoImage,
      AddressNewModel? addressModel,
      ProfileData? userData,
      ReferralModel? referralData,
      List<WalletData>? walletHistory,
      bool isTermLoading,
      bool isPolicyLoading,
      Translation? policy,
      Translation? term,
      List<String> filepath});
}

/// @nodoc
class __$$ProfileStateImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateImpl>
    implements _$$ProfileStateImplCopyWith<$Res> {
  __$$ProfileStateImplCopyWithImpl(
      _$ProfileStateImpl _value, $Res Function(_$ProfileStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isReferralLoading = null,
    Object? isSaveLoading = null,
    Object? isLoadingHistory = null,
    Object? typeIndex = null,
    Object? selectAddress = null,
    Object? bgImage = null,
    Object? logoImage = null,
    Object? addressModel = freezed,
    Object? userData = freezed,
    Object? referralData = freezed,
    Object? walletHistory = freezed,
    Object? isTermLoading = null,
    Object? isPolicyLoading = null,
    Object? policy = freezed,
    Object? term = freezed,
    Object? filepath = null,
  }) {
    return _then(_$ProfileStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isReferralLoading: null == isReferralLoading
          ? _value.isReferralLoading
          : isReferralLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaveLoading: null == isSaveLoading
          ? _value.isSaveLoading
          : isSaveLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingHistory: null == isLoadingHistory
          ? _value.isLoadingHistory
          : isLoadingHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      typeIndex: null == typeIndex
          ? _value.typeIndex
          : typeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectAddress: null == selectAddress
          ? _value.selectAddress
          : selectAddress // ignore: cast_nullable_to_non_nullable
              as int,
      bgImage: null == bgImage
          ? _value.bgImage
          : bgImage // ignore: cast_nullable_to_non_nullable
              as String,
      logoImage: null == logoImage
          ? _value.logoImage
          : logoImage // ignore: cast_nullable_to_non_nullable
              as String,
      addressModel: freezed == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressNewModel?,
      userData: freezed == userData
          ? _value.userData
          : userData // ignore: cast_nullable_to_non_nullable
              as ProfileData?,
      referralData: freezed == referralData
          ? _value.referralData
          : referralData // ignore: cast_nullable_to_non_nullable
              as ReferralModel?,
      walletHistory: freezed == walletHistory
          ? _value._walletHistory
          : walletHistory // ignore: cast_nullable_to_non_nullable
              as List<WalletData>?,
      isTermLoading: null == isTermLoading
          ? _value.isTermLoading
          : isTermLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPolicyLoading: null == isPolicyLoading
          ? _value.isPolicyLoading
          : isPolicyLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      policy: freezed == policy
          ? _value.policy
          : policy // ignore: cast_nullable_to_non_nullable
              as Translation?,
      term: freezed == term
          ? _value.term
          : term // ignore: cast_nullable_to_non_nullable
              as Translation?,
      filepath: null == filepath
          ? _value._filepath
          : filepath // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ProfileStateImpl extends _ProfileState {
  const _$ProfileStateImpl(
      {this.isLoading = true,
      this.isReferralLoading = true,
      this.isSaveLoading = false,
      this.isLoadingHistory = true,
      this.typeIndex = 0,
      this.selectAddress = 0,
      this.bgImage = "",
      this.logoImage = "",
      this.addressModel = null,
      this.userData = null,
      this.referralData = null,
      final List<WalletData>? walletHistory = const [],
      this.isTermLoading = false,
      this.isPolicyLoading = false,
      this.policy = null,
      this.term = null,
      final List<String> filepath = const []})
      : _walletHistory = walletHistory,
        _filepath = filepath,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isReferralLoading;
  @override
  @JsonKey()
  final bool isSaveLoading;
  @override
  @JsonKey()
  final bool isLoadingHistory;
  @override
  @JsonKey()
  final int typeIndex;
  @override
  @JsonKey()
  final int selectAddress;
  @override
  @JsonKey()
  final String bgImage;
  @override
  @JsonKey()
  final String logoImage;
  @override
  @JsonKey()
  final AddressNewModel? addressModel;
  @override
  @JsonKey()
  final ProfileData? userData;
  @override
  @JsonKey()
  final ReferralModel? referralData;
  final List<WalletData>? _walletHistory;

  @override
  @JsonKey()
  List<WalletData>? get walletHistory {
    final value = _walletHistory;
    if (value == null) return null;
    if (_walletHistory is EqualUnmodifiableListView) return _walletHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isTermLoading;
  @override
  @JsonKey()
  final bool isPolicyLoading;
  @override
  @JsonKey()
  final Translation? policy;
  @override
  @JsonKey()
  final Translation? term;
  final List<String> _filepath;

  @override
  @JsonKey()
  List<String> get filepath {
    if (_filepath is EqualUnmodifiableListView) return _filepath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filepath);
  }

  @override
  String toString() {
    return 'ProfileState(isLoading: $isLoading, isReferralLoading: $isReferralLoading, isSaveLoading: $isSaveLoading, isLoadingHistory: $isLoadingHistory, typeIndex: $typeIndex, selectAddress: $selectAddress, bgImage: $bgImage, logoImage: $logoImage, addressModel: $addressModel, userData: $userData, referralData: $referralData, walletHistory: $walletHistory, isTermLoading: $isTermLoading, isPolicyLoading: $isPolicyLoading, policy: $policy, term: $term, filepath: $filepath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isReferralLoading, isReferralLoading) ||
                other.isReferralLoading == isReferralLoading) &&
            (identical(other.isSaveLoading, isSaveLoading) ||
                other.isSaveLoading == isSaveLoading) &&
            (identical(other.isLoadingHistory, isLoadingHistory) ||
                other.isLoadingHistory == isLoadingHistory) &&
            (identical(other.typeIndex, typeIndex) ||
                other.typeIndex == typeIndex) &&
            (identical(other.selectAddress, selectAddress) ||
                other.selectAddress == selectAddress) &&
            (identical(other.bgImage, bgImage) || other.bgImage == bgImage) &&
            (identical(other.logoImage, logoImage) ||
                other.logoImage == logoImage) &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel) &&
            (identical(other.userData, userData) ||
                other.userData == userData) &&
            (identical(other.referralData, referralData) ||
                other.referralData == referralData) &&
            const DeepCollectionEquality()
                .equals(other._walletHistory, _walletHistory) &&
            (identical(other.isTermLoading, isTermLoading) ||
                other.isTermLoading == isTermLoading) &&
            (identical(other.isPolicyLoading, isPolicyLoading) ||
                other.isPolicyLoading == isPolicyLoading) &&
            (identical(other.policy, policy) || other.policy == policy) &&
            (identical(other.term, term) || other.term == term) &&
            const DeepCollectionEquality().equals(other._filepath, _filepath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isReferralLoading,
      isSaveLoading,
      isLoadingHistory,
      typeIndex,
      selectAddress,
      bgImage,
      logoImage,
      addressModel,
      userData,
      referralData,
      const DeepCollectionEquality().hash(_walletHistory),
      isTermLoading,
      isPolicyLoading,
      policy,
      term,
      const DeepCollectionEquality().hash(_filepath));

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      __$$ProfileStateImplCopyWithImpl<_$ProfileStateImpl>(this, _$identity);
}

abstract class _ProfileState extends ProfileState {
  const factory _ProfileState(
      {final bool isLoading,
      final bool isReferralLoading,
      final bool isSaveLoading,
      final bool isLoadingHistory,
      final int typeIndex,
      final int selectAddress,
      final String bgImage,
      final String logoImage,
      final AddressNewModel? addressModel,
      final ProfileData? userData,
      final ReferralModel? referralData,
      final List<WalletData>? walletHistory,
      final bool isTermLoading,
      final bool isPolicyLoading,
      final Translation? policy,
      final Translation? term,
      final List<String> filepath}) = _$ProfileStateImpl;

  const _ProfileState._() : super._();

  @override
  bool get isLoading;

  @override
  bool get isReferralLoading;

  @override
  bool get isSaveLoading;

  @override
  bool get isLoadingHistory;

  @override
  int get typeIndex;

  @override
  int get selectAddress;

  @override
  String get bgImage;

  @override
  String get logoImage;

  @override
  AddressNewModel? get addressModel;

  @override
  ProfileData? get userData;

  @override
  ReferralModel? get referralData;

  @override
  List<WalletData>? get walletHistory;

  @override
  bool get isTermLoading;

  @override
  bool get isPolicyLoading;

  @override
  Translation? get policy;

  @override
  Translation? get term;

  @override
  List<String> get filepath;

  /// Create a copy of ProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
