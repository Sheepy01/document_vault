import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:document_vault/services/storage_service.dart';
import 'package:document_vault/screens/add_document_screen.dart';
import 'package:document_vault/screens/document_viewer_screen.dart';
import 'package:document_vault/widgets/document_card.dart';
import 'package:document_vault/models/document_model.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;
  
  const HomeScreen({super.key, required this.storageService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _searchFocusNode.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: _buildDocumentList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAddDocument(),
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Document',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Document Vault',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E3A8A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder(
                valueListenable: widget.storageService.boxListenable,
                builder: (context, box, child) {
                  final documentBox = box as Box<DocumentModel>;
                  return Text(
                    '${documentBox.length} document${documentBox.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF1E3A8A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _isSearching = value.isNotEmpty;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search documents...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: _isSearching ? const Color(0xFF1E3A8A) : Colors.grey[400],
            ),
            suffixIcon: _isSearching
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _isSearching = false;
                      });
                      _searchFocusNode.unfocus();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    return ValueListenableBuilder(
      valueListenable: widget.storageService.boxListenable,
      builder: (context, box, child) {
        final documents = widget.storageService.searchDocuments(_searchQuery);
        
        if (documents.isEmpty) {
          return _buildEmptyState();
        }
        
        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Slidable(
                      key: ValueKey(document.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.2,
                        children: [
                          CustomSlidableAction(
                            onPressed: (context) => _deleteDocument(document.id),
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 24),
                                SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                      child: DocumentCard(
                        document: document,
                        onTap: () => _navigateToViewer(document),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 60,
              color: const Color(0xFF1E3A8A).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Documents Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first document',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _deleteDocument(String id) {
    widget.storageService.deleteDocument(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Document deleted'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
    );
  }

  void _navigateToAddDocument() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDocumentScreen(storageService: widget.storageService),
      ),
    );
    
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Document added successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  void _navigateToViewer(DocumentModel document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentViewerScreen(
          storageService: widget.storageService,
          document: document,
        ),
      ),
    );
  }
}