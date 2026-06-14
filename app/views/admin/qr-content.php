<section class="admin-page-title">
    <div>
        <span class="eyebrow">QR Code</span>
        <h1>Log scan dan kode QR buku</h1>
        <p>Pantau scan QR terbaru dan kode unik buku yang tersimpan di database.</p>
    </div>
</section>

<section class="admin-two-column">
    <article class="admin-panel">
        <div class="admin-panel-heading">
            <h2>Kode QR koleksi</h2>
            <span><?= count($books); ?> buku</span>
        </div>
        <div class="admin-list">
            <?php foreach ($books as $book): ?>
                <div class="admin-list-item">
                    <div>
                        <strong><?= e($book['title']); ?></strong>
                        <span><?= e($book['category_name'] ?? '-'); ?> - Stok <?= e((string) $book['available_stock']); ?>/<?= e((string) $book['stock']); ?></span>
                    </div>
                    <em><?= e($book['book_code']); ?></em>
                </div>
            <?php endforeach; ?>
        </div>
    </article>

    <article class="admin-panel">
        <div class="admin-panel-heading">
            <h2>Riwayat scan</h2>
            <span><?= count($qrScans); ?> log</span>
        </div>
        <div class="admin-list">
            <?php foreach ($qrScans as $scan): ?>
                <div class="admin-list-item">
                    <div>
                        <strong><?= e($scan['book_title']); ?></strong>
                        <span><?= e($scan['user_name']); ?> - <?= e($scan['location'] ?? '-'); ?></span>
                        <span><?= e(date('d M Y H:i', strtotime($scan['created_at']))); ?></span>
                    </div>
                    <em><?= e($scan['scan_type']); ?></em>
                </div>
            <?php endforeach; ?>
            <?php if (empty($qrScans)): ?>
                <p class="empty-state">Belum ada log scan QR.</p>
            <?php endif; ?>
        </div>
    </article>
</section>
