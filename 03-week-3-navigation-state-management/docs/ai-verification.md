# AI Output Verification

## 1. Tujuan

AI digunakan untuk membantu membuat fitur Statistics yang menggunakan asynchronous state dengan Riverpod.

Hasil dari AI kemudian diperiksa kembali dan disesuaikan dengan kebutuhan Jobsheet 3.

## 2. Hal yang Diverifikasi

### Provider

Statistics menggunakan `AsyncNotifier` dan `AsyncNotifierProvider`.

```dart
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<String>>(
  StatsNotifier.new,
);
```

Provider hanya dibuat satu kali dan digunakan oleh `StatsPage`.

### Loading State

Saat data sedang diambil, aplikasi menampilkan `CircularProgressIndicator`.

```dart
loading: () {
  return const Center(
    child: CircularProgressIndicator(),
  );
},
```

### Success State

Jika proses berhasil, data ditampilkan menggunakan `ListView`.

```dart
data: (stats) {
  return ListView.builder(
    itemCount: stats.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(stats[index]),
      );
    },
  );
},
```

### Error State

Jika terjadi kesalahan, aplikasi menampilkan pesan error dan tombol Retry.

```dart
error: (error, stackTrace) {
  return Center(
    child: FilledButton.icon(
      onPressed: () {
        ref.invalidate(statsProvider);
      },
      icon: const Icon(Icons.refresh),
      label: const Text('Retry'),
    ),
  );
},
```

### Retry

Retry dilakukan dengan melakukan invalidate terhadap provider.

```dart
ref.invalidate(statsProvider);
```

Dengan cara ini provider akan dijalankan kembali.

## 3. Riverpod State

Pada fitur ToDo, state tidak diubah secara langsung menggunakan `state.add()`.

State diganti dengan list baru.

Contohnya:

```dart
state = [
  ...state,
  Todo(title),
];
```

Cara ini menjaga state tetap immutable.

## 4. ref.watch dan ref.read

`ref.watch` digunakan ketika widget perlu mengikuti perubahan state.

```dart
final todos = ref.watch(todoListProvider);
```

Sedangkan `ref.read` digunakan ketika memanggil method dari notifier melalui event seperti tombol, checkbox, atau delete.

```dart
ref
    .read(todoListProvider.notifier)
    .toggle(index);
```

## 5. Refactoring

Bagian item ToDo dipisahkan menjadi widget `TodoTile`.

Tujuannya supaya `TodoPage` tidak terlalu banyak berisi kode UI untuk satu item.

Selain itu dibuat derived provider:

```dart
final unfinishedTodoProvider =
    Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);

  return todos
      .where((todo) => !todo.done)
      .toList();
});
```

Provider tersebut digunakan untuk mendapatkan daftar task yang belum selesai.

## 6. Testing

Testing dilakukan menggunakan Flutter Test.

Perintah yang digunakan:

```bash
flutter analyze
flutter test
```

Hasil akhir:

* Tidak terdapat analyzer error.
* Widget test berhasil dijalankan.
* Provider test berhasil dijalankan.

## 7. Kesimpulan

AI membantu mempercepat proses pembuatan fitur, tetapi hasilnya tetap diperiksa secara manual.

Hal yang diperiksa meliputi penggunaan Riverpod, immutable state, loading/error/success state, retry, struktur kode, dan testing.
