import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:cyber_sense_plus/features/password_vault/screens/lock_screen.dart';
import 'package:cyber_sense_plus/features/secure_notes/providers/notes_provider.dart';
import 'package:cyber_sense_plus/models/note_model.dart';
import 'package:cyber_sense_plus/services/vault_security_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_edit_note_screen.dart';
import 'note_detail_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  bool _isUnlocked = false;
  final VaultSecurityService _vaultService = VaultSecurityService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Work',
    'Personal',
    'Ideas',
    'Banking',
    'Health',
    'Other',
  ];

  List<NoteModel> _filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  void _checkPin() async {
    final pinSet = await _vaultService.isPinSet();
    if (!pinSet) {
      final pin = await _showSetPinDialog();
      if (pin != null && pin.length == 6) {
        await _vaultService.setPin(pin);
      }
    }
    setState(() => _isUnlocked = false);
  }

  Future<String?> _showSetPinDialog() async {
    String? pin;
    final controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent, // Transparent for premium style
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF121212), Color(0xFF1E1E2A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔒 Cyber lock icon
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.cyanAccent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Set 6-digit PIN',
                style: GoogleFonts.montserrat(
                  color: Colors.cyanAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              // PIN input
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Enter PIN',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.cyanAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.cyanAccent,
                      width: 2,
                    ),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Save PIN button
              GestureDetector(
                onTap: () {
                  pin = controller.text;
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF8C3EFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Save PIN',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return pin;
  }

  void _unlockVault() {
    setState(() => _isUnlocked = true);
  }

  void _filterNotes({String? query, String? category}) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final searchQuery = query ?? _searchController.text;

    setState(() {
      _filteredNotes = notesProvider.notes.where((note) {
        final matchesSearch =
            note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory =
            (category ?? _selectedCategory) == 'All' ||
            note.category == (category ?? _selectedCategory);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isUnlocked) return LockScreen(onAuthenticated: _unlockVault);

    final notesProvider = Provider.of<NotesProvider>(context);

    if (!notesProvider.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Decide which list to display
    final displayNotes =
        _filteredNotes.isEmpty &&
            _searchController.text.isEmpty &&
            _selectedCategory == 'All'
        ? notesProvider.notes
        : _filteredNotes;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 14, 33, 1),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterNotes(query: value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: AppColors.primaryAccent),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategory = category);
                    _filterNotes(category: category);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.primaryAccent,
                                AppColors.secondaryAccent,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.white12,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.white12,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Notes list
          Expanded(
            child: displayNotes.isEmpty
                ? Center(
                    child: Text(
                      "No notes found",
                      style: GoogleFonts.montserrat(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    itemCount: displayNotes.length,
                    itemBuilder: (context, index) {
                      final note = displayNotes[index];
                      return _buildNoteCard(note, notesProvider);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditNoteScreen()),
          );
        },
        tooltip: "Add New Notes",
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildNoteCard(NoteModel note, NotesProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryAccent.withOpacity(0.3),
              AppColors.secondaryAccent.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content.length > 50
                        ? '${note.content.substring(0, 50)}...'
                        : note.content,
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditNoteScreen(note: note),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, note.id, provider),
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, NotesProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Delete Note",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete this note?",
          style: GoogleFonts.montserrat(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.montserrat(color: Colors.cyanAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.deleteNote(id);
              Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: GoogleFonts.montserrat(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
