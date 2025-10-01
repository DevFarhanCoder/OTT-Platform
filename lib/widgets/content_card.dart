import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/content.dart';
import '../utils/app_colors.dart';

class ContentCard extends StatelessWidget {
  final Content content;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool showInfo;

  const ContentCard({
    super.key,
    required this.content,
    this.width,
    this.height,
    this.margin,
    this.showInfo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 140.w,
      height: height ?? 220.h,
      margin: margin,
      child: GestureDetector(
        onTap: () => context.go('/content/${content.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    children: [
                      // Poster Image
                      CachedNetworkImage(
                        imageUrl: content.posterUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.cardColor,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.cardColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: AppColors.textSecondary,
                                size: 32.w,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                content.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Premium Badge
                      if (content.isPremium)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.accentColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      
                      // New Release Badge
                      if (content.isNewRelease)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.errorColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      
                      // Play Button Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.black.withOpacity(0.0),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () => context.go('/video/${content.id}'),
                              child: Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 24.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Quality Badge
                      if (content.quality != null)
                        Positioned(
                          bottom: 8.h,
                          right: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              content.quality!,
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Content Info
            if (showInfo) ...[
              SizedBox(height: 8.h),
              Text(
                content.title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.accentColor,
                    size: 12.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    content.formattedRating,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    content.genre,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}