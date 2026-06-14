<section class="admin-page-title">
    <div>
        <span class="eyebrow">Mahasiswa</span>
        <h1>Data pengguna aplikasi</h1>
        <p>Kelola akun mahasiswa yang akan memakai layanan mobile e-library.</p>
    </div>
    <a class="btn btn-primary" href="#userForm">Tambah Mahasiswa</a>
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

<section class="admin-panel" id="userForm">
    <div class="admin-panel-heading">
        <h2>Form Mahasiswa</h2>
        <span>Buat akun baru</span>
    </div>
    <form class="admin-form" method="POST" action="">
        <input type="hidden" name="action" value="add">
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>NIM</span>
                <input type="text" name="nim" placeholder="NIM Mahasiswa" required>
            </label>
            <label>
                <span>Nama Lengkap</span>
                <input type="text" name="name" placeholder="Nama Mahasiswa" required>
            </label>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>Email</span>
                <input type="email" name="email" placeholder="Email Mahasiswa" required>
            </label>
            <label>
                <span>Password (Default)</span>
                <input type="text" name="password" value="123456" required>
            </label>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <label>
                <span>Program Studi</span>
                <input type="text" name="major" placeholder="Jurusan/Prodi">
            </label>
            <label>
                <span>Status</span>
                <select name="status">
                    <option value="aktif">Aktif</option>
                    <option value="nonaktif">Nonaktif</option>
                </select>
            </label>
        </div>
        
        <button class="btn btn-primary" type="submit">Simpan Mahasiswa</button>
    </form>
</section>

<section class="admin-user-grid">
    <?php foreach ($users as $user): ?>
        <article class="admin-user-card" style="position:relative;">
            <div class="admin-avatar"><?= e(substr($user['name'], 0, 1)); ?></div>
            <div>
                <h2><?= e($user['name']); ?></h2>
                <p><?= e($user['nim']); ?> · <?= e($user['major']); ?></p>
                <span><?= e($user['email']); ?></span>
            </div>
            
            <div style="display:flex; flex-direction:column; align-items:flex-end; justify-content:space-between;">
                <em class="<?= strtolower($user['status']) === 'aktif' ? 'is-good' : 'is-muted'; ?>" style="margin-bottom:auto;"><?= e($user['status']); ?></em>
                <form method="POST" onsubmit="return confirm('Hapus mahasiswa ini?');" style="margin-top:10px;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<?= e($user['id']); ?>">
                    <button type="submit" style="background:none; border:none; color:red; cursor:pointer; font-size:12px; text-decoration:underline; padding:0;">Hapus</button>
                </form>
            </div>
        </article>
    <?php endforeach; ?>
</section>

