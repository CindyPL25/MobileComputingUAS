<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

use App\Models\User;

// Check if user is already logged in
if (isLoggedIn()) {
    header('Location: ' . page_url('dashboard.php'));
    exit;
}

// Handle login attempt
$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $identity = trim($_POST['identity'] ?? '');
    $password = $_POST['password'] ?? '';
    
    if (empty($identity) || empty($password)) {
        $error = 'Email/NIM dan password harus diisi';
    } else {
        $userModel = new User();
        
        $user = $userModel->getByEmail($identity) ?: $userModel->getByNim($identity);
        
        if ($user && $user['role'] === 'mahasiswa' && $user['status'] === 'aktif' && password_verify($password, $user['password'])) {
            // Authentication successful
            $_SESSION['user'] = $user;
            header('Location: ' . page_url('dashboard.php'));
            exit;
        } else {
            $error = 'Email atau password tidak valid';
        }
    }
}

$pageTitle = 'Login - Mobile E-Library Kampus';
$bodyClass = 'auth-page';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="auth-shell">
    <a class="auth-brand" href="<?= page_url('index.php'); ?>">
        <img src="<?= asset_url('images/logo.png'); ?>" alt="Logo E-Library">
        <span>Kembali ke E-Library</span>
    </a>
    <section class="auth-card">
        <span class="eyebrow">Masuk akun</span>
        <h1>Selamat datang kembali</h1>
        <?php if ($error): ?>
            <div class="alert alert-danger"><?= e($error); ?></div>
        <?php endif; ?>
        <form class="form-stack" action="<?= page_url('login.php'); ?>" method="post">
            <label>
                <span>Email atau NIM</span>
                <input type="text" name="identity" placeholder="nama@student.ac.id / 2201001" required>
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
