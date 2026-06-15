<main>
    <section class="hero">
        <div class="hero-overlay"></div>
        <div class="hero-content">
            <span class="eyebrow">Perpustakaan digital kampus</span>
            <h1>Mobile E-Library Kampus</h1>
            <p>Sistem perpustakaan mobile web untuk mencari katalog buku, melihat detail koleksi, dan memproses QR Code buku.</p>
            <div class="hero-actions">
                <a class="btn btn-primary" href="<?= page_url('dashboard.php'); ?>">Mulai Baca</a>
                <a class="btn btn-light" href="<?= page_url('catalog.php'); ?>">Lihat Katalog</a>
                <a class="btn btn-outline" href="<?= page_url('scan-qr.php'); ?>">Scan QR</a>
            </div>
        </div>
    </section>

    <section class="section intro-section">
        <div class="intro-copy">
            <span class="eyebrow">Tentang layanan</span>
            <h2>Perpustakaan kampus yang lebih dekat dengan mahasiswa</h2>
            <p>Mobile E-Library Kampus membantu mahasiswa mencari referensi kuliah, melihat status ketersediaan buku, dan membuka detail koleksi melalui QR Code. Tampilan dibuat sederhana agar nyaman digunakan dari smartphone saat berada di ruang baca, kelas, atau area kampus.</p>
            <div class="library-highlights">
                <span><?= e((string) ($totalBooks ?? 0)); ?> Buku</span>
                <span><?= e((string) ($activeBorrowingsCount ?? 0)); ?> Peminjaman aktif</span>
                <span><?= e((string) ($qrScanCountToday ?? 0)); ?> Scan QR hari ini</span>
            </div>
        </div>
        <div class="intro-image">
            <img src="<?= asset_url('images/home-library-service.png'); ?>" alt="Mahasiswa menggunakan layanan perpustakaan digital">
        </div>
    </section>

    <section class="section feature-section enhanced-features">
        <div class="section-heading feature-heading">
            <div>
                <span class="eyebrow">Fitur utama</span>
                <h2>Dirancang untuk alur perpustakaan kampus yang ringkas</h2>
            </div>
            <p>Semua fitur dibuat mengikuti kebiasaan mahasiswa saat mencari referensi: cepat dibuka dari handphone, informatif, dan mudah dipakai saat berada di area perpustakaan.</p>
        </div>
        <div class="feature-grid">
            <article class="feature-card feature-catalog">
                <div class="feature-topline">
                    <span class="feature-number">01</span>
                    <span class="feature-icon" aria-hidden="true">KB</span>
                </div>
                <h3>Katalog Buku Digital</h3>
                <p>Telusuri koleksi buku berdasarkan judul, penulis, kategori, dan status ketersediaan.</p>
                <a href="<?= page_url('catalog.php'); ?>">Lihat katalog</a>
            </article>
            <article class="feature-card feature-scan">
                <div class="feature-topline">
                    <span class="feature-number">02</span>
                    <span class="feature-icon" aria-hidden="true">QR</span>
                </div>
                <h3>Scan QR Code Buku</h3>
                <p>Validasi kode QR untuk membuka informasi buku dan memproses peminjaman atau pengembalian.</p>
                <a href="<?= page_url('scan-qr.php'); ?>">Coba scan</a>
            </article>
            <article class="feature-card feature-history">
                <div class="feature-topline">
                    <span class="feature-number">03</span>
                    <span class="feature-icon" aria-hidden="true">RP</span>
                </div>
                <h3>Riwayat Peminjaman</h3>
                <p>Lihat catatan peminjaman, tanggal kembali, dan status buku dalam tampilan mobile friendly.</p>
                <a href="<?= page_url('borrow-history.php'); ?>">Cek riwayat</a>
            </article>
            <article class="feature-card feature-mobile">
                <div class="feature-topline">
                    <span class="feature-number">04</span>
                    <span class="feature-icon" aria-hidden="true">MW</span>
                </div>
                <h3>Akses Mobile Friendly</h3>
                <p>Layout responsif dengan bottom navigation seperti aplikasi mobile untuk akses cepat.</p>
                <a href="<?= page_url('profile.php'); ?>">Lihat profil</a>
            </article>
        </div>
    </section>

    <section class="section collection-preview">
        <div class="section-heading row-heading">
            <div>
                <span class="eyebrow">Koleksi pilihan</span>
                <h2>Referensi populer untuk kebutuhan kuliah</h2>
            </div>
            <a class="text-link" href="<?= page_url('catalog.php'); ?>">Buka katalog</a>
        </div>
        <div class="book-grid">
            <?php foreach (array_slice($books, 0, 3) as $book): ?>
                <?php include __DIR__ . '/../components/book-card.php'; ?>
            <?php endforeach; ?>
        </div>
    </section>

    <section class="section library-flow">
        <div class="flow-visual">
            <img src="<?= asset_url('images/home-reading-area.png'); ?>" alt="Area baca perpustakaan kampus modern">
        </div>
        <div class="flow-copy">
            <span class="eyebrow">Cara menggunakan</span>
            <h2>Cari buku, scan QR, lalu pantau peminjaman</h2>
            <div class="flow-steps">
                <article>
                    <span>1</span>
                    <div>
                        <h3>Telusuri katalog</h3>
                        <p>Gunakan pencarian dan filter kategori untuk menemukan buku yang sesuai kebutuhan tugas atau materi kuliah.</p>
                    </div>
                </article>
                <article>
                    <span>2</span>
                    <div>
                        <h3>Lihat detail buku</h3>
                        <p>Cek penulis, tahun terbit, kategori, deskripsi singkat, dan status ketersediaan sebelum meminjam.</p>
                    </div>
                </article>
                <article>
                    <span>3</span>
                    <div>
                        <h3>Scan QR Code</h3>
                        <p>Masukkan kode QR pada buku untuk validasi koleksi, peminjaman, atau pengembalian.</p>
                    </div>
                </article>
            </div>
        </div>
    </section>

    <section class="section home-cta">
        <div>
            <span class="eyebrow">Layanan aktif</span>
            <h2>Backend perpustakaan terhubung ke MySQL</h2>
            <p>Autentikasi, katalog, peminjaman, pengembalian, notifikasi, dan log QR diproses melalui backend PHP Native.</p>
        </div>
        <a class="btn btn-primary" href="<?= page_url('scan-qr.php'); ?>">Coba Scan QR</a>
    </section>
</main>
