// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccount _$UserAccountFromJson(Map<String, dynamic> json) => UserAccount(
      id: json['id'] as String,
      username: json['username'] as String?,
      accountType:
          $enumDecodeNullable(_$AccountTypeEnumMap, json['accountType']),
      registeredDate: json['registeredDate'] == null
          ? null
          : DateTime.parse(json['registeredDate'] as String),
      photo: json['photo'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$UserAccountToJson(UserAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountType': _$AccountTypeEnumMap[instance.accountType],
      'registeredDate': instance.registeredDate?.toIso8601String(),
      'username': instance.username,
      'photo': instance.photo,
      'email': instance.email,
      'phone': instance.phone,
    };

const _$AccountTypeEnumMap = {
  AccountType.none: 'none',
  AccountType.phone: 'phone',
  AccountType.google: 'google',
  AccountType.facebook: 'facebook',
  AccountType.anonymous: 'anonymous',
  AccountType.emailAndPassword: 'emailAndPassword',
};
