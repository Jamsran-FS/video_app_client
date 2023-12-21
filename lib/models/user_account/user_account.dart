import 'package:video_app/index.dart';

part 'user_account.g.dart';

@JsonSerializable()
class UserAccount extends Equatable {
  final String id;
  final AccountType? accountType;
  final DateTime? registeredDate;
  final String? username, photo, email, phone;

  const UserAccount({
    required this.id,
    this.username,
    this.accountType,
    this.registeredDate,
    this.photo,
    this.email,
    this.phone,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) =>
      _$UserAccountFromJson(json);

  Map<String, dynamic> toJson() => _$UserAccountToJson(this);

  static const empty = UserAccount(id: '');

  bool get isEmpty => this == UserAccount.empty;

  bool get isNotEmpty => this != UserAccount.empty;

  @override
  List<Object?> get props =>
      [id, accountType, registeredDate, username, photo, email, phone];
}
