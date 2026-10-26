import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final List<int> colorOptions = [
    0xFFFFFFFF, // putih
    0xFFFFF59D, // kuning
    0xFFFFCCBC, // oranye muda
    0xFFF8BBD0, // pink
    0xFFC8E6C9, // hijau
    0xFFBBDEFB, // biru
  ];
  int selectedColor = Note.defaultColor;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      selectedColor = widget.note!.color;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final db = DatabaseHelper.instance;
      final newNote = Note(
        id: widget.note?.id,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        createdAt: widget.note?.createdAt ?? DateTime.now().toIso8601String(),
        color: selectedColor,
      );

      if (widget.note == null) {
        await db.insert(newNote);
      } else {
        await db.update(newNote);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Judul tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Isi catatan tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text('Warna catatan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: colorOptions.map((c) {
                  final isSelected = c == selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = c),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.teal : Colors.grey,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.teal)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}