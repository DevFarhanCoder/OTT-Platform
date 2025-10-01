import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppColors.cardColor.withOpacity(0.3),
        highlightColor: AppColors.surfaceColor.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}

class ContentListShimmer extends StatelessWidget {
  final int itemCount;
  final bool isHorizontal;

  const ContentListShimmer({
    super.key,
    this.itemCount = 5,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return SizedBox(
        height: 220.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return LoadingShimmer(
              width: 140,
              height: 200,
              margin: EdgeInsets.only(right: 12.w),
            );
          },
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                LoadingShimmer(
                  width: 100,
                  height: 140,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 8.h),
                      LoadingShimmer(
                        width: 200,
                        height: 12,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 8.h),
                      LoadingShimmer(
                        width: 150,
                        height: 12,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}