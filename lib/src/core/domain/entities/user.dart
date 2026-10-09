class User {
  const User({required this.id, required this.email});

  final String id;
  final String email;

  @override
  bool operator ==(Object other) =>
      other is User && other.id == id && other.email == email;

  @override
  int get hashCode => Object.hash(id, email);
}
