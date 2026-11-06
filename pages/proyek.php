<?php
require ROOT . '/includes/data.php';
$p = data_proyek((string) ($_GET['slug'] ?? ''));
if (!$p) { http_response_code(404); require ROOT . '/pages/404.php'; exit; }
$s = setting();
$info = array_filter(['Klien' => $p['klien'] ?: 'Proyek pribadi', 'Peran' => $p['peran'], 'Tahun' => $p['tahun'], 'Durasi' => $p['durasi']]);
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= meta_head($p['judul'] . ' · ' . $s['nama'], $p['ringkasan'], gambar($p['cover'])) ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?<?= FONT_SITE ?>&display=swap">
    <link rel="stylesheet" href="assets/css/site.css">
    <?= css_aksen() ?>
    <script>document.documentElement.classList.add('js')</script>
</head>
<body class="detail">
<div class="progress" aria-hidden="true"><i></i></div>
<header class="nav solid">
    <a href="index.php" class="brand"><?= icon('arrow-left', 20) ?><span>Kembali</span></a>
    <nav class="links"><a href="index.php#proyek">Semua proyek</a><a href="index.php#kontak" class="btn btn-acc">Ajak kerja sama <?= icon('arrow-up-right', 16) ?></a></nav>
</header>
<main>
    <section class="wrap d-hero">
        <p class="kicker mono"><?= e($p['kategori']) ?> &middot; <?= $p['tahun'] ?></p>
        <h1><?= e($p['judul']) ?></h1>
        <p class="lead"><?= e($p['ringkasan']) ?></p>
        <div class="d-links">
            <?php if ($u = link_aman($p['link_demo'])): ?><a class="btn btn-acc" href="<?= e($u) ?>" target="_blank" rel="noopener"><?= icon('external-link', 18) ?> Lihat live</a><?php endif; ?>
            <?php if ($u = link_aman($p['link_repo'])): ?><a class="btn btn-line" href="<?= e($u) ?>" target="_blank" rel="noopener"><?= icon('code-xml', 18) ?> Source / dokumen</a><?php endif; ?>
        </div>
    </section>
    <div class="d-cover-stage"><figure class="d-cover" id="dcover"><img src="<?= e(gambar($p['cover'])) ?>" alt="<?= e($p['judul']) ?>"></figure></div>
    <section class="wrap d-body">
        <aside class="d-side">
            <dl><?php foreach ($info as $k => $v): ?><dt class="mono"><?= $k ?></dt><dd><?= e($v) ?></dd><?php endforeach; ?></dl>
            <?php if ($p['tek']): ?><p class="mono side-h">Teknologi</p><ul class="d-tek"><?php foreach ($p['tek'] as $t): ?><li><?= logo($t['logo'], 20, $t['nama']) ?> <?= e($t['nama']) ?></li><?php endforeach; ?></ul><?php endif; ?>
        </aside>
        <article class="prose rv"><?= markdown_mini($p['isi']) ?></article>
    </section>
    <?php if ($p['galeri']): ?>
    <section class="wrap">
        <div class="gallery">
            <?php foreach ($p['galeri'] as $g): ?>
                <figure class="rv" data-tilt><a href="<?= e(gambar($g['file'])) ?>" data-lb><img src="<?= e(gambar($g['file'])) ?>" alt="<?= e($g['keterangan']) ?>" loading="lazy"></a><?php if ($g['keterangan']): ?><figcaption class="mono"><?= e($g['keterangan']) ?></figcaption><?php endif; ?></figure>
            <?php endforeach; ?>
        </div>
    </section>
    <?php endif; ?>
    <?php if ($p['berikut']): ?>
    <nav class="wrap d-next">
        <a href="<?= url('proyek', ['slug' => $p['sebelum']['slug']]) ?>" class="rv"><small class="mono"><?= icon('arrow-left', 14) ?> Sebelumnya</small><b><?= e($p['sebelum']['judul']) ?></b></a>
        <a href="<?= url('proyek', ['slug' => $p['berikut']['slug']]) ?>" class="rv next"><small class="mono">Berikutnya <?= icon('arrow-right', 14) ?></small><b><?= e($p['berikut']['judul']) ?></b></a>
    </nav>
    <?php endif; ?>
</main>
<div class="lightbox" id="lb" hidden><button class="icon-btn" aria-label="Tutup"><?= icon('x', 24) ?></button><img alt=""></div>
<footer class="foot"><div class="wrap foot-row"><span>&copy; <?= date('Y') ?> <?= e($s['nama']) ?></span><a href="index.php#kontak">Ajak kerja sama</a></div></footer>
<script src="assets/js/site.js"></script>
</body>
</html>
