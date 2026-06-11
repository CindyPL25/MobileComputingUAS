<section class="admin-page-title">
    <div>
        <span class="eyebrow">Mahasiswa</span>
        <h1>Data pengguna aplikasi</h1>
        <p>Kelola akun mahasiswa yang akan memakai layanan mobile e-library.</p>
    </div>
    <button class="btn btn-primary" type="button">Tambah Mahasiswa</button>
</section>

<section class="admin-user-grid">
    <?php foreach ($users as $user): ?>
        <article class="admin-user-card">
            <div class="admin-avatar"><?= e(substr($user['name'], 0, 1)); ?></div>
            <div>
                <h2><?= e($user['name']); ?></h2>
                <p><?= e($user['nim']); ?> · <?= e($user['major']); ?></p>
                <span><?= e($user['email']); ?></span>
            </div>
            <em class="<?= strtolower($user['status']) === 'aktif' ? 'is-good' : 'is-muted'; ?>"><?= e($user['status']); ?></em>
        </article>
    <?php endforeach; ?>
</section>

