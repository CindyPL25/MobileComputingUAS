<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

use App\Models\User;

$userModel = new User();
$successMessage = '';
$errorMessage = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $data = [
            'name' => trim($_POST['name'] ?? ''),
            'email' => trim($_POST['email'] ?? ''),
            'phone' => trim($_POST['phone'] ?? ''),
            'address' => trim($_POST['address'] ?? ''),
        ];

        $existingEmail = $userModel->getByEmail($data['email']);
        if ($existingEmail && (int) $existingEmail['id'] !== (int) $_SESSION['user']['id']) {
            throw new \RuntimeException('Email sudah digunakan akun lain.');
        }

        $userModel->update($_SESSION['user']['id'], $data);
        $_SESSION['user'] = $userModel->getById($_SESSION['user']['id']);
        $successMessage = 'Profil admin berhasil diperbarui.';
    } catch (\Exception $e) {
        $errorMessage = 'Gagal memperbarui profil admin: ' . $e->getMessage();
    }
}

$pageTitle = 'Profil Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Profil Admin';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/profile-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

