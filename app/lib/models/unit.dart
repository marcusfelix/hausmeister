import 'package:app/models/profile.dart';

class Unit {
  final String id;
  String unit;
  String? address;
  List<Profile> tenants;
  String accessCode;

  Unit({
    required this.id,
    required this.unit,
    this.address,
    required this.tenants,
    required this.accessCode,
  });

  factory Unit.fromJson(String id, Map<String, dynamic> data) {
    return Unit(
      id: id,
      unit: data['unit'],
      address: data['address'],
      tenants: (data['tenants'] ?? {}).keys.map<Profile>((String uid) => Profile.fromJson(uid, data['tenants'][uid])).toList(),
      accessCode: data['access_code'],
    );
  }

  Map<String, dynamic> toMap() => {
    'unit': unit,
    'address': address,
    'tenants': tenants.map((tenant) => tenant.toMap()).toList(),
  };
}