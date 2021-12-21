import 'dart:convert';

class DocumentUser {
  final String displayName;
  final DateTime createDate;
  final String monthlySpending;
  
  DocumentUser({
    required this.displayName,
    required this.createDate,
    required this.monthlySpending,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'createDate': createDate,
      'monthlySpending': monthlySpending,
    };
  }

  factory DocumentUser.fromMap(Map<String, dynamic> map) {
    return DocumentUser(
      displayName: map['displayName'] ?? '',
      createDate: map['createDate'],
      monthlySpending: map['monthlySpending'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentUser.fromJson(String source) =>
      DocumentUser.fromMap(json.decode(source));
}
