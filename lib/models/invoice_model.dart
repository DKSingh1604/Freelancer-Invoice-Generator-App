class Invoice {
  final String id;
  final String clientId;
  final String clientName;
  final String description;
  final double amount;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.description,
    required this.amount,
    required this.createdAt,
  });

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] as String,
      clientId: map['client_id'] as String,
      clientName: map['client_name'] as String,
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'client_name': clientName,
      'description': description,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
