import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/content_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/content_card.dart';
import '../../widgets/loading_shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query != _currentQuery) {
      _currentQuery = query;
      Provider.of<ContentProvider>(context, listen: false).searchContent(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search movies, series, documentaries...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                            size: 24.w,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    _performSearch('');
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: AppColors.textSecondary,
                                    size: 20.w,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                        onChanged: _performSearch,
                        autofocus: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Results
            Expanded(
              child: Consumer<ContentProvider>(
                builder: (context, contentProvider, child) {
                  if (_currentQuery.isEmpty) {
                    return _buildEmptyState();
                  }

                  if (contentProvider.isSearching) {
                    return _buildLoadingState();
                  }

                  final searchResults = contentProvider.searchResults;
                  if (searchResults.isEmpty) {
                    return _buildNoResultsState();
                  }

                  return _buildSearchResults(searchResults);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 80.w,
          ),
          SizedBox(height: 16.h),
          Text(
            'Search for Entertainment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Find your favorite movies, series, and documentaries',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const ContentListShimmer(
      itemCount: 8,
      isHorizontal: false,
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: AppColors.textSecondary,
            size: 80.w,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Results Found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List searchResults) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ContentCard(
          content: searchResults[index],
        );
      },
    );
  }
}