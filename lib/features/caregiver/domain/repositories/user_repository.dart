import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<AppUser>> getAllUsers();
  Future<void> addUser(AppUser user);
  Future<void> updateUser(AppUser user);
  Future<void> deleteUser(String id);
}
