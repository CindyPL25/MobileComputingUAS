<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is logged in
requireLogin();

// Load user data from database
use App\Models\User;

$userModel = new User();
$successMessage = '';
$errorMessage = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $data = [
            'name' => trim($_POST['name'] ?? ''),
            'email' => trim($_POST['email'] ?? ''),
            'major' => trim($_POST['major'] ?? ''),
            'phone' => trim($_POST['phone'] ?? ''),
            'address' => trim($_POST['address'] ?? ''),
        ];

        $existingEmail = $userModel->getByEmail($data['email']);
        if ($existingEmail && (int) $existingEmail['id'] !== (int) $_SESSION['user']['id']) {
            throw new \RuntimeException('Email sudah digunakan akun lain.');
        }

        $userModel->update($_SESSION['user']['id'], $data);
        $_SESSION['user'] = $userModel->getById($_SESSION['user']['id']);
        $successMessage = 'Profil berhasil diperbarui.';
    } catch (\Exception $e) {
        $errorMessage = 'Gagal memperbarui profil: ' . $e->getMessage();
    }
}

$user = $userModel->getUserWithStats($_SESSION['user']['id']);

$pageTitle = 'Profil - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
require_once __DIR__ . '/../app/views/pages/profile-content.php';
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';

