<?php
require_once __DIR__ . '/../app/helpers/functions.php';
$pageTitle = 'Login - Mobile E-Library Kampus';
$bodyClass = 'auth-page';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="auth-shell">
    <a class="auth-brand" href="<?= page_url('index.php'); ?>">
        <img src="<?= asset_url('images/logo.png'); ?>" alt="Logo E-Library">
        <span>Mobile E-Library</span>
    </a>
    <section class="auth-card">
        <span class="eyebrow">Masuk akun</span>
        <h1>Selamat datang kembali</h1>
        <form class="form-stack" action="<?= page_url('dashboard.php'); ?>" method="get">
            <label>
                <span>Email atau NIM</span>
                <input type="text" name="identity" placeholder="nama@student.ac.id" required>
            </label>
            <label>
                <span>Password</span>
                <input type="password" name="password" placeholder="Masukkan password" required>
            </label>
            <button class="btn btn-primary full-width" type="submit">Login</button>
        </form>
        <p class="auth-switch">Belum punya akun? <a href="<?= page_url('register.php'); ?>">Daftar sekarang</a></p>
        <p class="auth-switch admin-auth-link"><a href="<?= page_url('admin-login.php'); ?>">Masuk sebagai admin perpustakaan</a></p>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>
