# Orbit — Template Portofolio + CMS (PHP Native + MySQL)

Template portofolio bertema antariksa gelap untuk developer, lengkap dengan CMS untuk mengelola semua isinya tanpa menyentuh kode. Logo teknologi unggulan mengorbit foto profil dalam sistem 3D, kartu proyek miring mengikuti kursor, testimoni berputar di carousel silinder 3D, dan bintang di latar bergerak parallax saat halaman di-scroll.

## Isi folder

| Path | Fungsi |
|---|---|
| `index.php` | Router: halaman publik (`beranda`, `proyek`, `kirim`) + halaman CMS |
| `config/database.php` | Koneksi MySQL |
| `includes/bootstrap.php` | Koneksi PDO, CSRF, login & sesi, upload gambar → WebP, ikon & logo |
| `includes/data.php` | Pengambil data halaman publik |
| `includes/tema.php` | Pilihan warna aksen & font tema Orbit |
| `includes/logos.php` | 70+ logo teknologi satu warna (Simple Icons, CC0) |
| `includes/icons.php` | Ikon garis Lucide |
| `pages/beranda.php`, `pages/proyek.php` | Halaman depan & detail proyek |
| `pages/kirim.php` | Penerima formulir kontak |
| `pages/admin/*` | Halaman CMS |
| `assets/css`, `assets/js` | Tampilan & efek (tanpa framework, tanpa jQuery) |
| `assets/img` | Ilustrasi bawaan (potret, avatar, cover & galeri proyek contoh) |
| `assets/uploads` | Tempat file yang diunggah dari CMS |
| `database/porto_orbit.sql` | Skema + data contoh |

## Instalasi singkat

1. Salin folder `porto-orbit` ke `htdocs` (XAMPP) atau `www` (Laragon).
2. Jalankan Apache & MySQL, lalu impor `database/porto_orbit.sql` lewat phpMyAdmin.
3. Sesuaikan `config/database.php` bila user/password MySQL berbeda.
4. Buka `http://localhost/porto-orbit/` untuk situs, dan `http://localhost/porto-orbit/index.php?page=login` untuk CMS.
   Login awal: **admin / admin123** — segera ganti di menu **Akun**.

## Yang bisa diatur dari CMS

- **Profil & Situs**: nama, peran, kalimat hero, tagline, bio (mendukung **tebal**), kota, tahun mulai berkarya, status "tersedia", foto, CV PDF, email, WhatsApp, 6 media sosial, deskripsi SEO, dan 4 pilihan warna aksen.
- **Proyek**: judul, kategori (jadi filter otomatis), ringkasan, cerita proyek dengan format sederhana, klien, peran, tahun, durasi, link demo & repo, cover, galeri banyak gambar dengan keterangan, teknologi yang dipakai, tandai unggulan, sembunyikan, atur urutan.
- **Teknologi**: pilih logo dari 70+ logo, kategori, tingkat penguasaan, unggulan (yang unggulan ikut mengorbit di hero).
- **Pengalaman & pendidikan**, **Layanan** (ikon + harga mulai), **Testimoni** (foto + rating).
- **Pesan masuk** dari formulir kontak: tandai dibaca, balas lewat email, ekspor CSV.
- **Dashboard**: proyek, total dilihat, pengunjung 30 hari, grafik 14 hari, proyek terpopuler.

Format cerita proyek: `## Subjudul`, `- poin`, `**tebal**`, `*miring*`, `` `kode` ``, `[teks](https://link)`.

## Catatan keamanan

- Semua query memakai PDO prepared statement; semua output di-escape.
- CSRF token di setiap form (termasuk formulir kontak publik).
- Password di-hash (`password_hash`); login dikunci 15 menit setelah 5 kali gagal per IP.
- Mengganti password otomatis mengeluarkan sesi di perangkat lain.
- Upload gambar dicek MIME aslinya lalu **digambar ulang** menjadi WebP (membuang metadata & sisipan). CV hanya PDF. Folder upload otomatis diberi `.htaccess` yang memblokir eksekusi script.
- Link (demo, repo, sosial) hanya menerima `http(s)://`, jadi `javascript:` tidak bisa disisipkan.
- Formulir kontak: honeypot anti-bot, maksimal 3 pesan per 10 menit per IP, tolak pesan dobel.
- Ekspor CSV aman dari formula injection (nilai diawali `= + - @` diberi tanda petik).

## Mengganti ilustrasi contoh

Gambar contoh ada di `assets/img/contoh/`. Cukup unggah cover & galeri asli lewat CMS; ilustrasi contoh tidak dihapus otomatis sehingga aman. Foto profil yang kosong akan memakai `assets/img/potret.svg`.
