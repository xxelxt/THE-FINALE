import 'package:dingtea/infrastructure/models/data/generate_image_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'generate_image_state.freezed.dart';

@freezed
class GenerateImageState with _$GenerateImageState {
  const factory GenerateImageState(
      {@Default(false) bool isLoading,
      @Default(null) GenerateImageModel? data}) = _GenerateImageState;

  const GenerateImageState._();
}
