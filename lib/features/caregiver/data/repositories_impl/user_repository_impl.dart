import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<List<AppUser>> getAllUsers() async {
    QuerySnapshot snapshot = await userCollection.get();
    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addUser(AppUser user) async {
    await userCollection.add(UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    ).toJson());
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await userCollection.doc(user.id).update(UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    ).toJson());
  }

  @override
  Future<void> deleteUser(String id) async {
    await userCollection.doc(id).delete();
  }
}
