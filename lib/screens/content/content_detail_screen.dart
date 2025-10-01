import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class ContentDetailScreen extends StatelessWidget {
  final String contentId;

  const ContentDetailScreen({
    super.key,
    required this.contentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie,
              color: AppColors.primaryColor,
              size: 80.w,
            ),
            SizedBox(height: 16.h),
            Text(
              'Content Detail Screen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Content ID: $contentId',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Coming Soon!',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}