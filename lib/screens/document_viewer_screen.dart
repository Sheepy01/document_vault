import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:document_vault/models/document_model.dart';
import 'package:document_vault/services/storage_service.dart';
import 'package:intl/intl.dart';

class DocumentViewerScreen extends StatelessWidget {
  final StorageService storageService;
  final DocumentModel document;

  const DocumentViewerScreen({
    super.key,
    required this.storageService,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
          ),
        ),
        title: Column(
          children: [
            Text(
              document.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              DateFormat('MMM d, yyyy').format(document.createdAt),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Share functionality can be added here
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: document.isImage ? _buildImageViewer() : _buildPdfViewer(),
    );
  }

  Widget _buildImageViewer() {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Image.file(
          File(document.filePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    return PdfView(
      controller: PdfController(
        document: PdfDocument.openFile(document.filePath),
      ),
    );
  }
}