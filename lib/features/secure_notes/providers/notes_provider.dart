import 'package:cyber_sense_plus/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NotesProvider extends ChangeNotifier {
  late Box<NoteModel> _notesBox;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  List<NoteModel> get notes => _notesBox.values.toList();

  Future<void> init() async {
    _notesBox = Hive.box<NoteModel>('notesBox');
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addNote(NoteModel note) async {
    await _notesBox.put(note.id, note);
    notifyListeners();
  }

  Future<void> updateNote(NoteModel note) async {
    if (_notesBox.containsKey(note.id)) {
      await _notesBox.put(note.id, note);
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
    notifyListeners();
  }

  NoteModel? getNoteById(String id) => _notesBox.get(id);

  List<NoteModel> searchNotes(String query) {
    return _notesBox.values
        .where(
          (note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Future<void> clearNotes() async {
    await _notesBox.clear();
    notifyListeners();
  }
}
