import 'package:equatable/equatable.dart';

class PhotoResponse with EquatableMixin {
  final String id;
  final String wordTypeId;
  final String originalUrl;
  final String? createdBy;
  final String createdAt;

  PhotoResponse({
    required this.id,
    required this.wordTypeId,
    required this.originalUrl,
    required this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    wordTypeId,
    originalUrl,
    createdBy,
    createdAt,
  ];

  factory PhotoResponse.fromJson(Map<String, dynamic> json) {
    return PhotoResponse(
      id: json['id'] as String,
      wordTypeId: json['word_type_id'] as String,
      originalUrl: json['original_url'] as String,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}
