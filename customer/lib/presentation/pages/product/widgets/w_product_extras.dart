import 'package:dingtea/application/product/product_provider.dart';
import 'package:dingtea/infrastructure/models/data/typed_extra.dart';
import 'package:dingtea/infrastructure/services/enums.dart';
import 'package:dingtea/presentation/components/extras/color_extras.dart';
import 'package:dingtea/presentation/components/extras/image_extras.dart';
import 'package:dingtea/presentation/components/extras/text_extras.dart';
import 'package:dingtea/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WProductExtras extends ConsumerWidget {
  const WProductExtras({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);
    final notifier = ref.read(productProvider.notifier);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            state.typedExtras.isEmpty ? AppStyle.transparent : AppStyle.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: REdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.typedExtras.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final TypedExtra typedExtra = state.typedExtras[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppStyle.white,
                ),
                padding: REdgeInsets.all(4),
                // padding: REdgeInsets.symmetric(horizontal: 8, vertical: 8),
                // margin: REdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typedExtra.title,
                      style: AppStyle.interNoSemi(
                        size: 16,
                        color: AppStyle.black,
                        letterSpacing: -0.4,
                      ),
                    ),
                    8.verticalSpace,
                    typedExtra.type == ExtrasType.text
                        ? TextExtras(
                            uiExtras: typedExtra.uiExtras,
                            groupIndex: typedExtra.groupIndex,
                            onUpdate: (uiExtra) {
                              notifier.updateSelectedIndexes(
                                context,
                                typedExtra.groupIndex,
                                uiExtra.index,
                              );
                            },
                          )
                        : typedExtra.type == ExtrasType.color
                            ? ColorExtras(
                                uiExtras: typedExtra.uiExtras,
                                groupIndex: typedExtra.groupIndex,
                                onUpdate: (uiExtra) {
                                  notifier.updateSelectedIndexes(
                                    context,
                                    typedExtra.groupIndex,
                                    uiExtra.index,
                                  );
                                },
                              )
                            : typedExtra.type == ExtrasType.image
                                ? ImageExtras(
                                    uiExtras: typedExtra.uiExtras,
                                    groupIndex: typedExtra.groupIndex,
                                    updateImage: notifier.changeActiveImageUrl,
                                    onUpdate: (uiExtra) {
                                      notifier.updateSelectedIndexes(
                                        context,
                                        typedExtra.groupIndex,
                                        uiExtra.index,
                                      );
                                    },
                                  )
                                : const SizedBox(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
