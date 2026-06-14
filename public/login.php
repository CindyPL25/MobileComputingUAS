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
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    
    if (empty($email) || empty($password)) {
        $error = 'Email dan password harus diisi';
    } else {
        $userModel = new User();
        
        // Find user by email ONLY (not NIM)
        $user = $userModel->getByEmail($email);
        
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
        <span>Mobile E-Library</span>
    </a>
    <section class="auth-card">
        <span class="eyebrow">Masuk akun</span>
        <h1>Selamat datang kembali</h1>
        <?php if ($error): ?>
            <div class="alert alert-danger"><?= e($error); ?></div>
        <?php endif; ?>
        <form class="form-stack" action="<?= page_url('login.php'); ?>" method="post">
            <label>
                <span>Email</span>
                <input type="email" name="email" placeholder="nama@student.ac.id" required>
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