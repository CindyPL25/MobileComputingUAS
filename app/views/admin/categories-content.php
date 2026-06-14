<section class="admin-page-title">
    <div>
        <span class="eyebrow">Manajemen Kategori</span>
        <h1>Data Kategori Buku</h1>
        <p>Kelola daftar kategori buku perpustakaan.</p>
    </div>
    <a class="btn btn-primary" href="#categoryForm">Tambah Kategori</a>
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

<section class="admin-panel" id="categoryForm">
    <div class="admin-panel-heading">
        <h2><?= $editingCategory ? 'Edit Kategori' : 'Form Kategori'; ?></h2>
        <span><?= $editingCategory ? 'Perbarui kategori' : 'Tambah kategori baru'; ?></span>
    </div>
    <form class="admin-form" method="POST" action="">
        <input type="hidden" name="action" value="<?= $editingCategory ? 'edit' : 'add'; ?>">
        <?php if ($editingCategory): ?>
            <input type="hidden" name="id" value="<?= e((string) $editingCategory['id']); ?>">
        <?php endif; ?>
        
        <label>
            <span>Nama Kategori</span>
            <input type="text" name="name" value="<?= e($editingCategory['name'] ?? ''); ?>" placeholder="Nama Kategori (Maks 100 char)" required>
        </label>
        
        <label>
            <span>Deskripsi</span>
            <textarea name="description" rows="3" placeholder="Deskripsi Kategori"><?= e($editingCategory['description'] ?? ''); ?></textarea>
        </label>
        
        <button class="btn btn-primary" type="submit"><?= $editingCategory ? 'Update Kategori' : 'Simpan Kategori'; ?></button>
        <?php if ($editingCategory): ?>
            <a class="btn btn-light" href="<?= page_url('admin-categories.php'); ?>">Batal Edit</a>
        <?php endif; ?>
    </form>
</section>

<section class="admin-panel">
    <div class="admin-panel-heading">
        <h2>Daftar Kategori</h2>
        <span><?= count($categories); ?> kategori</span>
    </div>
    <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Nama Kategori</th>
                    <th>Deskripsi</th>
                    <th>Jumlah Buku</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($categories as $cat): ?>
                    <tr>
                        <td><strong><?= e($cat['name']); ?></strong></td>
                        <td><?= e($cat['description'] ?? '-'); ?></td>
                        <td><?= e($cat['book_count'] ?? 0); ?> Buku</td>
                        <td style="display:flex;gap:0.5rem;align-items:center;">
                            <a class="text-link" href="<?= page_url('admin-categories.php?edit=' . $cat['id'] . '#categoryForm'); ?>">Edit</a>
                            <form method="POST" style="display:inline;" onsubmit="return confirm('Hapus kategori ini? Pastikan tidak ada buku yang masih memakai kategori ini.');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<?= e($cat['id']) ?>">
                                <button type="submit" style="background:none;border:none;color:red;cursor:pointer;padding:0;">Hapus</button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</section>
