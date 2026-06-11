<section class="admin-page-title">
    <div>
        <span class="eyebrow">QR Code</span>
        <h1>Log scan dan QR buku</h1>
        <p>Pantau scan QR terbaru dan siapkan QR placeholder untuk koleksi buku.</p>
    </div>
</section>

<section class="admin-two-column">
    <article class="admin-panel qr-admin-preview">
        <h2>QR koleksi</h2>
        <?php include __DIR__ . '/../components/qr-placeholder.php'; ?>
        <p>QR ini masih placeholder. Nantinya setiap buku bisa punya kode unik dari database.</p>
        <button class="btn btn-primary" type="button">Generate Dummy</button>
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
                        <strong><?= e($scan['book']); ?></strong>
                        <span><?= e($scan['student']); ?> · <?= e($scan['location']); ?></span>
                        <span><?= e($scan['time']); ?></span>
                    </div>
                    <em><?= e($scan['result']); ?></em>
                </div>
            <?php endforeach; ?>
        </div>
    </article>
</section>

