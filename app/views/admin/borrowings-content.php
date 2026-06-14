<section class="admin-page-title">
    <div>
        <span class="eyebrow">Peminjaman</span>
        <h1>Monitoring transaksi buku</h1>
        <p>Frontend daftar pinjam, tanggal kembali, dan status pengembalian mahasiswa.</p>
    </div>
</section>

<?php if (!empty($successMessage)): ?>
    <div class="alert alert-success" style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
        <?= e($successMessage); ?>
    </div>
<?php endif; ?>

<?php if (!empty($errorMessage)): ?>
    <div class="alert alert-danger" style="background: #f8d7da; color: #721c24; padding: 1rem; border-radius: 8px; margin-bottom: 1rem;">
        <?= e($errorMessage); ?>
    </div>
<?php endif; ?>

<section class="admin-panel">
    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Judul Buku</th>
                    <th>Peminjam</th>
                    <th>Tanggal Pinjam</th>
                    <th>Tanggal Kembali</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($histories as $item): ?>
                    <tr>
                        <td><strong><?= e($item['book_titles'] ?? 'N/A'); ?></strong></td>
                        <td><?= e($item['user_name'] ?? 'N/A'); ?></td>
                        <td><?= e(isset($item['borrow_date']) ? formatDate($item['borrow_date']) : 'N/A'); ?></td>
                        <td><?= e(isset($item['return_date']) ? formatDate($item['return_date']) : '-'); ?></td>
                        <td><span class="history-status <?= e(strtolower($item['status'])); ?>"><?= e($item['status']); ?></span></td>
                        <td>
                            <?php if (strtolower($item['status']) !== 'returned'): ?>
                                <form method="POST" onsubmit="return confirm('Konfirmasi pengembalian buku?');">
                                    <input type="hidden" name="action" value="return">
                                    <input type="hidden" name="id" value="<?= $item['id'] ?>">
                                    <button class="btn btn-primary" type="submit" style="font-size: 12px; padding: 5px 10px;">Kembalikan</button>
                                </form>
                            <?php else: ?>
                                <span style="color: #6c757d; font-size: 12px;">Selesai</span>
                            <?php endif; ?>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</section>

