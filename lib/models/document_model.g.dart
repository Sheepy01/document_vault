// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentModelAdapter extends TypeAdapter<DocumentModel> {
  @override
  final int typeId = 0;

  @override
  DocumentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentModel(
      id: fields[0] as String,
      title: fields[1] as String,
      documentType: fields[2] as DocumentType,
      filePath: fields[3] as String,
      isImage: fields[4] as bool,
      createdAt: fields[5] as DateTime,
      thumbnailPath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DocumentModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.documentType)
      ..writeByte(3)
      ..write(obj.filePath)
      ..writeByte(4)
      ..write(obj.isImage)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.thumbnailPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentTypeAdapter extends TypeAdapter<DocumentType> {
  @override
  final int typeId = 1;

  @override
  DocumentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DocumentType.drivingLicense;
      case 1:
        return DocumentType.passport;
      case 2:
        return DocumentType.aadhaar;
      case 3:
        return DocumentType.pan;
      case 4:
        return DocumentType.voterId;
      case 5:
        return DocumentType.other;
      default:
        return DocumentType.drivingLicense;
    }
  }

  @override
  void write(BinaryWriter writer, DocumentType obj) {
    switch (obj) {
      case DocumentType.drivingLicense:
        writer.writeByte(0);
        break;
      case DocumentType.passport:
        writer.writeByte(1);
        break;
      case DocumentType.aadhaar:
        writer.writeByte(2);
        break;
      case DocumentType.pan:
        writer.writeByte(3);
        break;
      case DocumentType.voterId:
        writer.writeByte(4);
        break;
      case DocumentType.other:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
