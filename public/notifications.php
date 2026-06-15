<?php
require_once __DIR__ . '/autoload.php';
require_once __DIR__ . '/../app/helpers/functions.php';

// Check if user is logged in
requireLogin();

use App\Models\Notification;

$notificationModel = new Notification();

// Handle mark as read
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['mark_read'])) {
    $notificationId = (int) $_POST['notification_id'];
    $notificationModel->markAsRead($notificationId, $_SESSION['user']['id']);
    // redirect to avoid form resubmission
    header("Location: " . page_url('notifications.php'));
    exit;
}

// Load notifications for the logged-in user
$notifications = $notificationModel->getByUserId($_SESSION['user']['id']);

$pageTitle = 'Notifikasi - Mobile E-Library Kampus';
require_once __DIR__ . '/../app/views/layouts/header.php';
require_once __DIR__ . '/../app/views/layouts/navbar.php';
?>
<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">Pemberitahuan</span>
        <h1>Notifikasi</h1>
        <p>Lihat pembaruan, pengingat, dan aktivitas akun Anda.</p>
    </section>

    <section class="history-list">
        <?php if (empty($notifications)): ?>
            <div style="text-align: center; padding: 2rem; color: #666;">
                Belum ada notifikasi saat ini.
            </div>
        <?php else: ?>
            <?php foreach ($notifications as $notification): ?>
                <article class="history-card" style="<?= $notification['is_read'] ? 'opacity: 0.7;' : 'border-left: 4px solid var(--primary-color);' ?>">
                    <div>
                        <h2 style="font-size: 1.1rem; margin-bottom: 0.25rem;">
                            <?= e($notification['title']); ?>
                        </h2>
                        <p style="margin-bottom: 0.5rem; color: var(--text-color);"><?= e($notification['message']); ?></p>
                        <p style="font-size: 0.8rem; color: #888;">
                            <?= e(formatDate($notification['created_at'])); ?> 
                            (<?= e(ucfirst($notification['notification_type'])); ?>)
                        </p>
                    </div>
                    <?php if (!$notification['is_read']): ?>
                        <div style="margin-top: 1rem;">
                            <form method="POST" action="">
                                <input type="hidden" name="notification_id" value="<?= e($notification['id']) ?>">
                                <button type="submit" name="mark_read" style="background: none; border: 1px solid var(--primary-color); color: var(--primary-color); padding: 4px 12px; border-radius: 4px; cursor: pointer;">
                                    Tandai Dibaca
                                </button>
                            </form>
                        </div>
                    <?php endif; ?>
                </article>
            <?php endforeach; ?>
        <?php endif; ?>
    </section>
</main>
<?php
require_once __DIR__ . '/../app/views/layouts/bottom-nav.php';
require_once __DIR__ . '/../app/views/layouts/footer.php';
