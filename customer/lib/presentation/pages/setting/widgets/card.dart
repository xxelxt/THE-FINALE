import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dingtea/presentation/theme/theme.dart';

class CardWidget extends StatelessWidget {
  final String number;
  final String startDate;
  final String name;

  const CardWidget(
      {super.key,
      required this.number,
      required this.startDate,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.only(right: 20.w, left: 20.w, top: 46.h, bottom: 24.h),
      decoration: BoxDecoration(
          image: const DecorationImage(
              alignment: Alignment.topRight,
              image: AssetImage("assets/images/cardBg.png"),
              fit: BoxFit.contain),
          color: AppStyle.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppStyle.white.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/card.png",
            width: 36.w,
          ),
          24.verticalSpace,
          Text(
            number,
            style: AppStyle.interBold(
              size: 18,
              color: AppStyle.black,
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              Text(
                startDate,
                style: AppStyle.interNormal(
                  size: 12,
                  color: AppStyle.black,
                ),
              ),
              10.horizontalSpace,
              Text(
                "Cheese",
                style: AppStyle.interNormal(
                  size: 12,
                  color: AppStyle.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: AppStyle.interNormal(
                  size: 12,
                  color: AppStyle.black,
                ),
              ),
              Image.asset(
                "assets/images/visa.png",
                height: 36.h,
              )
            ],
          ),
        ],
      ),
    );
  }
}
