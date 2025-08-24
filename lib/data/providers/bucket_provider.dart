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

  Future<void> deleteBucket(String bucketId) async {
    final repository = ref.read(bucketRepositoryProvider);
    await repository.deleteBucket(bucketId);
    ref.invalidateSelf();
  }

  Future<void> reorderBuckets(List<String> bucketIds) async {
    final repository = ref.read(bucketRepositoryProvider);
    await repository.reorderBuckets(bucketIds);
    ref.invalidateSelf();
  }
}
