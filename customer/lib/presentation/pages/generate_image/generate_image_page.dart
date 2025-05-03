import 'package:auto_route/auto_route.dart';
import 'package:dingtea/application/generate_image/generate_image_provider.dart';
import 'package:dingtea/infrastructure/services/app_helpers.dart';
import 'package:dingtea/infrastructure/services/tr_keys.dart';
import 'package:dingtea/presentation/components/app_bars/common_app_bar.dart';
import 'package:dingtea/presentation/components/buttons/pop_button.dart';
import 'package:dingtea/presentation/components/custom_network_image.dart';
import 'package:dingtea/presentation/components/loading.dart';
import 'package:dingtea/presentation/components/text_fields/search_text_field.dart';
import 'package:dingtea/presentation/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class GenerateImagePage extends StatefulWidget {
  const GenerateImagePage({super.key});

  @override
  State<GenerateImagePage> createState() => _GenerateImagePageState();
}

class _GenerateImagePageState extends State<GenerateImagePage> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(TrKeys.generateImageWithChatGPT),
              style: AppStyle.interNoSemi(
                size: 18,
                color: AppStyle.black,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.all(16.r),
              padding: EdgeInsets.symmetric(vertical: 4.r),
              decoration: BoxDecoration(
                  color: AppStyle.white,
                  borderRadius: BorderRadius.circular(8.r)),
              child: Row(
                children: [
                  Expanded(
                      child: SearchTextField(
                    isSearchIcon: false,
                    textEditingController: controller,
                    hintText: AppHelpers.getTranslation(TrKeys.typeSomething),
                  )),
                  Container(
                    decoration: BoxDecoration(
                        color: AppStyle.primary,
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Consumer(builder: (context, ref, child) {
                      return IconButton(
                          onPressed: () {
                            ref
                                .read(generateImageProvider.notifier)
                                .generateImage(context, controller.text);
                          },
                          icon: const Icon(FlutterRemix.search_2_line));
                    }),
                  ),
                  4.horizontalSpace
                ],
              )),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final state = ref.watch(generateImageProvider);
              return state.isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Loading(),
                        8.verticalSpace,
                        Text(
                            AppHelpers.getTranslation(TrKeys.imageGenerateTake))
                      ],
                    )
                  : GridView.builder(
                      padding:
                          EdgeInsets.only(right: 8.r, left: 8.r, bottom: 24.r),
                      shrinkWrap: true,
                      itemCount: state.data?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            context
                                .maybePop(state.data?.data?[index].url ?? "");
                          },
                          child: Container(
                            margin: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border:
                                    Border.all(color: AppStyle.borderColor)),
                            child: CustomNetworkImage(
                                url: state.data?.data?[index].url ?? "",
                                height: 100,
                                width: 100,
                                radius: 16),
                          ),
                        );
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1, crossAxisCount: 2),
                    );
            }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: const PopButton(),
      ),
    );
  }
}
