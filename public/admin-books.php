<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is admin
requireAdmin();

// Load data from database
use App\Models\Book;
use App\Models\Category;

$bookModel = new Book();
$categoryModel = new Category();

$successMessage = '';
$errorMessage = '';

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'add') {
        $data = [
            'title' => $_POST['title'] ?? '',
            'author' => $_POST['author'] ?? '',
            'publisher' => $_POST['publisher'] ?? '',
            'publication_year' => $_POST['publication_year'] ?? '',
            'isbn' => $_POST['isbn'] ?? '',
            'category_id' => $_POST['category_id'] ?? 0,
            'description' => $_POST['description'] ?? '',
            'stock' => (int)($_POST['stock'] ?? 0),
            'available_stock' => (int)($_POST['stock'] ?? 0),
            'book_code' => $_POST['book_code'] ?? 'BK-' . time()
        ];
        
        try {
            $bookModel->insert($data);
            $successMessage = "Buku berhasil ditambahkan.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal menambah buku: " . $e->getMessage();
        }
    } elseif ($action === 'edit') {
        $id = $_POST['id'] ?? 0;
        $data = [
            'title' => $_POST['title'] ?? '',
            'author' => $_POST['author'] ?? '',
            'publisher' => $_POST['publisher'] ?? '',
            'publication_year' => $_POST['publication_year'] ?? '',
            'isbn' => $_POST['isbn'] ?? '',
            'category_id' => $_POST['category_id'] ?? 0,
            'description' => $_POST['description'] ?? '',
            'stock' => (int)($_POST['stock'] ?? 0),
            'available_stock' => (int)($_POST['available_stock'] ?? 0)
        ];
        
        try {
            $bookModel->update($id, $data);
            $successMessage = "Buku berhasil diperbarui.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal memperbarui buku: " . $e->getMessage();
        }
    } elseif ($action === 'delete') {
        $id = $_POST['id'] ?? 0;
        try {
            $bookModel->delete($id);
            $successMessage = "Buku berhasil dihapus.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal menghapus buku (mungkin sedang dipinjam).";
        }
    }
}

// Get all books with category
$books = $bookModel->getAllWithCategory();

// Get all categories for filters
$categories = $categoryModel->getAll();

$pageTitle = 'Data Buku Admin - Mobile E-Library Kampus';
$bodyClass = 'admin-body';
$adminTitle = 'Data Buku';
require_once __DIR__ . '/../app/views/layouts/header.php';
?>
<main class="admin-app">
    <?php require_once __DIR__ . '/../app/views/layouts/admin-sidebar.php'; ?>
    <section class="admin-main">
        <?php require_once __DIR__ . '/../app/views/layouts/admin-topbar.php'; ?>
        <?php require_once __DIR__ . '/../app/views/admin/books-content.php'; ?>
    </section>
</main>
<?php require_once __DIR__ . '/../app/views/layouts/footer.php'; ?>

