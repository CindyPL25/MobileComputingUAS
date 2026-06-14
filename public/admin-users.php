<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

// Load data from database
use App\Models\User;

$userModel = new User();

$successMessage = '';
$errorMessage = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'add') {
        $nim = trim($_POST['nim'] ?? '');
        $email = trim($_POST['email'] ?? '');
        
        // Cek NIM atau email sudah ada
        $existingNim = $userModel->findBy('nim', $nim);
        $existingEmail = $userModel->findBy('email', $email);
        
        if ($existingNim || $existingEmail) {
            $errorMessage = "NIM atau Email sudah terdaftar!";
        } else {
            $data = [
                'nim' => $nim,
                'name' => $_POST['name'] ?? '',
                'email' => $email,
                'password' => password_hash($_POST['password'] ?? '123456', PASSWORD_BCRYPT),
                'role' => 'mahasiswa',
                'major' => $_POST['major'] ?? '',
                'status' => $_POST['status'] ?? 'aktif'
            ];
            
            try {
                $userModel->insert($data);
                $successMessage = "Mahasiswa berhasil ditambahkan.";
            } catch (\Exception $e) {
                $errorMessage = "Gagal menambah mahasiswa: " . $e->getMessage();
            }
        }
    } elseif ($action === 'delete') {
        $id = $_POST['id'] ?? 0;
        try {
            $userModel->delete($id);
            $successMessage = "Mahasiswa berhasil dihapus.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal menghapus mahasiswa (mungkin masih ada riwayat pinjam).";
        }
    }
}

// Get all mahasiswa users
$users = $userModel->getAllMahasiswa();

$pageTitle = 'Mahasiswa Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Mahasiswa';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/users-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

