import 'package:dingtea/infrastructure/models/data/parcel_order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'parcel_list_state.freezed.dart';

@freezed
class ParcelListState with _$ParcelListState {
  const factory ParcelListState({
    @Default(false) bool isActiveLoading,
    @Default(false) bool isHistoryLoading,
    @Default(0) int totalActiveCount,
    @Default([]) List<ParcelOrder> activeOrders,
    @Default([]) List<ParcelOrder> historyOrders,
  }) = _ParcelListState;

  const ParcelListState._();
}
