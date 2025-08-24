import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/time_bucket.dart';
import '../repositories/bucket_repository.dart';

final bucketRepositoryProvider = Provider<BucketRepository>((ref) {
  return BucketRepository();
});

final userBucketsProvider = AsyncNotifierProvider.family<UserBucketsNotifier, List<TimeBucket>, String>(
  UserBucketsNotifier.new,
);

final activeBucketsProvider = AsyncNotifierProvider.family<ActiveBucketsNotifier, List<TimeBucket>, ({String userId, int age})>(
  ActiveBucketsNotifier.new,
);

class UserBucketsNotifier extends FamilyAsyncNotifier<List<TimeBucket>, String> {
  @override
  Future<List<TimeBucket>> build(String arg) async {
    final repository = ref.read(bucketRepositoryProvider);
    return await repository.getUserBuckets(arg);
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

class ActiveBucketsNotifier extends FamilyAsyncNotifier<List<TimeBucket>, ({String userId, int age})> {
  @override
  Future<List<TimeBucket>> build(({String userId, int age}) arg) async {
    final repository = ref.read(bucketRepositoryProvider);
    return await repository.getActiveBucketsForAge(arg.userId, arg.age);
  }
}