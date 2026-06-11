<section class="admin-page-title">
    <div>
        <span class="eyebrow">Peminjaman</span>
        <h1>Monitoring transaksi buku</h1>
        <p>Frontend daftar pinjam, tanggal kembali, dan status pengembalian mahasiswa.</p>
    </div>
</section>

<section class="admin-panel">
    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Judul Buku</th>
                    <th>Tanggal Pinjam</th>
                    <th>Tanggal Kembali</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($histories as $item): ?>
                    <tr>
                        <td><strong><?= e($item['title']); ?></strong></td>
                        <td><?= e($item['borrowed_at']); ?></td>
                        <td><?= e($item['returned_at']); ?></td>
                        <td><span class="history-status <?= e(strtolower($item['status'])); ?>"><?= e($item['status']); ?></span></td>
                        <td><button class="admin-action-button" type="button">Update</button></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</section>

