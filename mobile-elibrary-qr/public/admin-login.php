<?php
require_once __DIR__ . '/../app/helpers/functions.php';
$pageTitle = 'Login Admin - Mobile E-Library Kampus';
$bodyClass = 'auth-page';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="auth-shell admin-auth-shell">
    <a class="auth-brand" href="<?= page_url('index.php'); ?>">
        <img src="<?= asset_url('images/logo.png'); ?>" alt="Logo E-Library">
        <span>Admin E-Library</span>
    </a>
    <section class="auth-card admin-login-card">
        <span class="eyebrow">Panel pengelola</span>
        <h1>Masuk sebagai admin</h1>
        <p class="auth-note">Gunakan tampilan ini untuk simulasi akses petugas perpustakaan.</p>
        <form class="form-stack" action="<?= page_url('admin-dashboard.php'); ?>" method="get">
            <label>
                <span>Email Admin</span>
                <input type="email" name="email" placeholder="admin@kampus.ac.id" required>
            </label>
            <label>
                <span>Password</span>
                <input type="password" name="password" placeholder="Masukkan password" required>
            </label>
            <button class="btn btn-primary full-width" type="submit">Masuk Admin</button>
        </form>
        <p class="auth-switch"><a href="<?= page_url('login.php'); ?>">Kembali ke login mahasiswa</a></p>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>
