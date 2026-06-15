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
        <h2><?= $editingBook ? 'Edit Buku' : 'Form Buku'; ?></h2>
        <span><?= $editingBook ? 'Perbarui koleksi' : 'Tambah koleksi baru'; ?></span>
    </div>
    <form class="admin-form" method="POST" action="">
        <input type="hidden" name="action" value="<?= $editingBook ? 'edit' : 'add'; ?>">
        <?php if ($editingBook): ?>
            <input type="hidden" name="id" value="<?= e((string) $editingBook['id']); ?>">
        <?php endif; ?>
        
        <label>
            <span>Judul Buku</span>
            <input type="text" name="title" value="<?= e($editingBook['title'] ?? ''); ?>" placeholder="Masukkan judul buku" required>
        </label>
        
        <label>
            <span>Penulis</span>
            <input type="text" name="author" value="<?= e($editingBook['author'] ?? ''); ?>" placeholder="Nama penulis" required>
        </label>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>Penerbit</span>
                <input type="text" name="publisher" value="<?= e($editingBook['publisher'] ?? ''); ?>" placeholder="Nama penerbit">
            </label>
            
            <label>
                <span>Tahun Terbit</span>
                <input type="number" name="publication_year" value="<?= e((string) ($editingBook['publication_year'] ?? '')); ?>" placeholder="YYYY">
            </label>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>ISBN</span>
                <input type="text" name="isbn" value="<?= e($editingBook['isbn'] ?? ''); ?>" placeholder="ISBN Buku">
            </label>
            
            <label>
                <span>Stok</span>
                <input type="number" name="stock" value="<?= e((string) ($editingBook['stock'] ?? 1)); ?>" min="0" required>
            </label>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>Kode Buku / QR</span>
                <input type="text" name="book_code" value="<?= e($editingBook['book_code'] ?? ''); ?>" placeholder="TECH001">
            </label>
            
            <label>
                <span>Cover Image</span>
                <input type="text" name="cover_image" value="<?= e($editingBook['cover_image'] ?? ''); ?>" placeholder="assets/images/books/cover.png">
            </label>
        </div>
        
        <label>
            <span>Kategori</span>
            <select name="category_id" required>
                <option value="">-- Pilih Kategori --</option>
                <?php foreach ($categories as $cat): ?>
                    <option value="<?= e((string) $cat['id']) ?>" <?= (int) ($editingBook['category_id'] ?? 0) === (int) $cat['id'] ? 'selected' : ''; ?>><?= e($cat['name']) ?></option>
                <?php endforeach; ?>
            </select>
        </label>
        
        <label>
            <span>Deskripsi Singkat</span>
            <textarea name="description" rows="3" placeholder="Sinopsis atau deskripsi buku"><?= e($editingBook['description'] ?? ''); ?></textarea>
        </label>
        
        <button class="btn btn-primary" type="submit"><?= $editingBook ? 'Update Buku' : 'Simpan Buku'; ?></button>
        <?php if ($editingBook): ?>
            <a class="btn btn-light" href="<?= page_url('admin-books.php'); ?>">Batal Edit</a>
        <?php endif; ?>
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
                                <img src="<?= media_url($book['cover_image'] ?: 'images/logo.png'); ?>" alt="Cover <?= e($book['title']); ?>" style="width:64px;height:92px;object-fit:cover;border-radius:8px;box-shadow:0 8px 18px rgba(12,47,89,.14);">
                                <strong><?= e($book['title']); ?></strong>
                            </div>
                        </td>
                        <td><?= e($book['author'] ?? '-'); ?></td>
                        <td><?= e($book['publisher'] ?? '-'); ?> (<?= e($book['publication_year'] ?? '-'); ?>)</td>
                        <td><?= e($book['category_name'] ?? '-'); ?></td>
                        <td><?= e($book['stock']); ?> (<?= e($book['available_stock']); ?>)</td>
                        <td style="display:flex;gap:0.5rem;align-items:center;">
                            <a class="text-link" href="<?= page_url('book-detail.php?id=' . $book['id']); ?>">View</a>
                            <a class="text-link" href="<?= page_url('admin-books.php?edit=' . $book['id'] . '#bookForm'); ?>">Edit</a>
                            
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

