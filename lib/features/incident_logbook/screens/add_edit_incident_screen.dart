import 'package:cyber_sense_plus/models/incident_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_provider.dart';

class AddEditIncidentScreen extends StatefulWidget {
  final Incident? incident; // <-- optional for editing

  const AddEditIncidentScreen({super.key, this.incident});
  @override
  State<AddEditIncidentScreen> createState() => _AddEditIncidentScreenState();
}

class _AddEditIncidentScreenState extends State<AddEditIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();
  String _severity = 'Low';
  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.greenAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF1F2233),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0A0E21),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _isSaving = false;

  Future<void> _saveIncident() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final incidentProvider = Provider.of<IncidentProvider>(
        context,
        listen: false,
      );

      final formattedDate =
          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";

      if (widget.incident == null) {
        // Add new incident
        await incidentProvider.addIncident(
          title: _titleController.text.trim(),
          category: _categoryController.text.trim(),
          severity: _severity,
          date: formattedDate,
          notes: _notesController.text.trim(),
        );
      } else {
        // Update existing incident
        final updatedIncident = Incident(
          id: widget.incident!.id,
          title: _titleController.text.trim(),
          category: _categoryController.text.trim(),
          severity: _severity,
          date: formattedDate,
          notes: _notesController.text.trim(),
        );

        await incidentProvider.updateIncident(
          widget.incident!.id,
          updatedIncident,
        );
      }

      setState(() {
        _isSaving = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.incident != null) {
      _titleController.text = widget.incident!.title;
      _categoryController.text = widget.incident!.category;
      _notesController.text = widget.incident!.notes;
      _severity = widget.incident!.severity;
      _selectedDate = DateTime.parse(
        widget.incident!.date,
      ); // or parse your format
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text("Add Incident"),
        backgroundColor: const Color(0xFF1F2233),
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: "Title",
                icon: Icons.title,
                hint: "Enter incident title",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _categoryController,
                label: "Category",
                icon: Icons.category,
                hint: "Enter incident category",
              ),
              const SizedBox(height: 16),
              // Severity Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2233),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: _severity,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Severity",
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  dropdownColor: const Color(0xFF1F2233),
                  style: const TextStyle(color: Colors.white),
                  items: ['Low', 'Medium', 'High']
                      .map(
                        (level) =>
                            DropdownMenuItem(value: level, child: Text(level)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _severity = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Date Picker
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2233),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.greenAccent,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _notesController,
                label: "Notes",
                icon: Icons.note,
                hint: "Additional information",
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveIncident,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        widget.incident == null
                            ? "Save Incident"
                            : "Update Incident",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.greenAccent),
        filled: true,
        fillColor: const Color(0xFF1F2233),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }
}
