<?php
require_once __DIR__ . '/../app/helpers/functions.php';
require_once __DIR__ . '/../app/data/history.php';
$pageTitle = 'Riwayat Peminjaman - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
?>
<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">Riwayat</span>
        <h1>Peminjaman buku</h1>
        <p>Pantau daftar peminjaman dan pengembalian buku dalam tampilan yang nyaman di mobile.</p>
    </section>

    <section class="history-list">
        <?php foreach ($histories as $item): ?>
            <article class="history-card">
                <div>
                    <h2><?= e($item['title']); ?></h2>
                    <p>Pinjam: <?= e($item['borrowed_at']); ?></p>
                    <p>Kembali: <?= e($item['returned_at']); ?></p>
                </div>
                <span class="history-status <?= e(strtolower($item['status'])); ?>"><?= e($item['status']); ?></span>
            </article>
        <?php endforeach; ?>
    </section>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

