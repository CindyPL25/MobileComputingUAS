<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">Profil mahasiswa</span>
        <h1>Akun pengguna</h1>
        <p>Informasi akun Anda di sistem E-Library kampus.</p>
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
            <div class="avatar"><?= e(substr($user['name'] ?? 'User', 0, 2)); ?></div>
            <h2><?= e($user['name'] ?? 'Pengguna'); ?></h2>
            <p><?= e($user['major'] ?? 'Program Studi'); ?></p>
        </article>

        <article class="info-card">
            <h2>Informasi akun</h2>
            <form class="form-stack" method="post" action="<?= page_url('profile.php'); ?>">
                <label>
                    <span>Nama Lengkap</span>
                    <input type="text" name="name" value="<?= e($user['name'] ?? ''); ?>" required>
                </label>
                <label>
                    <span>NIM</span>
                    <input type="text" value="<?= e($user['nim'] ?? '-'); ?>" disabled>
                </label>
                <label>
                    <span>Email</span>
                    <input type="email" name="email" value="<?= e($user['email'] ?? ''); ?>" required>
                </label>
                <label>
                    <span>Jurusan</span>
                    <input type="text" name="major" value="<?= e($user['major'] ?? ''); ?>">
                </label>
                <label>
                    <span>Telepon</span>
                    <input type="text" name="phone" value="<?= e($user['phone'] ?? ''); ?>">
                </label>
                <label>
                    <span>Alamat</span>
                    <textarea name="address" rows="3"><?= e($user['address'] ?? ''); ?></textarea>
                </label>
                <button class="btn btn-primary" type="submit">Simpan Profil</button>
            </form>
        </article>
    </section>
</main>

