<?php
$borrowedCount = $activeBorrowingsCount ?? count(array_filter($histories, fn ($item) => in_array($item['status'], ['active', 'pending', 'overdue'], true)));
$returnedCount = count($returnedBorrowings ?? []);
$adminStats = [
    ['label' => 'Total Buku', 'value' => count($books), 'hint' => 'Koleksi aktif'],
    ['label' => 'Mahasiswa', 'value' => count($users), 'hint' => 'Akun terdaftar'],
    ['label' => 'Dipinjam', 'value' => $borrowedCount, 'hint' => 'Masih berjalan'],
    ['label' => 'QR Scan', 'value' => $qrScanCountToday ?? count($qrScans), 'hint' => 'Hari ini'],
];
?>
<section class="admin-hero-panel">
    <div>
        <span class="eyebrow">Panel admin</span>
        <h1>Kelola katalog dan peminjaman dari satu tempat</h1>
        <p>Dashboard ini membaca koleksi, mahasiswa, peminjaman, dan log QR langsung dari database MySQL.</p>
    </div>
    <div class="admin-hero-actions">
        <a class="btn btn-primary" href="<?= page_url('admin-books.php'); ?>">Tambah Buku</a>
        <a class="btn btn-light" href="<?= page_url('admin-qr.php'); ?>">Lihat QR</a>
    </div>
    <div class="admin-hero-meter" aria-label="Ringkasan aktivitas">
        <span>Aktivitas sistem</span>
        <strong><?= e((string) (($totalBooks ?? count($books)) > 0 ? 100 : 0)); ?>%</strong>
        <div><i></i></div>
        <p>Katalog dan log QR tersinkron dengan database</p>
    </div>
</section>

<section class="admin-stat-grid">
    <?php foreach ($adminStats as $stat): ?>
        <article class="admin-stat-card">
            <strong><?= e((string) $stat['value']); ?></strong>
            <span><?= e($stat['label']); ?></span>
            <p><?= e($stat['hint']); ?></p>
        </article>
    <?php endforeach; ?>
</section>

<section class="admin-two-column">
    <article class="admin-panel">
        <div class="admin-panel-heading">
            <h2>Peminjaman terbaru</h2>
            <a href="<?= page_url('admin-borrowings.php'); ?>">Lihat semua</a>
        </div>
        <div class="admin-list">
            <?php foreach (array_slice($histories, 0, 3) as $item): ?>
                <div class="admin-list-item">
                    <div>
                        <strong><?= e($item['book_titles'] ?? 'N/A'); ?></strong>
                        <span><?= e(isset($item['borrow_date']) ? formatDate($item['borrow_date']) : 'N/A'); ?> - <?= e(!empty($item['return_date']) ? formatDate($item['return_date']) : '-'); ?></span>
                    </div>
                    <em><?= e($item['status']); ?></em>
                </div>
            <?php endforeach; ?>
        </div>
    </article>

    <article class="admin-panel">
        <div class="admin-panel-heading">
            <h2>Scan QR terbaru</h2>
            <a href="<?= page_url('admin-qr.php'); ?>">Detail log</a>
        </div>
        <div class="admin-list">
            <?php foreach ($qrScans as $scan): ?>
                <div class="admin-list-item">
                    <div>
                        <strong><?= e($scan['book_title']); ?></strong>
                        <span><?= e($scan['user_name']); ?> - <?= e(formatDate($scan['created_at'])); ?></span>
                    </div>
                    <em><?= e($scan['scan_type']); ?></em>
                </div>
            <?php endforeach; ?>
        </div>
    </article>
</section>
