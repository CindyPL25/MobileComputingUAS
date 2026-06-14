<section class="admin-page-title">
    <div>
        <span class="eyebrow">Profil admin</span>
        <h1>Akun pengelola perpustakaan</h1>
        <p>Informasi akun admin untuk layanan perpustakaan digital.</p>
    </div>
</section>

<section class="profile-layout">
    <article class="profile-card">
        <div class="avatar"><?= e(substr($_SESSION['user']['name'] ?? 'Admin', 0, 2)); ?></div>
        <h2><?= e($_SESSION['user']['name'] ?? 'Admin Perpustakaan'); ?></h2>
        <p><?= e($_SESSION['user']['role'] === 'admin' ? 'Petugas layanan digital kampus' : 'Pengguna'); ?></p>
        <button class="btn btn-primary" type="button">Edit Profil</button>
    </article>

    <article class="info-card">
        <h2>Informasi admin</h2>
        <dl class="profile-list">
            <div>
                <dt>Nama</dt>
                <dd><?= e($_SESSION['user']['name'] ?? '-'); ?></dd>
            </div>
            <div>
                <dt>Email</dt>
                <dd><?= e($_SESSION['user']['email'] ?? '-'); ?></dd>
            </div>
            <div>
                <dt>Role</dt>
                <dd><?= e(ucfirst($_SESSION['user']['role'] ?? '-')); ?></dd>
            </div>
            <div>
                <dt>Status</dt>
                <dd><?= e(ucfirst($_SESSION['user']['status'] ?? '-')); ?></dd>
            </div>
        </dl>
    </article>
</section>

