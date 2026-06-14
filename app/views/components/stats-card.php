<article class="stats-card <?= e($tone ?? ''); ?>">
    <span class="stats-icon"><?= e($icon ?? ''); ?></span>
    <div>
        <strong><?= e((string) $value); ?></strong>
        <span><?= e($label); ?></span>
    </div>
</article>

