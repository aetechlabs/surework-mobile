enum GigStatus {
  created,
  funded,
  submitted,
  completed,
  disputed,
  cancelled,
  refunded,
}

class Gig {
  final String id;
  final int? blockchainGigId;
  final String clientId;
  final String freelancerId;
  final String title;
  final String description;
  final String category;
  final List<String> skills;
  final double amount;
  final String paymentToken;
  final String currency;
  final DateTime deadline;
  final GigStatus status;
  final String? txHash;
  final DateTime? fundedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related data (from includes)
  final Map<String, dynamic>? client;
  final Map<String, dynamic>? freelancer;

  Gig({
    required this.id,
    this.blockchainGigId,
    required this.clientId,
    required this.freelancerId,
    required this.title,
    required this.description,
    required this.category,
    required this.skills,
    required this.amount,
    required this.paymentToken,
    required this.currency,
    required this.deadline,
    required this.status,
    this.txHash,
    this.fundedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.client,
    this.freelancer,
  });

  factory Gig.fromJson(Map<String, dynamic> json) {
    return Gig(
      id: json['id'],
      blockchainGigId: json['blockchainGigId'],
      clientId: json['clientId'],
      freelancerId: json['freelancerId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      skills: List<String>.from(json['skills'] ?? []),
      amount: double.parse(json['amount'].toString()),
      paymentToken: json['paymentToken'],
      currency: json['currency'],
      deadline: DateTime.parse(json['deadline']),
      status: _parseStatus(json['status']),
      txHash: json['txHash'],
      fundedAt: json['fundedAt'] != null ? DateTime.parse(json['fundedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      client: json['client'],
      freelancer: json['freelancer'],
    );
  }

  static GigStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'CREATED':
        return GigStatus.created;
      case 'FUNDED':
        return GigStatus.funded;
      case 'SUBMITTED':
        return GigStatus.submitted;
      case 'COMPLETED':
        return GigStatus.completed;
      case 'DISPUTED':
        return GigStatus.disputed;
      case 'CANCELLED':
        return GigStatus.cancelled;
      case 'REFUNDED':
        return GigStatus.refunded;
      default:
        return GigStatus.created;
    }
  }

  String get statusString {
    switch (status) {
      case GigStatus.created:
        return 'Created';
      case GigStatus.funded:
        return 'Funded';
      case GigStatus.submitted:
        return 'Submitted';
      case GigStatus.completed:
        return 'Completed';
      case GigStatus.disputed:
        return 'Disputed';
      case GigStatus.cancelled:
        return 'Cancelled';
      case GigStatus.refunded:
        return 'Refunded';
    }
  }
}
