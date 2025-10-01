import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart'; // Temporarily disabled for build compatibility
import 'package:go_router/go_router.dart';
import '../../providers/content_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../models/content.dart';
import '../../utils/app_colors.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  // ChewieController? _chewieController; // Temporarily disabled for build compatibility
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  Content? _content;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    await contentProvider.loadContentById(widget.videoId);
    
    if (mounted) {
      _content = contentProvider.selectedContent;
      if (_content != null) {
        _initializePlayer();
        // Add to watch history
        contentProvider.addToHistory(_content!);
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Content not found';
          _isLoading = false;
        });
      }
    }
  }

  void _initializePlayer() async {
    try {
      // Check if user can access this content
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      if (_content!.isPremium && !subscriptionProvider.canAccessPremiumContent()) {
        setState(() {
          _hasError = true;
          _errorMessage = 'This is premium content. Please subscribe to watch.';
          _isLoading = false;
        });
        return;
      }

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(_content!.videoUrl),
      );

      await _videoPlayerController!.initialize();

      // ChewieController setup temporarily replaced with basic video player
      await _videoPlayerController!.play(); // Auto play

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load video: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // _chewieController?.dispose(); // Temporarily disabled
    _videoPlayerController?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _content?.title ?? 'Loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement cast functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cast feature coming soon!')),
                      );
                    },
                    icon: Icon(
                      Icons.cast,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement more options
                      _showMoreOptions();
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                ],
              ),
            ),

            // Video Player
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: _buildVideoPlayer(),
              ),
            ),

            // Video Info
            if (_content != null) _buildVideoInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return _buildErrorWidget();
    }

    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController!),
      );
    }

    return const Center(
      child: Text(
        'Failed to load video player',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorWidget() {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final isPremiumRequired = _errorMessage?.contains('premium') == true;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPremiumRequired ? Icons.lock : Icons.error,
              color: isPremiumRequired ? AppColors.accentColor : AppColors.errorColor,
              size: 64.w,
            ),
            SizedBox(height: 16.h),
            Text(
              isPremiumRequired ? 'Premium Content' : 'Error',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage ?? 'Something went wrong',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            if (isPremiumRequired)
              ElevatedButton(
                onPressed: () => context.go('/subscription'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
                child: Text(
                  'Subscribe Now',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: () => _loadContent(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _content!.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.accentColor,
                size: 16.w,
              ),
              SizedBox(width: 4.w),
              Text(
                _content!.formattedRating,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time,
                color: AppColors.textSecondary,
                size: 16.w,
              ),
              SizedBox(width: 4.w),
              Text(
                _content!.formattedDuration,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  _content!.genre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            _content!.description,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.bookmark_add, color: Colors.white),
                title: const Text('Add to Watchlist', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  if (_content != null) {
                    Provider.of<ContentProvider>(context, listen: false)
                        .addToWatchlist(_content!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to watchlist')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.white),
                title: const Text('Report', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement report functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report feature coming soon!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}