import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/time_bucket.dart';
import '../repositories/bucket_repository.dart';

final bucketRepositoryProvider = Provider<BucketRepository>((ref) {
  return BucketRepository();
});

final bucketsProvider =
    AsyncNotifierProvider<BucketsNotifier, List<TimeBucket>>(
  BucketsNotifier.new,
);

class BucketsNotifier extends AsyncNotifier<List<TimeBucket>> {
  @override
  Future<List<TimeBucket>> build() async {
    final repository = ref.read(bucketRepositoryProvider);
    return await repository.getAllBuckets();
  }

  Future<void> createBucket(TimeBucket bucket) async {
    final repository = ref.read(bucketRepositoryProvider);
    await repository.createBucket(bucket);
    ref.invalidateSelf();
  }

  Future<void> updateBucket(TimeBucket bucket) async {
    final repository = ref.read(bucketRepositoryProvider);
    await repository.updateBucket(bucket);
    ref.invalidateSelf();
  }

  Future<bool> deleteBucket(String bucketId) async {
    try {
      final repository = ref.read(bucketRepositoryProvider);
      final success = await repository.deleteBucket(bucketId);
      print('Delete bucket result: $success for bucketId: $bucketId');
      if (success) {
        // Force refresh the state by rebuilding
        state = const AsyncValue.loading();
        state = AsyncValue.data(await build());
      }
      return success;
    } catch (e) {
      print('Error in deleteBucket provider: $e');
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> reorderBuckets(List<String> bucketIds) async {
    final repository = ref.read(bucketRepositoryProvider);
    await repository.reorderBuckets(bucketIds);
    ref.invalidateSelf();
  }
}
