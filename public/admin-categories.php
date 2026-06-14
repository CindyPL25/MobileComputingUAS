<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

use App\Models\Category;

$categoryModel = new Category();

$successMessage = '';
$errorMessage = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'add') {
        $data = [
            'name' => $_POST['name'] ?? '',
            'description' => $_POST['description'] ?? ''
        ];
        
        try {
            $categoryModel->insert($data);
            $successMessage = "Kategori berhasil ditambahkan.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal menambah kategori: " . $e->getMessage();
        }
    } elseif ($action === 'edit') {
        $id = $_POST['id'] ?? 0;
        $data = [
            'name' => $_POST['name'] ?? '',
            'description' => $_POST['description'] ?? ''
        ];
        
        try {
            $categoryModel->update($id, $data);
            $successMessage = "Kategori berhasil diperbarui.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal memperbarui kategori: " . $e->getMessage();
        }
    } elseif ($action === 'delete') {
        $id = $_POST['id'] ?? 0;
        try {
            $categoryModel->delete($id);
            $successMessage = "Kategori berhasil dihapus.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal menghapus kategori (mungkin masih digunakan pada buku).";
        }
    }
}

// Get all categories with book count
$categories = $categoryModel->getAllWithBookCount();

$pageTitle = 'Kategori Buku - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Kategori Buku';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/categories-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>
