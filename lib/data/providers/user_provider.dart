import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final currentUserProvider = StateProvider<User?>((ref) => null);

final userProvider = AsyncNotifierProvider.family<UserNotifier, User?, String>(
  UserNotifier.new,
);

class UserNotifier extends FamilyAsyncNotifier<User?, String> {
  @override
  Future<User?> build(String arg) async {
    final repository = ref.read(userRepositoryProvider);
    try {
      return await repository.getUserById(arg);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(User user) async {
    state = const AsyncLoading();
    final repository = ref.read(userRepositoryProvider);
    
    try {
      await repository.updateUser(user);
      ref.read(currentUserProvider.notifier).state = user;
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}