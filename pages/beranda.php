<?php
require ROOT . '/includes/data.php';
$D = data_beranda();
$s = setting();
$kontak = $_SESSION['kontak'] ?? null;
unset($_SESSION['kontak']);
$orbit = array_slice($D['unggulan_tek'], 0, 10);
$foto = gambar($s['foto'] ?? '', 'assets/img/potret.svg');
$wa = nomor_wa($s['whatsapp'] ?? '');

/** Bintang acak tapi tetap sama di setiap muat (seed tetap) supaya tidak "loncat". */
function bintang(int $n, int $seed, float $rMax): string
{
    mt_srand($seed);
    $o = '';
    for ($i = 0; $i < $n; $i++) $o .= '<circle cx="' . mt_rand(0, 1600) . '" cy="' . mt_rand(0, 1000) . '" r="' . round(mt_rand(5, (int) ($rMax * 10)) / 10, 1) . '" opacity="' . (mt_rand(35, 100) / 100) . '"/>';
    mt_srand();
    return $o;
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <?= meta_head($s['nama'] . ' · ' . $s['peran']) ?>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?<?= FONT_SITE ?>&display=swap">
    <link rel="stylesheet" href="assets/css/site.css">
    <?= css_aksen() ?>
    <script>document.documentElement.classList.add('js')</script>
</head>
<body>
<div class="progress" aria-hidden="true"><i></i></div>
<div class="sky" aria-hidden="true">
    <svg class="layer l1" viewBox="0 0 1600 1000" preserveAspectRatio="xMidYMid slice"><g fill="#e9ecff"><?= bintang(120, 11, 1.2) ?></g></svg>
    <svg class="layer l2" viewBox="0 0 1600 1000" preserveAspectRatio="xMidYMid slice"><g fill="#e9ecff"><?= bintang(60, 23, 2) ?></g></svg>
    <svg class="layer l3" viewBox="0 0 1600 1000" preserveAspectRatio="xMidYMid slice"><g fill="var(--acc)"><?= bintang(14, 37, 2.6) ?></g></svg>
</div>

<header class="nav" id="nav">
    <a href="#top" class="brand"><svg viewBox="0 0 40 40" width="34" height="34" aria-hidden="true"><circle cx="20" cy="20" r="8" fill="var(--acc)"/><ellipse cx="20" cy="20" rx="18" ry="7" fill="none" stroke="currentColor" stroke-width="2" transform="rotate(-25 20 20)"/></svg><span><?= e($s['nama']) ?></span></a>
    <nav class="links" id="links">
        <a href="#proyek">Proyek</a><a href="#keahlian">Keahlian</a><a href="#layanan">Layanan</a><a href="#jejak">Jejak</a><a href="#kontak" class="btn btn-acc">Ajak kerja sama <?= icon('arrow-up-right', 16) ?></a>
    </nav>
    <button class="burger" aria-label="Menu" onclick="document.body.classList.toggle('menu-open')"><?= icon('menu', 24) ?></button>
</header>

<main id="top">
    <!-- HERO -->
    <section class="hero wrap">
        <div class="hero-text">
            <?php if (($s['tersedia'] ?? '1') === '1'): ?><p class="status"><span class="dot"></span><?= e($s['status_teks']) ?></p><?php endif; ?>
            <p class="kicker mono"><?= e($s['peran']) ?> &middot; <?= e($s['kota']) ?></p>
            <h1 class="split"><?= e($s['judul_hero']) ?></h1>
            <p class="lead"><?= e($s['tagline']) ?></p>
            <div class="cta">
                <a href="#proyek" class="btn btn-acc"><?= icon('rocket', 18) ?> Lihat proyek</a>
                <?php if (!empty($s['cv'])): ?><a href="<?= e(gambar($s['cv'])) ?>" class="btn btn-line" download><?= icon('download', 18) ?> Unduh CV</a><?php endif; ?>
                <div class="soc"><?php foreach (sosial() as $so): ?><a href="<?= e($so['url']) ?>" target="_blank" rel="noopener" aria-label="<?= e($so['label']) ?>"><?= $so['svg'] ?></a><?php endforeach; ?></div>
            </div>
        </div>
        <div class="orbit-scene" aria-hidden="true"><div class="orbit-3d">
            <div class="planet"><img src="<?= e($foto) ?>" alt=""></div>
            <div class="moon m1"></div><div class="moon m2"></div>
            <?php foreach ([[0, 270, 40], [1, 196, 28]] as [$ri, $rad, $dur]): $items = array_values(array_filter($orbit, fn($k) => $k % 2 === $ri, ARRAY_FILTER_USE_KEY)); ?>
                <div class="ring r<?= $ri ?>" style="--rad:<?= $rad ?>px;--dur:<?= $dur ?>s">
                    <?php foreach ($items as $i => $t): ?>
                        <div class="sat" style="--a:<?= round(360 / max(1, count($items)) * $i) ?>deg"><div class="face"><?= logo($t['logo'], 26, $t['nama']) ?><small><?= e($t['nama']) ?></small></div></div>
                    <?php endforeach; ?>
                </div>
            <?php endforeach; ?>
        </div></div>
    </section>

    <!-- MARQUEE KLIEN -->
    <?php if ($D['klien']): ?>
    <section class="marquee" aria-label="Klien">
        <div class="track">
            <?php for ($r = 0; $r < 2; $r++): foreach ($D['klien'] as $k): ?><span><?= e($k) ?></span><svg viewBox="0 0 20 20" width="16" height="16" aria-hidden="true"><path d="M10 0l2.6 7.4L20 10l-7.4 2.6L10 20l-2.6-7.4L0 10l7.4-2.6z" fill="var(--acc)"/></svg><?php endforeach; endfor; ?>
        </div>
    </section>
    <?php endif; ?>

    <!-- TENTANG -->
    <section class="wrap about" id="tentang">
        <div class="sec-head rv"><span class="mono">01</span><h2>Tentang aku</h2></div>
        <div class="about-grid">
            <div class="bio rv"><?= markdown_mini($s['bio'] ?? '') ?></div>
            <div class="terminal rv" data-tilt>
                <div class="term-bar"><i></i><i></i><i></i><span class="mono">profil.ts</span></div>
<pre class="mono"><code><b class="k">const</b> <b class="v"><?= e(lcfirst(preg_replace('/\W/', '', $s['nama']))) ?></b> = {
  peran: <span class="s">'<?= e($s['peran']) ?>'</span>,
  basis: <span class="s">'<?= e($s['kota']) ?>'</span>,
  pengalaman: <span class="n" data-count="<?= $D['angka']['tahun'] ?>">0</span>, <span class="c">// tahun</span>
  proyek: <span class="n" data-count="<?= $D['angka']['proyek'] ?>">0</span>,
  klien: <span class="n" data-count="<?= $D['angka']['klien'] ?>">0</span>,
  stack: [<?= implode(', ', array_map(fn($t) => '<span class="s">\'' . e($t['nama']) . '\'</span>', array_slice($D['unggulan_tek'], 0, 4))) ?>],
  ngopi: <b class="k">true</b>,
};<span class="caret"></span></code></pre>
            </div>
        </div>
        <div class="stats">
            <?php foreach ([['tahun', 'Tahun berkarya'], ['proyek', 'Proyek rilis'], ['klien', 'Klien puas'], ['tek', 'Teknologi dikuasai']] as [$k, $l]): ?>
                <div class="stat rv"><b data-count="<?= $D['angka'][$k] ?>">0</b><span><?= $l ?></span></div>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- PROYEK -->
    <section class="wrap" id="proyek">
        <div class="sec-head rv"><span class="mono">02</span><h2>Proyek pilihan</h2>
            <div class="filters" role="tablist">
                <button class="on" data-f="*">Semua</button>
                <?php foreach ($D['kategori'] as $k): ?><button data-f="<?= e($k) ?>"><?= e($k) ?></button><?php endforeach; ?>
            </div>
        </div>
        <div class="projects">
            <?php
            // Kartu unggulan makan 2 kolom; kartu terakhir melebar agar baris akhir grid 3 kolom tidak bolong
            $sel = array_sum(array_map(fn($p) => $p['unggulan'] ? 2 : 1, $D['proyek'])) % 3;
            foreach ($D['proyek'] as $i => $p):
                $kelas = $p['unggulan'] ? 'big' : '';
                if ($i === count($D['proyek']) - 1 && !$p['unggulan']) $kelas = [0 => '', 1 => 'wide', 2 => 'big'][$sel];
            ?>
                <a class="pcard rv <?= $kelas ?>" href="<?= url('proyek', ['slug' => $p['slug']]) ?>" data-k="<?= e($p['kategori']) ?>" data-tilt>
                    <div class="pimg"><img src="<?= e(gambar($p['cover'])) ?>" alt="<?= e($p['judul']) ?>" loading="lazy"><span class="pnum mono"><?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?></span></div>
                    <div class="pbody">
                        <p class="pmeta mono"><?= e($p['kategori']) ?> &middot; <?= $p['tahun'] ?></p>
                        <h3><?= e($p['judul']) ?></h3>
                        <p><?= e($p['ringkasan']) ?></p>
                        <div class="ptek"><?php foreach ($p['tek'] as $t): ?><span title="<?= e($t['nama']) ?>"><?= logo($t['logo'], 18, $t['nama']) ?></span><?php endforeach; ?><em><?= icon('arrow-up-right', 20) ?></em></div>
                    </div>
                </a>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- KEAHLIAN -->
    <section class="wrap" id="keahlian">
        <div class="sec-head rv"><span class="mono">03</span><h2>Peralatan tempur</h2></div>
        <div class="skills">
            <?php foreach ($D['tek_kategori'] as $kat => $list): ?>
                <div class="skill-group rv">
                    <h3 class="mono"><?= e($kat) ?></h3>
                    <div class="tiles">
                        <?php foreach ($list as $t): ?>
                            <div class="tile" style="--lv:<?= (int) $t['level'] ?>%"><?= logo($t['logo'], 30, $t['nama']) ?><b><?= e($t['nama']) ?></b><i></i></div>
                        <?php endforeach; ?>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- LAYANAN -->
    <?php if ($D['layanan']): ?>
    <section class="wrap" id="layanan">
        <div class="sec-head rv"><span class="mono">04</span><h2>Yang bisa aku bantu</h2></div>
        <div class="services">
            <?php foreach ($D['layanan'] as $i => $l): ?>
                <article class="svc rv" data-tilt>
                    <span class="svc-ic"><?= icon($l['ikon'], 26) ?></span>
                    <h3><?= e($l['judul']) ?></h3>
                    <p><?= e($l['deskripsi']) ?></p>
                    <?php if ($l['harga_mulai']): ?><p class="price mono">mulai <b><?= rupiah((int) $l['harga_mulai']) ?></b></p><?php endif; ?>
                </article>
            <?php endforeach; ?>
        </div>
    </section>
    <?php endif; ?>

    <!-- JEJAK -->
    <section class="wrap" id="jejak">
        <div class="sec-head rv"><span class="mono">05</span><h2>Jejak perjalanan</h2></div>
        <div class="tracks">
            <?php foreach (['Pengalaman kerja' => $D['kerja'], 'Pendidikan' => $D['pendidikan']] as $judul => $list): if (!$list) continue; ?>
                <div class="track-col">
                    <h3 class="mono"><?= $judul ?></h3>
                    <ol class="timeline">
                        <?php foreach ($list as $x): ?>
                            <li class="rv"><span class="when mono"><?= bulan_tahun($x['mulai']) ?> &ndash; <?= bulan_tahun($x['selesai']) ?></span><h4><?= e($x['posisi']) ?></h4><p class="where"><?= e($x['instansi']) ?><?= $x['kota'] ? ' &middot; ' . e($x['kota']) : '' ?></p><p><?= e($x['deskripsi']) ?></p></li>
                        <?php endforeach; ?>
                    </ol>
                </div>
            <?php endforeach; ?>
        </div>
    </section>

    <!-- TESTIMONI -->
    <?php if ($D['testimoni']): ?>
    <section class="wrap testi-wrap" id="testimoni">
        <div class="sec-head rv"><span class="mono">06</span><h2>Kata mereka</h2>
            <div class="car-nav"><button class="icon-btn" data-car="-1" aria-label="Sebelumnya"><?= icon('chevron-left', 22) ?></button><button class="icon-btn" data-car="1" aria-label="Berikutnya"><?= icon('chevron-right', 22) ?></button></div>
        </div>
        <div class="carousel-stage">
            <div class="carousel" id="carousel">
                <?php foreach ($D['testimoni'] as $t): ?>
                    <figure class="quote">
                        <svg class="qmark" viewBox="0 0 40 32" width="40" height="32" aria-hidden="true"><path d="M0 32V18C0 8 6 1 16 0v6c-5 1-8 5-8 10h8v16zm24 0V18c0-10 6-17 16-18v6c-5 1-8 5-8 10h8v16z" fill="var(--acc)"/></svg>
                        <blockquote><?= e($t['isi']) ?></blockquote>
                        <figcaption><img src="<?= e(gambar($t['foto'], 'assets/img/avatar.svg')) ?>" alt="" loading="lazy"><span><b><?= e($t['nama']) ?></b><small><?= e($t['jabatan']) ?></small></span><em class="stars" aria-label="<?= (int) $t['rating'] ?> dari 5"><?= str_repeat('<i></i>', (int) $t['rating']) ?></em></figcaption>
                    </figure>
                <?php endforeach; ?>
            </div>
        </div>
    </section>
    <?php endif; ?>

    <!-- KONTAK -->
    <section class="wrap" id="kontak">
        <div class="contact rv">
            <div class="contact-info">
                <p class="mono kicker">07 &middot; Kontak</p>
                <h2>Punya ide aplikasi? Ayo kita luncurkan.</h2>
                <p>Ceritakan masalah yang mau diselesaikan. Aku balas maksimal 1x24 jam di hari kerja.</p>
                <ul class="info">
                    <?php if (!empty($s['email'])): ?><li><?= icon('mail', 20) ?><a href="mailto:<?= e($s['email']) ?>"><?= e($s['email']) ?></a></li><?php endif; ?>
                    <?php if ($wa): ?><li><?= icon('message-circle', 20) ?><a href="https://wa.me/<?= e($wa) ?>" target="_blank" rel="noopener">WhatsApp <?= e($s['whatsapp']) ?></a></li><?php endif; ?>
                    <li><?= icon('map-pin', 20) ?><span><?= e($s['kota']) ?></span></li>
                </ul>
            </div>
            <form class="cform" method="post" action="<?= url('kirim') ?>" id="cform" novalidate>
                <?= csrf_field() ?>
                <div class="hp" aria-hidden="true"><label>Website<input name="website" tabindex="-1" autocomplete="off"></label></div>
                <div class="two"><label>Nama<input name="nama" required maxlength="100" autocomplete="name"></label><label>Email<input type="email" name="email" required maxlength="150" autocomplete="email"></label></div>
                <div class="two"><label>Subjek<input name="subjek" maxlength="150"></label>
                    <label>Perkiraan anggaran<select name="anggaran"><option value="">Pilih</option><?php foreach (ANGGARAN as $a): ?><option><?= e($a) ?></option><?php endforeach; ?></select></label></div>
                <label>Pesan<textarea name="isi" rows="5" required minlength="10" maxlength="3000" placeholder="Halo, aku butuh..."></textarea></label>
                <button class="btn btn-acc" type="submit"><?= icon('send', 18) ?> Kirim pesan</button>
                <p class="form-msg <?= $kontak ? ($kontak[0] ? 'ok' : 'err') : '' ?>" id="formMsg" role="status"><?= $kontak ? e($kontak[1]) : '' ?></p>
            </form>
        </div>
    </section>
</main>

<footer class="foot">
    <div class="wrap">
        <p class="big">Sampai jumpa<br>di orbit berikutnya.</p>
        <div class="foot-row"><span>&copy; <?= date('Y') ?> <?= e($s['nama']) ?>. Dibangun dengan PHP &amp; MySQL.</span><a href="<?= url('login') ?>" rel="nofollow"><?= icon('lock', 14) ?> CMS</a></div>
    </div>
</footer>
<script src="assets/js/site.js"></script>
</body>
</html>
