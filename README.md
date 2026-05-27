# vouchify-beli — Halaman beli voucher publik (`beli.balanglompo.com`)

Halaman swalayan (tanpa login) untuk pembeli voucher WiFi hotspot Balanglompo.
Statis (satu file `index.html`), disajikan nginx.

## Alur
1. Pembeli pilih paket (dari `GET vapi.balanglompo.com/api/public/packages`).
2. Isi nama + no. HP → `POST /api/public/checkout` → dapat `payment_url`.
3. Popup pembayaran QRIS gateway terbuka (`pay.balanglompo.com/snap.js`).
4. Halaman polling `GET /api/public/payments/{reference}`; setelah admin
   menyetujui bukti di gateway → voucher otomatis dibuat → user/pass tampil.

## Konfigurasi
URL backend & gateway di-hardcode di `index.html`:
- `API = https://vapi.balanglompo.com`
- gateway snap.js = `https://pay.balanglompo.com/snap.js`

## Deploy (Coolify)
Build pack **Dockerfile**, domain **beli.balanglompo.com**, port **80**.
Backend harus mengizinkan origin ini di `CORS_ORIGINS`.
