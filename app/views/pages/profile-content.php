<main class="page-shell">
    <section class="page-title">
        <span class="eyebrow">Profil mahasiswa</span>
        <h1>Akun pengguna</h1>
        <p>Informasi akun Anda di sistem E-Library kampus.</p>
    </section>

    <section class="profile-layout">
        <article class="profile-card">
            <div class="avatar"><?= e(substr($user['name'] ?? 'User', 0, 2)); ?></div>
            <h2><?= e($user['name'] ?? 'Pengguna'); ?></h2>
            <p><?= e($user['major'] ?? 'Program Studi'); ?></p>
            <a class="btn btn-primary" href="#">Edit Profil</a>
        </article>

        <article class="info-card">
            <h2>Informasi akun</h2>
            <dl class="profile-list">
                <div>
                    <dt>Nama Lengkap</dt>
                    <dd><?= e($user['name'] ?? '-'); ?></dd>
                </div>
                <div>
                    <dt>NIM</dt>
                    <dd><?= e($user['nim'] ?? '-'); ?></dd>
                </div>
                <div>
                    <dt>Email</dt>
                    <dd><?= e($user['email'] ?? '-'); ?></dd>
                </div>
                <div>
                    <dt>Jurusan</dt>
                    <dd><?= e($user['major'] ?? '-'); ?></dd>
                </div>
            </dl>
        </article>
    </section>
</main>

