<?php
require_once __DIR__ . '/../app/helpers/functions.php';
$pageTitle = 'Register - Mobile E-Library Kampus';
$bodyClass = 'auth-page';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="auth-shell">
    <a class="auth-brand" href="<?= page_url('index.php'); ?>">
        <img src="<?= asset_url('images/logo.png'); ?>" alt="Logo E-Library">
        <span>Mobile E-Library</span>
    </a>
    <section class="auth-card">
        <span class="eyebrow">Akun baru</span>
        <h1>Daftar mahasiswa</h1>
        <form class="form-stack" action="<?= page_url('dashboard.php'); ?>" method="get">
            <label>
                <span>Nama Lengkap</span>
                <input type="text" name="name" placeholder="Nama lengkap" required>
            </label>
            <label>
                <span>NIM</span>
                <input type="text" name="nim" placeholder="2304010101" required>
            </label>
            <label>
                <span>Email</span>
                <input type="email" name="email" placeholder="nama@student.ac.id" required>
            </label>
            <label>
                <span>Password</span>
                <input type="password" name="password" placeholder="Buat password" required>
            </label>
            <button class="btn btn-primary full-width" type="submit">Daftar</button>
        </form>
        <p class="auth-switch">Sudah punya akun? <a href="<?= page_url('login.php'); ?>">Kembali ke login</a></p>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

