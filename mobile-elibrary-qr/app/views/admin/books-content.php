<section class="admin-page-title">
    <div>
        <span class="eyebrow">Manajemen buku</span>
        <h1>Data koleksi perpustakaan</h1>
        <p>Kelola daftar buku, metadata penerbit, ketersediaan, dan sumber referensi.</p>
    </div>
    <a class="btn btn-primary" href="#bookForm">Tambah Buku</a>
</section>

<section class="admin-panel" id="bookForm">
    <div class="admin-panel-heading">
        <h2>Form buku dummy</h2>
        <span>Belum tersimpan ke database</span>
    </div>
    <form class="admin-form">
        <label>
            <span>Judul Buku</span>
            <input type="text" placeholder="Masukkan judul buku">
        </label>
        <label>
            <span>Penulis</span>
            <input type="text" placeholder="Nama penulis">
        </label>
        <label>
            <span>Kategori</span>
            <select>
                <option>Teknologi</option>
                <option>Sistem Informasi</option>
                <option>Database</option>
                <option>Mobile Computing</option>
                <option>Keamanan Web</option>
            </select>
        </label>
        <label>
            <span>Status</span>
            <select>
                <option>Tersedia</option>
                <option>Dipinjam</option>
            </select>
        </label>
        <button class="btn btn-primary" type="button">Simpan Dummy</button>
    </form>
</section>

<section class="admin-panel">
    <div class="admin-panel-heading">
        <h2>Daftar buku</h2>
        <span><?= count($books); ?> koleksi</span>
    </div>
    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Buku</th>
                    <th>Penulis</th>
                    <th>Penerbit</th>
                    <th>Kategori</th>
                    <th>Status</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($books as $book): ?>
                    <tr>
                        <td>
                            <div class="admin-book-cell">
                                <img src="<?= media_url($book['cover']); ?>" alt="Cover <?= e($book['title']); ?>">
                                <strong><?= e($book['title']); ?></strong>
                            </div>
                        </td>
                        <td><?= e($book['author']); ?></td>
                        <td><?= e($book['publisher']); ?> (<?= e($book['year']); ?>)</td>
                        <td><?= e($book['category']); ?></td>
                        <td><span class="status-pill <?= status_class($book['status']); ?>"><?= e($book['status']); ?></span></td>
                        <td><a class="text-link" href="<?= page_url('book-detail.php?id=' . $book['id']); ?>">Detail</a></td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</section>

