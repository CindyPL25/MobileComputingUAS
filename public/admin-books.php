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
$editingBook = null;

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'add') {
        $stock = max(0, (int) ($_POST['stock'] ?? 0));
        $bookCode = trim($_POST['book_code'] ?? '');
        if ($bookCode === '') {
            $bookCode = 'BK-' . date('YmdHis');
        }

        $data = [
            'title' => trim($_POST['title'] ?? ''),
            'author' => trim($_POST['author'] ?? ''),
            'publisher' => trim($_POST['publisher'] ?? ''),
            'publication_year' => ($_POST['publication_year'] ?? '') !== '' ? (int) $_POST['publication_year'] : null,
            'isbn' => trim($_POST['isbn'] ?? ''),
            'category_id' => (int) ($_POST['category_id'] ?? 0),
            'description' => trim($_POST['description'] ?? ''),
            'cover_image' => trim($_POST['cover_image'] ?? ''),
            'stock' => $stock,
            'available_stock' => $stock,
            'book_code' => $bookCode
        ];
        
        try {
            $bookModel->insert($data);
            $successMessage = "Buku berhasil ditambahkan.";
        } catch (\Exception $e) {
            $errorMessage = "Gagal menambah buku: " . $e->getMessage();
        }
    } elseif ($action === 'edit') {
        $id = (int) ($_POST['id'] ?? 0);
        
        try {
            $currentBook = $bookModel->getById($id);
            if (!$currentBook) {
                throw new \RuntimeException('Buku tidak ditemukan.');
            }

            $stock = max(0, (int) ($_POST['stock'] ?? 0));
            $borrowedCopies = $bookModel->countActiveBorrowedCopies($id);
            if ($stock < $borrowedCopies) {
                throw new \RuntimeException('Stok tidak boleh lebih kecil dari jumlah buku yang sedang dipinjam.');
            }

            $data = [
                'title' => trim($_POST['title'] ?? ''),
                'author' => trim($_POST['author'] ?? ''),
                'publisher' => trim($_POST['publisher'] ?? ''),
                'publication_year' => ($_POST['publication_year'] ?? '') !== '' ? (int) $_POST['publication_year'] : null,
                'isbn' => trim($_POST['isbn'] ?? ''),
                'category_id' => (int) ($_POST['category_id'] ?? 0),
                'description' => trim($_POST['description'] ?? ''),
                'cover_image' => trim($_POST['cover_image'] ?? ''),
                'book_code' => trim($_POST['book_code'] ?? $currentBook['book_code']),
                'stock' => $stock,
                'available_stock' => $stock - $borrowedCopies
            ];

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

if (isset($_GET['edit'])) {
    $editingBook = $bookModel->getById((int) $_GET['edit']);
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

