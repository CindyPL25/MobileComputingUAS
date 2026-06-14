# E-Library Kampus Mobile Foundation

Project ini adalah fondasi Flutter untuk aplikasi mobile E-Library Kampus.

Fokus tahap ini:
- Setup project Flutter baru.
- Menyiapkan arsitektur scalable.
- Menyiapkan mode mock data saat ini.
- Menyiapkan jalur migrasi ke REST API tanpa perubahan besar pada UI di masa depan.
- Menyiapkan permission kamera untuk QR Scanner di Android dan iOS.

Tidak termasuk tahap ini:
- UI halaman.
- Implementasi endpoint API.
- Integrasi fitur end-to-end.

## 1. Ringkasan Arsitektur

Arsitektur yang dipakai: feature-first + clean layering ringan.

Setiap fitur dibagi ke:
- domain: entity dan kontrak repository (stabil, independen dari sumber data).
- data: datasource dan repository implementation.
- application: use case untuk orkestrasi logic per fitur.

Keuntungan:
- Saat ini bisa pakai mock datasource.
- Nanti tinggal aktifkan remote datasource untuk REST API.
- UI tidak perlu tahu sumber data berasal dari mock atau API.

## 2. Struktur Folder

Berikut struktur utama yang disiapkan:

```text
lib/
	app/
		app_entry.dart
		providers.dart
	core/
		config/
			app_environment.dart
		constants/
			app_constants.dart
		errors/
			failures.dart
		network/
			network_client.dart
	shared/
		models/
		services/
	features/
		auth/
			application/usecases/
				sign_in_usecase.dart
			data/
				datasources/
					auth_data_source.dart
					auth_mock_data_source.dart
					auth_remote_data_source.dart
				repositories/
					auth_repository_impl.dart
			domain/
				entities/
					app_user.dart
				repositories/
					auth_repository.dart
		catalog/
			application/usecases/
				get_catalog_books_usecase.dart
			data/
				datasources/
					catalog_data_source.dart
					catalog_mock_data_source.dart
					catalog_remote_data_source.dart
				repositories/
					catalog_repository_impl.dart
			domain/
				entities/
					book.dart
				repositories/
					catalog_repository.dart
		borrowing/
			domain/entities/borrowing_transaction.dart
			domain/repositories/borrowing_repository.dart
			data/datasources/borrowing_data_source.dart
		history/
			domain/entities/history_item.dart
			domain/repositories/history_repository.dart
		profile/
			domain/entities/user_profile.dart
			domain/repositories/profile_repository.dart
assets/
	mock_data/
		books.json
```

## 3. Fungsi Setiap Folder dan File Kunci

- lib/main.dart
	Entry point aplikasi, inisialisasi ProviderScope.

- lib/app/app_entry.dart
	Root widget non-UI untuk tahap setup awal.

- lib/app/providers.dart
	Dependency wiring Riverpod.
	Tempat switch mode mock/api berdasarkan environment.

- lib/core/config/app_environment.dart
	Membaca APP_DATA_SOURCE dan API_BASE_URL dari dart-define.

- lib/core/network/network_client.dart
	Konfigurasi Dio client untuk komunikasi REST API nanti.

- lib/core/errors/failures.dart
	Definisi error dasar untuk layer data/domain.

- lib/features/*/domain
	Kontrak bisnis yang seharusnya paling stabil.

- lib/features/*/data
	Implementasi akses data mock atau remote.

- lib/features/*/application
	Use case yang akan dipanggil oleh layer UI nanti.

- assets/mock_data
	Menyimpan dummy data untuk development awal.

## 4. Dependency yang Disiapkan

- flutter_riverpod: dependency injection dan state management.
- dio: HTTP client untuk REST API.
- equatable: perbandingan object entity.
- flutter_secure_storage: simpan token aman.
- shared_preferences: simpan preference ringan.
- mobile_scanner: scan QR berbasis kamera.
- build_runner, json_serializable, freezed: siap untuk model immutable dan serialization saat API aktif.

## 5. Mekanisme Mock ke REST API

Switch sumber data dilakukan dari environment:

- Mode mock (default)
	APP_DATA_SOURCE=mock

- Mode API (nanti)
	APP_DATA_SOURCE=api

Jalankan mode mock:

```bash
flutter run --dart-define=APP_DATA_SOURCE=mock
```

Jalankan mode API (nanti, setelah endpoint siap):

```bash
flutter run --dart-define=APP_DATA_SOURCE=api --dart-define=API_BASE_URL=http://10.0.2.2/mobilecomputinguas-api
```

Catatan:
- 10.0.2.2 digunakan Android emulator untuk akses localhost mesin host.
- Untuk device fisik, ganti API_BASE_URL ke IP lokal komputer.

## 6. Konfigurasi QR Scanner

Android:
- File: android/app/src/main/AndroidManifest.xml
- Ditambahkan:
	- android.permission.CAMERA
	- android.hardware.camera feature

iOS:
- File: ios/Runner/Info.plist
- Ditambahkan:
	- NSCameraUsageDescription

## 7. Langkah Lanjutan yang Direkomendasikan

1. Finalisasi kontrak endpoint API di backend PHP (auth, catalog, borrow/return QR, history, profile).
2. Tambahkan DTO model per fitur (json_serializable/freezed).
3. Implementasi remote datasource berdasarkan kontrak API.
4. Tambahkan repository dan use case untuk borrowing, history, profile yang saat ini masih skeleton.
5. Setelah data layer stabil, baru mulai bangun UI per fitur.

