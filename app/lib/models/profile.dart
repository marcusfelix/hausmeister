class Profile {
  final String uid;
  String name;
  String? photo;

  Profile({
    required this.uid,
    required this.name,
    this.photo,
  });

  factory Profile.fromJson(String uid, Map<String, dynamic> data) {
    return Profile(
      uid: uid,
      name: data['name'],
      photo: data['photo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'photo': photo,
    };
  }
  
}