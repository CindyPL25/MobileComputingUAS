<section class="admin-page-title">
    <div>
        <span class="eyebrow">Manajemen buku</span>
        <h1>Data koleksi perpustakaan</h1>
        <p>Kelola daftar buku, metadata penerbit, ketersediaan, dan sumber referensi.</p>
    </div>
    <a class="btn btn-primary" href="#bookForm">Tambah Buku</a>
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

<section class="admin-panel" id="bookForm">
    <div class="admin-panel-heading">
        <h2>Form Buku</h2>
        <span>Tambah koleksi baru</span>
    </div>
    <form class="admin-form" method="POST" action="">
        <input type="hidden" name="action" value="add">
        
        <label>
            <span>Judul Buku</span>
            <input type="text" name="title" placeholder="Masukkan judul buku" required>
        </label>
        
        <label>
            <span>Penulis</span>
            <input type="text" name="author" placeholder="Nama penulis" required>
        </label>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>Penerbit</span>
                <input type="text" name="publisher" placeholder="Nama penerbit">
            </label>
            
            <label>
                <span>Tahun Terbit</span>
                <input type="number" name="publication_year" placeholder="YYYY">
            </label>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>ISBN</span>
                <input type="text" name="isbn" placeholder="ISBN Buku">
            </label>
            
            <label>
                <span>Stok</span>
                <input type="number" name="stock" value="1" min="1" required>
            </label>
        </div>
        
        <label>
            <span>Kategori</span>
            <select name="category_id" required>
                <option value="">-- Pilih Kategori --</option>
                <?php foreach ($categories as $cat): ?>
                    <option value="<?= e($cat['id']) ?>"><?= e($cat['name']) ?></option>
                <?php endforeach; ?>
            </select>
        </label>
        
        <label>
            <span>Deskripsi Singkat</span>
            <textarea name="description" rows="3" placeholder="Sinopsis atau deskripsi buku"></textarea>
        </label>
        
        <button class="btn btn-primary" type="submit">Simpan Buku</button>
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
                    <th>Stok (Tersedia)</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($books as $book): ?>
                    <tr>
                        <td>
                            <div class="admin-book-cell">
                                <img src="<?= media_url($book['cover_image'] ?? 'images/placeholder.png'); ?>" alt="Cover <?= e($book['title']); ?>" style="width:40px;height:60px;object-fit:cover;border-radius:4px;">
                                <strong><?= e($book['title']); ?></strong>
                            </div>
                        </td>
                        <td><?= e($book['author'] ?? '-'); ?></td>
                        <td><?= e($book['publisher'] ?? '-'); ?> (<?= e($book['publication_year'] ?? '-'); ?>)</td>
                        <td><?= e($book['category_name'] ?? '-'); ?></td>
                        <td><?= e($book['stock']); ?> (<?= e($book['available_stock']); ?>)</td>
                        <td style="display:flex;gap:0.5rem;align-items:center;">
                            <a class="text-link" href="<?= page_url('book-detail.php?id=' . $book['id']); ?>">View</a>
                            
                            <form method="POST" style="display:inline;" onsubmit="return confirm('Hapus buku ini?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<?= e($book['id']) ?>">
                                <button type="submit" style="background:none;border:none;color:red;cursor:pointer;padding:0;">Hapus</button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</section>

