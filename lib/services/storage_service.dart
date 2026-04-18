import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/document_model.dart';

class StorageService {
  static const String _boxName = 'documentsBox';
  static const String _filesDir = 'document_files';
  static const String _thumbnailsDir = 'thumbnails';
  
  late Box<DocumentModel> _box;
  late Directory _filesDirectory;
  late Directory _thumbnailsDirectory;

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    _filesDirectory = Directory('${appDir.path}/$_filesDir');
    _thumbnailsDirectory = Directory('${appDir.path}/$_thumbnailsDir');
    
    if (!await _filesDirectory.exists()) {
      await _filesDirectory.create(recursive: true);
    }
    if (!await _thumbnailsDirectory.exists()) {
      await _thumbnailsDirectory.create(recursive: true);
    }
    
    _box = await Hive.openBox<DocumentModel>(_boxName);
  }

  Box<DocumentModel> get box => _box;
  ValueListenable<Box<DocumentModel>> get boxListenable => _box.listenable();
  Directory get filesDir => _filesDirectory;
  Directory get thumbnailsDir => _thumbnailsDirectory;

  Future<DocumentModel> saveDocument({
    required String title,
    required DocumentType documentType,
    required File sourceFile,
    required bool isImage,
  }) async {
    final id = const Uuid().v4();
    final extension = sourceFile.path.split('.').last;
    final fileName = '$id.$extension';
    final destinationPath = '${_filesDirectory.path}/$fileName';
    
    await sourceFile.copy(destinationPath);
    
    String? thumbnailPath;
    if (isImage) {
      thumbnailPath = destinationPath; // Use the image itself as thumbnail
    } else {
      // For PDF, thumbnail stays null (we'll show PDF icon)
    }
    
    final document = DocumentModel(
      id: id,
      title: title,
      documentType: documentType,
      filePath: destinationPath,
      isImage: isImage,
      createdAt: DateTime.now(),
      thumbnailPath: thumbnailPath,
    );
    
    await _box.put(id, document);
    return document;
  }

  Future<void> deleteDocument(String id) async {
    final doc = _box.get(id);
    if (doc != null) {
      final file = File(doc.filePath);
      if (await file.exists()) {
        await file.delete();
      }
      if (doc.thumbnailPath != null && doc.thumbnailPath != doc.filePath) {
        final thumbFile = File(doc.thumbnailPath!);
        if (await thumbFile.exists()) {
          await thumbFile.delete();
        }
      }
      await _box.delete(id);
    }
  }

  List<DocumentModel> getAllDocuments() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<DocumentModel> searchDocuments(String query) {
    if (query.isEmpty) return getAllDocuments();
    return _box.values.where((doc) {
      return doc.title.toLowerCase().contains(query.toLowerCase()) ||
             doc.documentType.displayName.toLowerCase().contains(query.toLowerCase());
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}