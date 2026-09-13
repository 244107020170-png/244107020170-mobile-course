# Week 3 - Navigation & State Management

Project praktikum Week 3 untuk mata kuliah Mobile Programming.

Pada jobsheet ini saya mempelajari penggunaan **GoRouter** untuk navigation dan **Riverpod** untuk state management pada aplikasi Flutter.

Project akhirnya berupa aplikasi ToDo sederhana yang memiliki halaman ToDo dan Statistics.

---

## Fitur Aplikasi

### 1. ToDo

Halaman ToDo digunakan untuk mengelola daftar tugas.

Fitur yang tersedia:

* Menambahkan task baru
* Menandai task sebagai selesai
* Menghapus task
* Menampilkan task yang sudah selesai dengan efek coret

### 2. Statistics

Halaman Statistics digunakan untuk menampilkan data statistik yang diperoleh secara asynchronous.

Fitur yang tersedia:

* Loading indicator
* Menampilkan data ketika berhasil
* Menampilkan error ketika proses gagal
* Tombol Retry untuk mencoba kembali

### Navigation

Aplikasi menggunakan GoRouter dengan beberapa route:

```text
/              → ToDo
/stats         → Statistics
/detail/:id    → Detail
```

Route detail menggunakan path parameter.

Contoh:

```text
/detail/5
```

akan membuka detail untuk item dengan ID `5`.

---

## Teknologi yang Digunakan

* Flutter
* Dart
* GoRouter
* Riverpod
* AsyncNotifier
* AsyncValue
* Material 3
* Flutter Test

---

## Struktur Project

```text
03-week-3-navigation-state-management/
│
├── lib/
│   ├── main.dart
│   │
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── detail_page.dart
│   │   ├── todo_page.dart
│   │   └── stats_page.dart
│   │
│   ├── providers/
│   │   ├── todo_provider.dart
│   │   └── stats_provider.dart
│   │
│   └── widgets/
│       └── todo_tile.dart
│
├── test/
│   ├── widget_test.dart
│   └── stats_provider_test.dart
│
├── docs/
│   ├── ai-prompt.md
│   └── ai-verification.md
│
├── screenshots/
│
├── README.md
└── pubspec.yaml
```

---

## GoRouter

GoRouter digunakan untuk mengatur perpindahan halaman.

Route utama yang digunakan:

```dart
GoRoute(
  path: '/stats',
  builder: (context, state) {
    return const StatsPage();
  },
),
```

Untuk detail, digunakan path parameter:

```text
/detail/:id
```

Nilai `id` kemudian diambil menggunakan:

```dart
state.pathParameters['id']
```

GoRouter juga digunakan bersama `NavigationBar` untuk berpindah antara halaman ToDo dan Statistics.

---

## Riverpod

Riverpod digunakan untuk menyimpan dan mengelola state ToDo.

Provider utama:

```dart
final todoListProvider =
    NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
);
```

`TodoListNotifier` memiliki beberapa method:

* `add()`
* `toggle()`
* `remove()`

State diubah secara immutable.

Contohnya:

```dart
state = [
  ...state,
  Todo(title),
];
```

Tidak digunakan perubahan langsung seperti:

```dart
state.add(...)
```

---

## ref.watch dan ref.read

`ref.watch` digunakan ketika UI perlu mengikuti perubahan state.

```dart
final todos = ref.watch(todoListProvider);
```

Sedangkan `ref.read` digunakan ketika memanggil method notifier dari event seperti button atau checkbox.

```dart
ref
    .read(todoListProvider.notifier)
    .toggle(index);
```

Dengan demikian, UI akan otomatis melakukan rebuild ketika state berubah.

---

## AsyncValue

Halaman Statistics menggunakan `AsyncNotifier` untuk mensimulasikan proses mengambil data.

Proses tersebut memiliki delay sehingga terdapat kondisi:

```text
Loading
   ↓
Success
```

atau:

```text
Loading
   ↓
Error
   ↓
Retry
```

UI menangani ketiga kondisi tersebut menggunakan:

```dart
statsAsync.when(
  loading: ...,
  error: ...,
  data: ...,
);
```

Dengan cara ini kondisi asynchronous dapat ditangani dengan lebih jelas.

---

## AI Challenge

Pada bagian AI Challenge, AI digunakan untuk membantu membuat fitur Statistics.

Requirement yang digunakan:

* `ConsumerWidget`
* `AsyncNotifierProvider`
* delay 2 detik
* sekitar 30% kemungkinan error
* loading state
* error state
* retry button
* success state
* tiga data statistik
* testing

Prompt yang digunakan dan proses verifikasi hasil AI disimpan di:

```text
docs/ai-prompt.md
docs/ai-verification.md
```

Hasil AI tetap diperiksa dan disesuaikan sebelum digunakan.

---

## Testing

Project memiliki widget test dan provider test.

Widget test digunakan untuk memastikan user dapat menambahkan task baru.

Alur yang diuji:

1. Membuka aplikasi
2. Memastikan belum ada task
3. Menekan tombol Add
4. Mengisi task
5. Menekan tombol Add
6. Memastikan task berhasil ditampilkan

Testing dijalankan menggunakan:

```bash
flutter test
```

Static analysis dijalankan menggunakan:

```bash
flutter analyze
```

---

## Cara Menjalankan Project

Pastikan Flutter sudah terinstall.

Kemudian jalankan:

```bash
flutter pub get
```

Untuk mengecek kode:

```bash
flutter analyze
```

Untuk menjalankan test:

```bash
flutter test
```

Untuk menjalankan aplikasi:

```bash
flutter run
```

Atau jika menggunakan Chrome:

```bash
flutter run -d chrome
```

---

## Dokumentasi

Screenshot hasil praktikum disimpan di folder:

```text
screenshots/
```

Screenshot digunakan sebagai bukti bahwa fitur yang dibuat dapat berjalan sesuai requirement.

---

## Refleksi

Pada jobsheet ini saya belajar bahwa `setState` masih cukup digunakan untuk state yang sederhana dan hanya dibutuhkan oleh satu widget.

Namun, ketika state perlu digunakan oleh beberapa bagian aplikasi, state management seperti Riverpod dapat membuat kode lebih terstruktur.

Saya juga belajar bahwa `ref.watch` digunakan ketika widget perlu mengikuti perubahan state, sedangkan `ref.read` digunakan untuk melakukan aksi terhadap provider.

Selain itu, penggunaan `AsyncValue` membantu menangani proses asynchronous karena kondisi loading, error, dan data dapat ditangani secara jelas.

Pada bagian AI Challenge, saya belajar bahwa kode yang dihasilkan AI tetap perlu diperiksa. Tidak semua kode sebaiknya langsung digunakan tanpa memahami cara kerjanya.

---

## Kesimpulan

Jobsheet 3 memberikan pengalaman menggunakan navigation dan state management pada Flutter.

Hasil akhirnya adalah aplikasi ToDo sederhana dengan:

* GoRouter
* path parameter
* Riverpod
* Notifier
* AsyncNotifier
* AsyncValue
* NavigationBar
* widget testing
* provider testing

Project ini juga menjadi latihan untuk memahami penggunaan AI dalam proses pengembangan software sekaligus melakukan verifikasi terhadap hasil yang diberikan AI.
