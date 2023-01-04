class UserModel {
  String id;
  final String nom;
  final String prenom;
  final String phone;
  String profileUrl;


  UserModel({
    this.id = '',
    required this.nom,
    required this.prenom,
    required this.phone,
    this.profileUrl = '',
});

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'phone': phone,
    'profileUrl': profileUrl,
  };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    nom: json['nom'],
    prenom: json['prenom'],
    phone: json['phone'],
    profileUrl: json['profileUrl'],
  );
}