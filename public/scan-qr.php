<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

$pageTitle = 'Scan QR - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
?>
<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">QR scanner</span>
        <h1>Scan QR Code Buku</h1>
        <p>Arahkan kamera ke QR Code pada buku untuk membuka informasi koleksi. Saat ini masih berupa simulasi frontend.</p>
    </section>

    <section class="scan-layout">
        <div class="scanner-frame">
            <div class="scan-corners"></div>
            <div class="scan-line" data-scan-line></div>
            <p>Area kamera</p>
        </div>
        <article class="scan-panel">
            <h2>Simulasi hasil scan</h2>
            <p>Tekan tombol untuk menampilkan informasi buku dummy dari QR Code.</p>
            <button class="btn btn-primary" type="button" data-start-scan>Mulai Scan</button>
            <div class="scan-result" data-scan-result hidden>
                <span class="status-pill status-available">Berhasil</span>
                <h3>Mobile Computing Essentials</h3>
                <p>Penulis: Sinta Maharani</p>
                <p>Kategori: Mobile Computing</p>
                <a class="text-link" href="<?= page_url('book-detail.php?id=4'); ?>">Lihat detail buku</a>
            </div>
        </article>
    </section>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

