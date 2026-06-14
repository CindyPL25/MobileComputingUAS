<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

use App\Models\User;

// Check if user is already logged in
if (isLoggedIn()) {
    header('Location: ' . page_url('dashboard.php'));
    exit;
}

// Handle registration attempt
$error = '';
$success = '';
$old = [
    'name' => '',
    'nim' => '',
    'email' => '',
    'major' => '',
];
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $nim = trim($_POST['nim'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $major = trim($_POST['major'] ?? '');
    $password = $_POST['password'] ?? '';
    $old = compact('name', 'nim', 'email', 'major');
    
    $userModel = new User();
    
    // Check if user already exists
    if ($userModel->getByNim($nim) || $userModel->getByEmail($email)) {
        $error = 'NIM atau Email sudah terdaftar';
    } else if (strlen($password) < 6) {
        $error = 'Password minimal 6 karakter';
    } else {
        // Create new user
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $newUserId = $userModel->insert([
            'nim' => $nim,
            'name' => $name,
            'email' => $email,
            'password' => $hashedPassword,
            'role' => 'mahasiswa',
            'major' => $major,
            'status' => 'aktif'
        ]);
        
        if ($newUserId) {
            $success = 'Registrasi berhasil! Silakan login dengan akun baru Anda.';
            $old = ['name' => '', 'nim' => '', 'email' => '', 'major' => ''];
        } else {
            $error = 'Gagal membuat akun. Silakan coba lagi.';
        }
    }
}

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
        <?php if ($error): ?>
            <div class="alert alert-danger"><?= e($error); ?></div>
        <?php endif; ?>
        <?php if ($success): ?>
            <div class="alert alert-success"><?= e($success); ?></div>
        <?php endif; ?>
        <form class="form-stack" action="<?= page_url('register.php'); ?>" method="post">
            <label>
                <span>Nama Lengkap</span>
                <input type="text" name="name" placeholder="Nama lengkap" value="<?= e($old['name']); ?>" required>
            </label>
            <label>
                <span>NIM</span>
                <input type="text" name="nim" placeholder="2304010101" value="<?= e($old['nim']); ?>" required>
            </label>
            <label>
                <span>Email</span>
                <input type="email" name="email" placeholder="nama@student.ac.id" value="<?= e($old['email']); ?>" required>
            </label>
            <label>
                <span>Program Studi</span>
                <input type="text" name="major" placeholder="Teknik Informatika" value="<?= e($old['major']); ?>">
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

