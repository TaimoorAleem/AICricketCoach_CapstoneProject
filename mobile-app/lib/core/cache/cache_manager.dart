import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = 'customCacheKey';

  CustomCacheManager()
      : super(
    Config(
      key,
      stalePeriod: const Duration(days: 7), // Cache valid for 7 days
      maxNrOfCacheObjects: 100, // Maximum 100 cached files
    ),
  );
}