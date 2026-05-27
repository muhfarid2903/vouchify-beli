# vouchify-beli — Halaman beli voucher publik (`beli.balanglompo.com`)

Landing + halaman swalayan (tanpa login) untuk pembeli voucher WiFi hotspot **Warkopsaja**
(Pulau Balang Lompo, Sulawesi Selatan). Satu file statis `index.html`, gaya minimalis Apple,
dwibahasa **EN/ID**, disajikan nginx.

## Struktur halaman
Navbar (sticky, blur) · Hero · Packages (grid kartu, di-fetch dari API) · How it works ·
Social · FAQ · About · Contact · Footer. Plus modal voucher, modal recovery, dan toast.

## Alur pembayaran (backend live)
1. `GET vapi.balanglompo.com/api/public/packages` → daftar paket.
2. Klik **Choose** → modal isi nama + no. HP → `POST /api/public/checkout`
   `{ package_key, buyer_name, buyer_phone }` → `{ reference, payment_url }`.
3. Popup pembayaran QRIS terbuka via `pay.balanglompo.com/snap.js`
   (`window.PaymentGateway.pay(payment_url, …)`).
4. Halaman polling `GET /api/public/payments/{reference}` tiap 4 dtk:
   - `stage = ready` + voucher → **modal voucher** (username/password + salin).
   - `stage = provision_failed` → **modal recovery** (no. referensi + link WhatsApp ke admin).
   - `status = EXPIRED/CANCELLED` → toast, transaksi dihapus.
   Transaksi yang belum selesai disimpan di `localStorage` dan dilanjutkan saat refresh
   (kecuali sudah > 35 menit / kedaluwarsa di gateway).

> Catatan: prompt asli menargetkan Midtrans Snap langsung (`/profile`, `/purchase`,
> `/account/create`). Halaman ini sengaja disambung ke backend `vapi.balanglompo.com`
> yang sudah live agar pembayaran & voucher tetap berfungsi.

## Konfigurasi
Di bagian atas `<script>` pada `index.html`:
- `API_BASE` = `https://vapi.balanglompo.com` (bisa dioverride via `window.__ENV__.VITE_API_BASE_URL`).
- `WHATSAPP` = `62812xxxxxxx` — **WAJIB diganti** ke nomor WA admin (format `62…`, tanpa `+`/spasi).
- `IG_HANDLE` = `warkopsaja` — ganti ke handle Instagram yang benar.
- Gateway snap.js: `https://pay.balanglompo.com/snap.js`.

Slot sosial TikTok/Facebook sudah disiapkan (dikomentari) di bagian Social.

## Deploy (Coolify / Docker)
- Build pack **Dockerfile**. Container kini jalan **non-root di port `3000`**
  (`nginx.conf` + `docker-compose.yml` disertakan; gzip, cache 7d aset, no-cache `index.html`).
- ⚠️ **Ganti port tujuan di Coolify dari `80` → `3000`** untuk domain `beli.balanglompo.com`,
  kalau tidak deploy akan gagal terhubung. (Versi lama menyajikan di port 80 sebagai root.)
- Backend harus mengizinkan origin ini di `CORS_ORIGINS`.

Lokal: `docker compose up --build` lalu buka `http://localhost:3000`.
