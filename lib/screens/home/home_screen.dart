import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/content_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../models/content.dart';
import '../../utils/app_colors.dart';
import '../../widgets/content_card.dart';
import '../../widgets/loading_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 0;
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    
    await Future.wait([
      contentProvider.loadFeaturedContent(),
      contentProvider.loadNewReleases(),
      contentProvider.loadTrendingContent(),
      contentProvider.loadAllContent(),
      subscriptionProvider.loadCurrentSubscription(),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentBottomIndex,
        children: const [
          _HomeTab(),
          _MoviesTab(),
          _SeriesTab(),
          _WatchlistTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 60.h,
          floating: true,
          pinned: false,
          backgroundColor: AppColors.backgroundColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 20.w,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Emmar Films & Music',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => context.go('/search'),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications coming soon!')),
                );
              },
            ),
          ],
        ),

        // Featured Content Carousel
        SliverToBoxAdapter(
          child: Consumer<ContentProvider>(
            builder: (context, contentProvider, child) {
              if (contentProvider.isLoading) {
                return const LoadingShimmer(height: 200);
              }

              final featuredContent = contentProvider.featuredContent;
              if (featuredContent.isEmpty) {
                return const SizedBox();
              }

              return _FeaturedCarousel(content: featuredContent);
            },
          ),
        ),

        // Content Sections
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              _ContentSection(
                title: 'New Releases',
                provider: (context) => context.watch<ContentProvider>().newReleases,
                isLoading: (context) => context.watch<ContentProvider>().isLoading,
              ),
              SizedBox(height: 20.h),
              _ContentSection(
                title: 'Trending Now',
                provider: (context) => context.watch<ContentProvider>().trendingContent,
                isLoading: (context) => context.watch<ContentProvider>().isLoading,
              ),
              SizedBox(height: 20.h),
              _ContentSection(
                title: 'Recommended for You',
                provider: (context) => context.watch<ContentProvider>().allContent.take(10).toList(),
                isLoading: (context) => context.watch<ContentProvider>().isLoading,
              ),
              SizedBox(height: 100.h), // Bottom padding
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  final List<Content> content;

  const _FeaturedCarousel({required this.content});

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.content.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final content = widget.content[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _buildFeaturedItem(content),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.content.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.primaryColor,
            dotColor: AppColors.textSecondary.withOpacity(0.3),
            dotHeight: 8.h,
            dotWidth: 8.w,
            expansionFactor: 3,
            spacing: 8.w,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedItem(Content content) {
    return GestureDetector(
      onTap: () => context.go('/content/${content.id}'),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // Background Image
              CachedNetworkImage(
                imageUrl: content.backdropUrl ?? content.posterUrl,
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
                  child: const Icon(Icons.image_not_supported, color: Colors.white),
                ),
              ),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              
              // Content Info
              Positioned(
                left: 16.w,
                bottom: 16.h,
                right: 16.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content.isPremium)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'PREMIUM',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    SizedBox(height: 8.h),
                    Text(
                      content.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
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
                          size: 16.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          content.formattedRating,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.access_time,
                          color: AppColors.textSecondary,
                          size: 16.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          content.formattedDuration,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Play Button
              Positioned(
                right: 16.w,
                top: 16.h,
                child: GestureDetector(
                  onTap: () => context.go('/video/${content.id}'),
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 28.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final List<Content> Function(BuildContext) provider;
  final bool Function(BuildContext) isLoading;

  const _ContentSection({
    required this.title,
    required this.provider,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final content = provider(context);
    final loading = isLoading(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to see all
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 220.h,
          child: loading
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const LoadingShimmer(
                      width: 140,
                      height: 200,
                      margin: EdgeInsets.only(right: 12),
                    );
                  },
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    return ContentCard(
                      content: content[index],
                      width: 140.w,
                      margin: EdgeInsets.only(right: 12.w),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Placeholder tabs for other bottom navigation items
class _MoviesTab extends StatelessWidget {
  const _MoviesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Movies Tab\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class _SeriesTab extends StatelessWidget {
  const _SeriesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Series Tab\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class _WatchlistTab extends StatelessWidget {
  const _WatchlistTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Watchlist Tab\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Tab\nComing Soon!',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}