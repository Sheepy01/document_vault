import 'package:hive_flutter/hive_flutter.dart';

part 'document_model.g.dart';

/// ---------------- ENUM ----------------
@HiveType(typeId: 1)
enum DocumentType {
  @HiveField(0)
  drivingLicense,

  @HiveField(1)
  passport,

  @HiveField(2)
  aadhaar,

  @HiveField(3)
  pan,

  @HiveField(4)
  voterId,

  @HiveField(5)
  other,
}

/// ---------------- EXTENSION (for display names) ----------------
extension DocumentTypeExtension on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.drivingLicense:
        return 'Driving License';
      case DocumentType.passport:
        return 'Passport';
      case DocumentType.aadhaar:
        return 'Aadhaar Card';
      case DocumentType.pan:
        return 'PAN Card';
      case DocumentType.voterId:
        return 'Voter ID';
      case DocumentType.other:
        return 'Other';
    }
  }
}

/// ---------------- MODEL ----------------
@HiveType(typeId: 0)
class DocumentModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DocumentType documentType; // ✅ store enum directly

  @HiveField(3)
  final String filePath;

  @HiveField(4)
  final bool isImage;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  String? thumbnailPath;

  DocumentModel({
    required this.id,
    required this.title,
    required this.documentType,
    required this.filePath,
    required this.isImage,
    required this.createdAt,
    this.thumbnailPath,
  });
}