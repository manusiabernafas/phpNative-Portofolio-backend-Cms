SET NAMES utf8mb4;
SET time_zone = '+07:00';
DROP DATABASE IF EXISTS `porto_orbit`;
CREATE DATABASE `porto_orbit` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `porto_orbit`;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE login_gagal (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ip VARCHAR(45) NOT NULL,
  waktu DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (ip, waktu)
) ENGINE=InnoDB;

CREATE TABLE pengaturan (
  kunci VARCHAR(50) PRIMARY KEY,
  nilai TEXT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE teknologi (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(60) NOT NULL,
  logo VARCHAR(40) NOT NULL DEFAULT '',
  kategori VARCHAR(40) NOT NULL DEFAULT 'Tools',
  level TINYINT UNSIGNED NOT NULL DEFAULT 70,
  unggulan TINYINT(1) NOT NULL DEFAULT 0,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE proyek (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(150) NOT NULL,
  slug VARCHAR(90) NOT NULL UNIQUE,
  kategori VARCHAR(50) NOT NULL,
  ringkasan VARCHAR(255) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  cover VARCHAR(255) NOT NULL DEFAULT '',
  klien VARCHAR(100) NOT NULL DEFAULT '',
  peran VARCHAR(100) NOT NULL DEFAULT '',
  tahun SMALLINT UNSIGNED NOT NULL,
  durasi VARCHAR(40) NOT NULL DEFAULT '',
  link_demo VARCHAR(255) NOT NULL DEFAULT '',
  link_repo VARCHAR(255) NOT NULL DEFAULT '',
  unggulan TINYINT(1) NOT NULL DEFAULT 0,
  tampil TINYINT(1) NOT NULL DEFAULT 1,
  urutan INT NOT NULL DEFAULT 0,
  dilihat INT UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX (tampil, urutan)
) ENGINE=InnoDB;

CREATE TABLE proyek_gambar (
  id INT AUTO_INCREMENT PRIMARY KEY,
  proyek_id INT NOT NULL,
  file VARCHAR(255) NOT NULL,
  keterangan VARCHAR(150) NOT NULL DEFAULT '',
  urutan INT NOT NULL DEFAULT 0,
  FOREIGN KEY (proyek_id) REFERENCES proyek(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE proyek_teknologi (
  proyek_id INT NOT NULL,
  teknologi_id INT NOT NULL,
  PRIMARY KEY (proyek_id, teknologi_id),
  FOREIGN KEY (proyek_id) REFERENCES proyek(id) ON DELETE CASCADE,
  FOREIGN KEY (teknologi_id) REFERENCES teknologi(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pengalaman (
  id INT AUTO_INCREMENT PRIMARY KEY,
  jenis ENUM('kerja','pendidikan') NOT NULL DEFAULT 'kerja',
  posisi VARCHAR(100) NOT NULL,
  instansi VARCHAR(120) NOT NULL,
  kota VARCHAR(60) NOT NULL DEFAULT '',
  mulai DATE NOT NULL,
  selesai DATE NULL,
  deskripsi TEXT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE layanan (
  id INT AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(100) NOT NULL,
  deskripsi VARCHAR(255) NOT NULL,
  ikon VARCHAR(40) NOT NULL DEFAULT 'sparkles',
  harga_mulai INT UNSIGNED NULL,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE testimoni (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  jabatan VARCHAR(120) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  foto VARCHAR(255) NOT NULL DEFAULT '',
  rating TINYINT UNSIGNED NOT NULL DEFAULT 5,
  tampil TINYINT(1) NOT NULL DEFAULT 1,
  urutan INT NOT NULL DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE pesan (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  subjek VARCHAR(150) NOT NULL DEFAULT '',
  isi TEXT NOT NULL,
  anggaran VARCHAR(40) NOT NULL DEFAULT '',
  ip VARCHAR(45) NOT NULL DEFAULT '',
  dibaca TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX (ip, created_at)
) ENGINE=InnoDB;

CREATE TABLE kunjungan (
  tanggal DATE PRIMARY KEY,
  jumlah INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

-- ===== Data contoh =====
INSERT INTO users (nama, username, password) VALUES
('Bima Aditya', 'admin', '$2y$10$hfPGjluwfNku5NZEkVGdjuwvX1Vc1qLQ4EygXt7IcuAsA1lMvQQ4y');

INSERT INTO pengaturan (kunci, nilai) VALUES
('nama', 'Bima Aditya'),
('peran', 'Full-Stack Developer'),
('judul_hero', 'Aku merakit aplikasi web & mobile yang ngebut, rapi, dan enak dipakai.'),
('tagline', 'Full-stack developer dari Bandung. 7 tahun membantu UMKM, startup, dan sekolah memindahkan pekerjaan manual ke aplikasi yang beneran dipakai tiap hari.'),
('bio', 'Halo, aku **Bima**. Mulai ngoding dari bikin website OSIS pakai PHP, sekarang sehari-hari memegang Laravel, React, Go, dan Flutter.

Aku paling senang mengerjakan masalah yang nyata: kasir yang lemot saat jam ramai, antrean klinik yang bikin pasien menunggu di luar, atau laporan gudang yang masih direkap manual tiap Jumat sore.

Cara kerjaku sederhana: dengar dulu masalahnya, buat prototipe secepatnya, lalu rilis bertahap sampai benar-benar dipakai. Di luar kerjaan, aku mengurus beberapa library open source kecil dan sesekali mengisi kelas ngoding untuk pelajar SMK.'),
('kota', 'Bandung, Jawa Barat'),
('email', 'halo@bimaaditya.id'),
('whatsapp', '081234567890'),
('status_teks', 'Terbuka untuk proyek freelance & remote'),
('tersedia', '1'),
('tahun_mulai', '2018'),
('aksen', 'lime'),
('foto', ''),
('cv', ''),
('meta_deskripsi', 'Portofolio Bima Aditya, full-stack developer Bandung: Laravel, React, Go, Flutter. Lihat proyek dan ajak kerja sama.'),
('sosial_github', 'https://github.com/bimaaditya'),
('sosial_linkedin', 'https://www.linkedin.com/in/bimaaditya'),
('sosial_instagram', 'https://www.instagram.com/bima.ngoding'),
('sosial_dribbble', ''),
('sosial_behance', ''),
('sosial_youtube', 'https://www.youtube.com/@bimangoding');

INSERT INTO teknologi (nama, logo, kategori, level, unggulan, urutan) VALUES
('Laravel', 'laravel', 'Framework', 95, 1, 1),
('PHP', 'php', 'Bahasa', 95, 1, 2),
('React', 'react', 'Framework', 90, 1, 3),
('TypeScript', 'typescript', 'Bahasa', 85, 1, 4),
('Go', 'go', 'Bahasa', 75, 1, 5),
('Flutter', 'flutter', 'Framework', 80, 1, 6),
('Next.js', 'nextdotjs', 'Framework', 85, 0, 7),
('Node.js', 'nodedotjs', 'Bahasa', 85, 0, 8),
('Tailwind CSS', 'tailwindcss', 'Framework', 90, 1, 9),
('MySQL', 'mysql', 'Database', 90, 0, 10),
('PostgreSQL', 'postgresql', 'Database', 85, 1, 11),
('Redis', 'redis', 'Database', 70, 0, 12),
('Firebase', 'firebase', 'Database', 75, 0, 13),
('Docker', 'docker', 'DevOps', 80, 1, 14),
('Nginx', 'nginx', 'DevOps', 70, 0, 15),
('GitHub Actions', 'githubactions', 'DevOps', 75, 0, 16),
('Figma', 'figma', 'Desain', 65, 0, 17),
('Vite', 'vite', 'Tools', 80, 0, 18);

INSERT INTO proyek (judul, slug, kategori, ringkasan, isi, cover, klien, peran, tahun, durasi, link_demo, link_repo, unggulan, urutan, dilihat, created_at) VALUES
('Warungku POS', 'warungku-pos', 'Web App', 'Kasir & stok untuk 38 warung anggota koperasi, tetap jalan saat internet putus.', '## Masalahnya
Koperasi Sumber Rejeki punya 38 warung anggota yang mencatat penjualan di buku tulis. Rekap stok baru ketahuan di akhir bulan, dan barang sering kosong saat ramai.

## Yang aku bangun
- Layar kasir berbasis web yang tetap jalan **offline** dan sinkron otomatis saat sinyal kembali
- Stok real-time per warung dengan peringatan barang hampir habis
- Dashboard omzet harian untuk pengurus koperasi
- Cetak struk ke printer thermal 58 mm langsung dari browser

## Hasilnya
Waktu tutup kasir turun dari 40 menit jadi 5 menit. Barang kosong berkurang 63% dalam dua bulan pertama.

Antrean sinkron memakai `Redis` dan setiap transaksi punya ID unik dari perangkat, jadi tidak pernah dobel walau dikirim ulang.', 'assets/img/contoh/warungku-pos.svg', 'Koperasi Sumber Rejeki', 'Lead developer', 2026, '4 bulan', 'https://example.com', '', 1, 1, 482, NOW() - INTERVAL 184 DAY),
('AntreSehat', 'antresehat', 'Mobile App', 'Ambil nomor antrean klinik dari rumah, notifikasi saat giliran tinggal 3 orang.', '## Latar
Pasien klinik biasa datang jam 6 pagi hanya untuk mengambil nomor. Ruang tunggu penuh, padahal dokter baru praktik jam 8.

## Solusi
- Aplikasi Flutter untuk ambil nomor dari rumah
- Estimasi waktu panggil dihitung dari rata-rata durasi periksa hari itu
- Notifikasi push saat antrean tinggal **3 orang**
- Layar TV ruang tunggu yang diperbarui otomatis

## Dampak
Rata-rata waktu tunggu di klinik turun dari 74 menit menjadi 18 menit. Aplikasi dipakai lebih dari 4.200 pasien di bulan ketiga.', 'assets/img/contoh/antresehat.svg', 'Klinik Pratama Medika', 'Mobile & backend developer', 2025, '3 bulan', '', '', 0, 2, 356, NOW() - INTERVAL 161 DAY),
('Pasar Rajut', 'pasar-rajut', 'E-Commerce', 'Marketplace kerajinan rajut dari 120 perajin rumahan, ongkir otomatis & bayar QRIS.', '## Tantangan
Perajin rajut di Bandung selatan menjual lewat grup WhatsApp. Foto produk tenggelam, pesanan sering terlewat.

## Fitur utama
- Toko per perajin dengan katalog, stok, dan varian warna
- Cek ongkir otomatis dan pembayaran QRIS
- Halaman produk super ringan: **skor Lighthouse 98** di HP murah
- Dashboard perajin dengan grafik penjualan sederhana

## Angka
1.900 pesanan di 3 bulan pertama, 41% pembeli datang dari pencarian Google.', 'assets/img/contoh/pasar-rajut.svg', 'Rajut Nusantara', 'Full-stack developer', 2025, '5 bulan', 'https://example.com', '', 1, 3, 611, NOW() - INTERVAL 138 DAY),
('Lintas Cargo Tracker', 'lintas-cargo', 'Web App', 'Pantau 140 armada truk di peta, lengkap dengan estimasi tiba dan laporan BBM.', '## Konteks
Tim operasional menelepon sopir satu per satu untuk menanyakan posisi truk.

## Arsitektur
- Layanan penerima GPS ditulis dengan `Go`, sanggup menampung 3.000 titik per detik
- Data posisi disimpan di PostgreSQL + PostGIS untuk hitung jarak & rute
- Dashboard React dengan peta dan filter per gudang

## Hasil
Telepon ke sopir berkurang 80%, estimasi waktu tiba akurat sampai selisih rata-rata 12 menit.', 'assets/img/contoh/lintas-cargo.svg', 'Lintas Cargo Ekspres', 'Backend developer', 2024, '6 bulan', '', '', 0, 4, 274, NOW() - INTERVAL 115 DAY),
('Halo CS', 'halo-cs', 'Web App', 'Kotak masuk bersama untuk chat pelanggan dari 12 gerai kopi.', '## Kebutuhan
Pertanyaan pelanggan masuk ke 12 nomor berbeda dan tidak ada yang tahu sudah dibalas atau belum.

## Yang dibuat
- Satu kotak masuk untuk semua gerai, dengan penugasan otomatis ke staf yang sedang online
- Template balasan cepat dan label percakapan
- Laporan waktu balas rata-rata per gerai

Waktu balas pertama turun dari 3 jam menjadi **9 menit**.', 'assets/img/contoh/halo-cs.svg', 'Kopi Senja Group', 'Full-stack developer', 2024, '2 bulan', '', '', 0, 5, 198, NOW() - INTERVAL 92 DAY),
('Rapor Digital Cendekia', 'rapor-digital', 'Landing Page', 'Situs promosi & pendaftaran aplikasi rapor untuk 60 sekolah swasta.', '## Tujuan
Mengajak sekolah swasta mencoba aplikasi rapor digital tanpa harus menelepon tim sales.

## Isi halaman
- Simulasi harga sesuai jumlah siswa
- Video demo 90 detik dan studi kasus 3 sekolah
- Formulir jadwal demo yang langsung masuk ke kalender tim

Konversi pengunjung ke permintaan demo naik dari 1,2% ke 4,8%.', 'assets/img/contoh/rapor-digital.svg', 'Sekolah Cendekia', 'Frontend developer', 2023, '1 bulan', 'https://example.com', '', 0, 6, 167, NOW() - INTERVAL 69 DAY),
('Presensi Yayasan Bina Insani', 'presensi-bina-insani', 'Web App', 'Presensi GPS + selfie untuk 420 guru di 9 sekolah, rekap gaji otomatis.', '## Situasi
Rekap presensi guru dari 9 sekolah dikumpulkan manual dalam Excel setiap akhir bulan.

## Solusi
- Presensi dari HP dengan validasi radius GPS sekolah dan foto selfie
- Pengajuan izin & cuti dengan persetujuan kepala sekolah
- Ekspor rekap ke format penggajian yayasan

Bagian keuangan menghemat sekitar **3 hari kerja** setiap bulan.', 'assets/img/contoh/presensi-bina-insani.svg', 'Yayasan Bina Insani', 'Lead developer', 2023, '3 bulan', '', '', 0, 7, 143, NOW() - INTERVAL 46 DAY),
('rupiah-kit', 'rupiah-kit', 'Open Source', 'Library TypeScript kecil untuk format & terbilang rupiah. Dipakai 300+ proyek.', '## Kenapa dibuat
Setiap proyek aku selalu menulis ulang fungsi format rupiah dan terbilang. Jadi aku jadikan library.

## Fitur
- `formatRupiah(15000)` menjadi Rp15.000
- `terbilang(1250000)` menjadi satu juta dua ratus lima puluh ribu
- Parser input yang memahami "15rb", "1,5jt", dan "Rp 2.000"
- Tanpa dependensi, ukuran di bawah 2 KB

Diunduh lebih dari 9 ribu kali per bulan dan diuji otomatis di setiap rilis.', 'assets/img/contoh/rupiah-kit.svg', '', 'Pembuat & pengelola', 2022, 'Berjalan', '', 'https://github.com/', 0, 8, 129, NOW() - INTERVAL 23 DAY);

INSERT INTO proyek_gambar (proyek_id, file, keterangan, urutan) VALUES
(1, 'assets/img/contoh/warungku-pos-1.svg', 'Dashboard omzet harian per cabang', 1),
(1, 'assets/img/contoh/warungku-pos-2.svg', 'Layar kasir mode offline', 2),
(2, 'assets/img/contoh/antresehat-1.svg', 'Alur ambil nomor antrean', 1),
(2, 'assets/img/contoh/antresehat-2.svg', 'Layar TV ruang tunggu', 2),
(3, 'assets/img/contoh/pasar-rajut-1.svg', 'Halaman katalog dengan filter warna', 1),
(3, 'assets/img/contoh/pasar-rajut-2.svg', 'Dashboard perajin', 2),
(4, 'assets/img/contoh/lintas-cargo-1.svg', 'Peta armada real-time', 1),
(4, 'assets/img/contoh/lintas-cargo-2.svg', 'Laporan konsumsi BBM per rute', 2),
(5, 'assets/img/contoh/halo-cs-1.svg', 'Kotak masuk bersama tim CS', 1),
(5, 'assets/img/contoh/halo-cs-2.svg', 'Template balasan cepat', 2),
(6, 'assets/img/contoh/rapor-digital-1.svg', 'Hero & simulasi harga', 1),
(6, 'assets/img/contoh/rapor-digital-2.svg', 'Formulir demo sekolah', 2),
(7, 'assets/img/contoh/presensi-bina-insani-1.svg', 'Rekap presensi bulanan', 1),
(7, 'assets/img/contoh/presensi-bina-insani-2.svg', 'Pengaturan radius lokasi sekolah', 2),
(8, 'assets/img/contoh/rupiah-kit-1.svg', 'Contoh pemakaian di form', 1),
(8, 'assets/img/contoh/rupiah-kit-2.svg', 'Dokumentasi interaktif', 2);

INSERT INTO proyek_teknologi (proyek_id, teknologi_id) VALUES
(1, 1),
(1, 3),
(1, 10),
(1, 12),
(1, 14),
(2, 6),
(2, 13),
(2, 8),
(3, 7),
(3, 8),
(3, 11),
(3, 9),
(4, 5),
(4, 3),
(4, 11),
(4, 14),
(5, 8),
(5, 3),
(5, 12),
(5, 4),
(6, 7),
(6, 9),
(6, 17),
(7, 1),
(7, 10),
(7, 14),
(7, 18),
(8, 4),
(8, 18),
(8, 16);

INSERT INTO pengalaman (jenis, posisi, instansi, kota, mulai, selesai, deskripsi) VALUES
('kerja', 'Senior Full-Stack Developer', 'Kodekita Studio', 'Bandung (hybrid)', '2023-03-01', NULL, 'Memimpin tim 4 developer untuk proyek UMKM dan pendidikan. Menyusun standar kode, review, dan pipeline deploy otomatis.'),
('kerja', 'Backend Developer', 'Lintas Cargo Ekspres', 'Jakarta (remote)', '2021-06-01', '2023-02-01', 'Membangun layanan pelacakan armada dengan Go dan PostgreSQL, menurunkan biaya server 35%.'),
('kerja', 'Web Developer', 'Digital Kreasi Media', 'Bandung', '2019-01-01', '2021-05-01', 'Mengerjakan 30+ website dan aplikasi internal klien dengan Laravel dan Vue.'),
('kerja', 'Freelance Web Developer', 'Mandiri', 'Bandung', '2018-01-01', '2018-12-01', 'Membuat website sekolah, katalog toko, dan sistem kasir sederhana untuk warung.'),
('pendidikan', 'S1 Teknik Informatika', 'Universitas Teknologi Bandung', 'Bandung', '2014-08-01', '2018-09-01', 'Skripsi: optimasi rute pengiriman dengan algoritma genetika.'),
('pendidikan', 'Rekayasa Perangkat Lunak', 'SMK Negeri 4 Bandung', 'Bandung', '2011-07-01', '2014-06-01', 'Juara 2 LKS Web Technologies tingkat provinsi.');

INSERT INTO layanan (judul, deskripsi, ikon, harga_mulai, urutan) VALUES
('Aplikasi Web Custom', 'Sistem kasir, inventori, presensi, atau dashboard internal yang mengikuti alur kerjamu.', 'code-xml', 8000000, 1),
('Aplikasi Mobile', 'Aplikasi Android & iOS dengan Flutter, lengkap dengan notifikasi dan mode offline.', 'smartphone', 15000000, 2),
('API & Integrasi', 'Hubungkan aplikasi dengan payment gateway, WhatsApp, ongkir, atau sistem lama.', 'server', 5000000, 3),
('Percepat & Rawat Aplikasi', 'Audit performa, perbaiki bug lama, pindah server, dan pemeliharaan bulanan.', 'gauge', 2500000, 4);

INSERT INTO testimoni (nama, jabatan, isi, foto, rating, urutan) VALUES
('Siti Rahmawati', 'Ketua Koperasi Sumber Rejeki', 'Mas Bima sabar banget menjelaskan ke ibu-ibu pengurus. Sekarang tutup kasir cuma lima menit, dan laporan bisa dilihat dari HP.', 'assets/img/contoh/av-1.svg', 5, 1),
('dr. Arif Hidayat', 'Kepala Klinik Pratama Medika', 'Pasien tidak lagi menumpuk di ruang tunggu sejak pagi. Aplikasinya stabil, dan setiap kendala dibalas di hari yang sama.', 'assets/img/contoh/av-2.svg', 5, 2),
('Maya Kusuma', 'Pendiri Rajut Nusantara', 'Bima tidak sekadar coding, dia ikut memikirkan cara perajin yang gaptek bisa upload produk sendiri. Penjualan kami naik tiga kali lipat.', 'assets/img/contoh/av-3.svg', 5, 3),
('Rendi Pratama', 'Head of Operations, Lintas Cargo', 'Layanan pelacakannya jalan dua tahun tanpa drama. Dokumentasinya rapi sehingga tim kami mudah melanjutkan.', 'assets/img/contoh/av-4.svg', 5, 4),
('Nurul Aini', 'Manajer Operasional Kopi Senja', 'Dulu chat pelanggan berantakan di 12 HP. Sekarang satu layar, semua tercatat, tim CS jauh lebih santai.', 'assets/img/contoh/av-5.svg', 4, 5),
('Yoga Saputra', 'CTO Kodekita Studio', 'Rekan satu tim yang enak diajak diskusi. Pull request-nya kecil, jelas, dan selalu ada tesnya.', 'assets/img/contoh/av-6.svg', 5, 6);

INSERT INTO pesan (nama, email, subjek, isi, anggaran, ip, dibaca, created_at) VALUES
('Andi Wijaya', 'andi.wijaya@tokobangunan.co.id', 'Aplikasi stok toko bangunan', 'Halo Mas Bima, kami punya 3 cabang toko bangunan di Cimahi. Butuh aplikasi stok dan kasir yang bisa dipantau dari pusat. Bisa diskusi minggu ini?', 'Rp15 - 50 juta', '10.0.0.11', 0, NOW() - INTERVAL 420 MINUTE),
('Putri Lestari', 'putri@kelasbaca.id', 'Kolaborasi aplikasi literasi anak', 'Kami komunitas literasi yang ingin membuat aplikasi baca untuk anak SD. Sudah ada desain di Figma. Apakah Mas Bima tertarik?', 'Rp5 - 15 juta', '10.0.0.15', 0, NOW() - INTERVAL 2100 MINUTE),
('Hendra Gunawan', 'hendra.g@mitralogistik.com', 'Integrasi API ekspedisi', 'Butuh integrasi cek resi dan ongkir beberapa ekspedisi ke sistem internal kami (Laravel 10).', 'Rp5 - 15 juta', '10.0.0.36', 1, NOW() - INTERVAL 10920 MINUTE),
('Dewi Anggraini', 'dewi.anggraini@gmail.com', 'Undangan mengisi workshop', 'Kami dari himpunan mahasiswa informatika ingin mengundang Mas Bima mengisi workshop Laravel untuk pemula.', 'Belum tahu', '10.0.0.80', 1, NOW() - INTERVAL 29400 MINUTE);

INSERT INTO kunjungan (tanggal, jumlah) VALUES
(CURDATE() - INTERVAL 1 DAY, 70),
(CURDATE() - INTERVAL 2 DAY, 98),
(CURDATE() - INTERVAL 3 DAY, 89),
(CURDATE() - INTERVAL 4 DAY, 96),
(CURDATE() - INTERVAL 5 DAY, 112),
(CURDATE() - INTERVAL 6 DAY, 116),
(CURDATE() - INTERVAL 7 DAY, 80),
(CURDATE() - INTERVAL 8 DAY, 73),
(CURDATE() - INTERVAL 9 DAY, 73),
(CURDATE() - INTERVAL 10 DAY, 126),
(CURDATE() - INTERVAL 11 DAY, 51),
(CURDATE() - INTERVAL 12 DAY, 79),
(CURDATE() - INTERVAL 13 DAY, 75),
(CURDATE() - INTERVAL 14 DAY, 47),
(CURDATE() - INTERVAL 15 DAY, 51),
(CURDATE() - INTERVAL 16 DAY, 81),
(CURDATE() - INTERVAL 17 DAY, 41),
(CURDATE() - INTERVAL 18 DAY, 42),
(CURDATE() - INTERVAL 19 DAY, 51),
(CURDATE() - INTERVAL 20 DAY, 54),
(CURDATE() - INTERVAL 21 DAY, 58),
(CURDATE() - INTERVAL 22 DAY, 44),
(CURDATE() - INTERVAL 23 DAY, 94),
(CURDATE() - INTERVAL 24 DAY, 95),
(CURDATE() - INTERVAL 25 DAY, 78),
(CURDATE() - INTERVAL 26 DAY, 81),
(CURDATE() - INTERVAL 27 DAY, 59),
(CURDATE() - INTERVAL 28 DAY, 107),
(CURDATE() - INTERVAL 29 DAY, 57),
(CURDATE() - INTERVAL 30 DAY, 47);

