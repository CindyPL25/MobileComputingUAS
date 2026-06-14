<section class="admin-page-title">
    <div>
        <span class="eyebrow">Profil admin</span>
        <h1>Akun pengelola perpustakaan</h1>
        <p>Informasi akun admin untuk layanan perpustakaan digital.</p>
    </div>
</section>

<?php if (!empty($successMessage)): ?>
    <div class="alert alert-success" style="background:#d4edda;color:#155724;padding:1rem;border-radius:8px;margin-bottom:1rem;">
        <?= e($successMessage); ?>
    </div>
<?php endif; ?>
<?php if (!empty($errorMessage)): ?>
    <div class="alert alert-danger" style="background:#f8d7da;color:#721c24;padding:1rem;border-radius:8px;margin-bottom:1rem;">
        <?= e($errorMessage); ?>
    </div>
<?php endif; ?>

<section class="profile-layout">
    <article class="profile-card">
        <div class="avatar"><?= e(substr($_SESSION['user']['name'] ?? 'Admin', 0, 2)); ?></div>
        <h2><?= e($_SESSION['user']['name'] ?? 'Admin Perpustakaan'); ?></h2>
        <p><?= e(($_SESSION['user']['role'] ?? '') === 'admin' ? 'Petugas layanan digital kampus' : 'Pengguna'); ?></p>
    </article>

    <article class="info-card">
        <h2>Informasi admin</h2>
        <form class="form-stack" method="post" action="<?= page_url('admin-profile.php'); ?>">
            <label>
                <span>Nama</span>
                <input type="text" name="name" value="<?= e($_SESSION['user']['name'] ?? ''); ?>" required>
            </label>
            <label>
                <span>Email</span>
                <input type="email" name="email" value="<?= e($_SESSION['user']['email'] ?? ''); ?>" required>
            </label>
            <label>
                <span>Role</span>
                <input type="text" value="<?= e(ucfirst($_SESSION['user']['role'] ?? '-')); ?>" disabled>
            </label>
            <label>
                <span>Status</span>
                <input type="text" value="<?= e(ucfirst($_SESSION['user']['status'] ?? '-')); ?>" disabled>
            </label>
            <label>
                <span>Telepon</span>
                <input type="text" name="phone" value="<?= e($_SESSION['user']['phone'] ?? ''); ?>">
            </label>
            <label>
                <span>Alamat</span>
                <textarea name="address" rows="3"><?= e($_SESSION['user']['address'] ?? ''); ?></textarea>
            </label>
            <button class="btn btn-primary" type="submit">Simpan Profil</button>
        </form>
    </article>
</section>
