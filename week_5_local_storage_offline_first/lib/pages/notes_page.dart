import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepository(),
);

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(
  NotesNotifier.new,
);

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    final repository = ref.read(noteRepositoryProvider);
    return repository.fetchNotes();
  }

  Future<void> addNote({required String title, String body = ''}) async {
    final repository = ref.read(noteRepositoryProvider);

    await repository.addNote(title: title, body: body);

    final updatedNotes = await repository.fetchNotes();

    state = AsyncData(updatedNotes);
  }

  Future<void> deleteNote(int id) async {
    final repository = ref.read(noteRepositoryProvider);

    await repository.deleteNote(id);

    final updatedNotes = await repository.fetchNotes();

    state = AsyncData(updatedNotes);
  }

  Future<void> refreshNotes() async {
    final repository = ref.read(noteRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(repository.fetchNotes);
  }
}

final dirtyCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.read(noteRepositoryProvider);

  return repository.countDirty();
});

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final dirtyCount = ref.watch(dirtyCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          dirtyCount.when(
            data: (count) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Badge(
                    label: Text('$count'),
                    child: const Icon(Icons.cloud_upload_outlined),
                  ),
                ),
              );
            },
            loading: () {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            error: (_, _) {
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: notes.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No notes yet. Add your first note!'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(notesProvider.notifier).refreshNotes();

              ref.invalidate(dirtyCountProvider);
            },
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final note = items[index];

                return ListTile(
                  leading: Icon(
                    note.dirty
                        ? Icons.cloud_upload_outlined
                        : Icons.note_outlined,
                  ),
                  title: Text(note.title),
                  subtitle: Text(note.body.isEmpty ? 'No content' : note.body),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final noteId = note.id;

                      if (noteId == null) return;

                      await ref.read(notesProvider.notifier).deleteNote(noteId);

                      ref.invalidate(dirtyCountProvider);
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddNoteDialog(BuildContext context, WidgetRef ref) async {
    // Variabel biasa, bukan TextEditingController.
    // Jadi tidak ada controller yang perlu di-dispose.
    String title = '';
    String body = '';

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  hintText: 'Enter note content',
                ),
                onChanged: (value) {
                  body = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final cleanTitle = title.trim();
                final cleanBody = body.trim();

                if (cleanTitle.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext)
                    .pop({'title': cleanTitle, 'body': cleanBody});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    // Kalau user Cancel, selesai.
    if (result == null) {
      return;
    }

    final savedTitle = result['title'] ?? '';
    final savedBody = result['body'] ?? '';

    if (savedTitle.isEmpty) {
      return;
    }

    // Dialog sudah selesai.
    // Sekarang baru simpan ke SQLite.
    await ref
        .read(notesProvider.notifier)
        .addNote(title: savedTitle, body: savedBody);

    // Update jumlah note dirty.
    ref.invalidate(dirtyCountProvider);
  }
}
