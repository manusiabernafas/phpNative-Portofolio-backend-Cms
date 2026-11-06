// Efek halaman Orbit: progress, parallax bintang, reveal, hitung angka, tilt 3D, filter, carousel, kontak AJAX
(() => {
    const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
    const $ = (s, el = document) => el.querySelector(s);
    const $$ = (s, el = document) => [...el.querySelectorAll(s)];

    // Pecah judul hero jadi kata agar bisa muncul satu per satu
    $$('.split').forEach(h => {
        h.innerHTML = h.textContent.trim().split(/\s+/).map((w, i) => `<span class="w" style="transition-delay:${i * 45}ms">${w.replace(/&/g, '&amp;').replace(/</g, '&lt;')}</span>`).join(' ');
        requestAnimationFrame(() => setTimeout(() => h.classList.add('in'), 120));
    });

    // Scroll: progress bar, nav, parallax bintang, cover detail yang "rebah" lalu tegak
    const bar = $('.progress i'), nav = $('#nav'), layers = $$('.sky .layer'), cover = $('#dcover');
    let ticking = false;
    const onScroll = () => {
        const y = scrollY, h = document.documentElement.scrollHeight - innerHeight;
        if (bar) bar.style.transform = `scaleX(${h > 0 ? y / h : 0})`;
        if (nav) nav.classList.toggle('scrolled', y > 40);
        if (!reduce) layers.forEach((l, i) => { l.style.transform = `translate3d(0, ${-y * (0.04 + i * 0.07)}px, 0)`; });
        if (cover && !reduce) {
            const r = cover.parentElement.getBoundingClientRect();
            const t = Math.min(1, Math.max(0, 1 - (r.top - 80) / (innerHeight * 0.7)));
            cover.style.transform = `rotateX(${22 * (1 - t)}deg) scale(${0.92 + 0.08 * t})`;
        }
        ticking = false;
    };
    addEventListener('scroll', () => { if (!ticking) { ticking = true; requestAnimationFrame(onScroll); } }, { passive: true });
    onScroll();

    // Reveal & hitung angka saat masuk layar
    const count = el => {
        const n = +el.dataset.count; if (reduce) { el.textContent = n; return; }
        const t0 = performance.now(), dur = 1200;
        const step = t => { const p = Math.min(1, (t - t0) / dur); el.textContent = Math.round(n * (1 - Math.pow(1 - p, 3))); if (p < 1) requestAnimationFrame(step); };
        requestAnimationFrame(step);
    };
    const io = new IntersectionObserver(es => es.forEach(en => {
        if (!en.isIntersecting) return;
        en.target.classList.add('in');
        $$('[data-count]', en.target).forEach(count);
        if (en.target.dataset.count) count(en.target);
        io.unobserve(en.target);
    }), { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });
    $$('.rv').forEach(el => io.observe(el));

    // Tilt 3D mengikuti kursor (hanya perangkat dengan mouse)
    if (!reduce && matchMedia('(hover: hover)').matches) {
        $$('[data-tilt]').forEach(el => {
            el.addEventListener('pointermove', e => {
                const r = el.getBoundingClientRect();
                const x = (e.clientX - r.left) / r.width - 0.5, y = (e.clientY - r.top) / r.height - 0.5;
                el.style.transform = `perspective(900px) rotateY(${x * 10}deg) rotateX(${-y * 10}deg) translateZ(0)`;
            });
            el.addEventListener('pointerleave', () => { el.style.transform = ''; });
        });
    }

    // Filter kategori proyek
    $$('.filters button').forEach(b => b.addEventListener('click', () => {
        $$('.filters button').forEach(x => x.classList.toggle('on', x === b));
        $$('.pcard').forEach(c => c.classList.toggle('hide', b.dataset.f !== '*' && c.dataset.k !== b.dataset.f));
    }));

    // Carousel silinder 3D untuk testimoni
    const car = $('#carousel');
    if (car) {
        const items = $$('.quote', car), n = items.length, step = 360 / n;
        let idx = 0;
        const layout = () => {
            const w = car.offsetWidth, radius = n > 2 ? Math.round((w / 2) / Math.tan(Math.PI / n)) + 40 : 0;
            items.forEach((q, i) => { q.style.transform = n > 2 ? `rotateY(${i * step}deg) translateZ(${radius}px)` : `translateX(${(i - idx) * 110}%)`; q.classList.toggle('dim', i !== ((idx % n) + n) % n); });
            car.style.transform = n > 2 ? `translateZ(${-radius}px) rotateY(${-idx * step}deg)` : '';
        };
        $$('[data-car]').forEach(b => b.addEventListener('click', () => { idx += +b.dataset.car; layout(); }));
        let sx = null;
        car.addEventListener('pointerdown', e => { sx = e.clientX; });
        addEventListener('pointerup', e => { if (sx !== null && Math.abs(e.clientX - sx) > 40) { idx += e.clientX < sx ? 1 : -1; layout(); } sx = null; });
        addEventListener('resize', layout);
        layout();
        if (!reduce) setInterval(() => { if (!document.hidden) { idx++; layout(); } }, 6000);
    }

    // Formulir kontak lewat fetch (tetap jalan tanpa JS lewat POST biasa)
    const form = $('#cform'), msg = $('#formMsg');
    if (form) form.addEventListener('submit', async e => {
        e.preventDefault();
        if (!form.reportValidity()) return;
        const btn = $('button[type=submit]', form);
        btn.disabled = true; msg.className = 'form-msg'; msg.textContent = 'Mengirim...';
        try {
            const r = await fetch(form.action, { method: 'POST', body: new FormData(form), headers: { 'X-Requested-With': 'fetch' } });
            const j = await r.json();
            msg.className = 'form-msg ' + (j.ok ? 'ok' : 'err'); msg.textContent = j.msg;
            if (j.ok) form.reset();
        } catch { msg.className = 'form-msg err'; msg.textContent = 'Gagal terhubung. Coba lagi sebentar lagi.'; }
        btn.disabled = false;
    });

    // Lightbox galeri
    const lb = $('#lb');
    if (lb) {
        $$('[data-lb]').forEach(a => a.addEventListener('click', e => { e.preventDefault(); $('img', lb).src = a.href; $('img', lb).alt = $('img', a).alt; lb.hidden = false; }));
        lb.addEventListener('click', () => { lb.hidden = true; });
        addEventListener('keydown', e => { if (e.key === 'Escape') lb.hidden = true; });
    }

    // Tutup menu HP saat link diklik
    $$('#links a').forEach(a => a.addEventListener('click', () => document.body.classList.remove('menu-open')));
})();
