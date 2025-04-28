class Invoice {
  final String? id;

  final String? clientId;
  final String? clientName;
  final String? description;
  final double? amount;
  final DateTime createdAt;
  final String? status;
  final DateTime? dueDate;
  final String? notes;
  final String? userId;

  Invoice({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.description,
    required this.amount,
    required this.createdAt,
    this.status,
    this.dueDate,
    this.notes,
    this.userId,
  });

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] as String?,
      clientId: map['client_id'] as String?,
      // Get client name from joined clients table or fallback to client_name
      clientName:
          map['clients'] != null
              ? (map['clients']['name'] as String?)
              : map['client_name'] as String?,
      description: map['description'] as String?,
      // Use 'total_amount' if present, otherwise fallback to 'amount'
      amount:
          map['total_amount'] != null
              ? (map['total_amount'] as num).toDouble()
              : (map['amount'] != null
                  ? (map['amount'] as num).toDouble()
                  : 0.0),
      createdAt:
          map['created_at'] != null
              ? DateTime.parse(map['created_at'] as String)
              : DateTime.now(),
      status: map['status'] as String?,
      dueDate:
          map['due_date'] != null ? DateTime.tryParse(map['due_date']) : null,
      notes: map['notes'] as String?,
      userId: map['user_id'] as String?,
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
      'status': status,
      'due_date': dueDate?.toIso8601String(),
      'notes': notes,
      'user_id': userId,
    };
  }
}
