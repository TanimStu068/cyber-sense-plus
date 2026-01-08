import 'package:hive/hive.dart';

part 'user_profile_hive.g.dart';

@HiveType(typeId: 3)
class UserProfileHive extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String role;

  @HiveField(5)
  String? avatarPath;

  UserProfileHive({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarPath,
  });
}
