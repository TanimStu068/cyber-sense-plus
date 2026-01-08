import 'package:cyber_sense_plus/core/contants/colors.dart';
import 'package:cyber_sense_plus/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/notes_provider.dart';
import 'add_edit_note_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatelessWidget {
  final NoteModel note;

  const NoteDetailScreen({super.key, required this.note});

  void _deleteNote(BuildContext context) async {
    final provider = Provider.of<NotesProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundDark,
        title: Text(
          "Delete Note",
          style: GoogleFonts.montserrat(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this note?",
          style: GoogleFonts.montserrat(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              "Cancel",
              style: GoogleFonts.montserrat(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.deleteNote(note.id);
              Navigator.pop(ctx, true);
            },
            child: Text(
              "Delete",
              style: GoogleFonts.montserrat(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    // Replace this part:
    if (confirmed ?? false) {
      await provider.deleteNote(note.id); // ✅ use await here
      Navigator.pop(context);
    }
  }

  void _editNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditNoteScreen(note: note)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format the dates at the start of build
    final formattedCreated = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(note.createdAt);
    final formattedUpdated = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(note.updatedAt);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        title: Text(
          "Note Details",
          style: GoogleFonts.montserrat(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _editNote(context),
            icon: const Icon(Icons.edit, color: Colors.cyanAccent),
          ),
          IconButton(
            onPressed: () => _deleteNote(context),
            icon: const Icon(Icons.delete, color: Colors.redAccent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note Title
            Text(
              note.title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),

            // Date & Time
            Text(
              "Created: $formattedCreated",
              style: GoogleFonts.montserrat(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
            Text(
              "Updated: $formattedUpdated",
              style: GoogleFonts.montserrat(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),

            // Note Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                note.content,
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
