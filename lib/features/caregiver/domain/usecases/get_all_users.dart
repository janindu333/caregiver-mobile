import '../repositories/user_repository.dart';
import '../entities/user_entity.dart';

class GetAllUsers {
  final UserRepository repository;

  GetAllUsers(this.repository);

  Future<List<AppUser>> call() async {
    return await repository.getAllUsers();
  }
}
