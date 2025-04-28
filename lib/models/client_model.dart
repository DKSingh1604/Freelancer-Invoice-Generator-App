class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? company;
  final String? userId; //not to be shown on client's details page
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? gstNumber;
  final String? website;
  final String? notes;
  final String? contactPerson;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.company,
    this.userId,
    this.gstNumber,
    this.website,
    this.notes,
    this.contactPerson,
    this.country,
    this.state,
    this.city,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String?,
      company: map['company'] as String?,
      userId: map['user_id'] as String?,
      gstNumber: map['gst_number'] as String?,
      website: map['website'] as String?,
      notes: map['notes'] as String?,
      contactPerson: map['contact_person'] as String?,
      country: map['country'] as String?,
      state: map['state'] as String?,
      city: map['city'] as String?,
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
      'user_id': userId,
      'gst_number': gstNumber,
      'website': website,
      'notes': notes,
      'contact_person': contactPerson,
      'country': country,
      'state': state,
      'city': city,
    };
  }
}
