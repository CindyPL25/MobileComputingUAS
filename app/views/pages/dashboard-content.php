<?php
$borrowedCount = count(array_filter($borrowings, fn ($item) => strtolower($item['status']) === 'active'));
$returnedCount = count(array_filter($returnedBorrowings ?? [], fn ($item) => strtolower($item['status']) === 'returned'));
$popularBooks = array_values(array_filter($books, fn ($book) => $book['is_popular'] == 1));
$stats = [
    ['label' => 'Total Buku', 'value' => count($books), 'icon' => 'TB', 'tone' => 'tone-blue'],
    ['label' => 'Buku Dipinjam', 'value' => $borrowedCount, 'icon' => 'BD', 'tone' => 'tone-gold'],
    ['label' => 'Buku Dikembalikan', 'value' => $returnedCount, 'icon' => 'BK', 'tone' => 'tone-green'],
    ['label' => 'QR Scan Hari Ini', 'value' => $qrScanCount ?? 0, 'icon' => 'QR', 'tone' => 'tone-slate'],
];
?>
<main class="page-shell">
    <section class="welcome-panel">
        <div>
            <span class="eyebrow">Dashboard mahasiswa</span>
            <h1>Halo, <?= e($user['name'] ?? 'Pengguna'); ?></h1>
            <p>Temukan buku kuliah, pantau peminjaman, dan scan QR buku langsung dari perangkat mobile.</p>
        </div>
        <div class="quick-actions">
            <a class="btn btn-primary" href="<?= page_url('catalog.php'); ?>">Buka Katalog</a>
            <a class="btn btn-light" href="<?= page_url('scan-qr.php'); ?>">Scan QR</a>
        </div>
    </section>

    <section class="stats-grid" aria-label="Statistik perpustakaan">
        <?php foreach ($stats as $stat): ?>
            <?php
            $label = $stat['label'];
            $value = $stat['value'];
            $icon = $stat['icon'];
            $tone = $stat['tone'];
            include __DIR__ . '/../components/stats-card.php';
            ?>
        <?php endforeach; ?>
    </section>

    <section class="section compact-section">
        <div class="section-heading row-heading">
            <div>
                <span class="eyebrow">Rekomendasi</span>
                <h2>Buku populer minggu ini</h2>
            </div>
            <a class="text-link" href="<?= page_url('catalog.php'); ?>">Lihat semua</a>
        </div>
        <div class="book-grid">
            <?php foreach ($popularBooks as $book): ?>
                <?php include __DIR__ . '/../components/book-card.php'; ?>
            <?php endforeach; ?>
        </div>
    </section>
</main>

