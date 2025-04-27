class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? company;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.company,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String?,
      company: map['company'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'company': company,
    };
  }
}
