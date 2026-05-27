# Halaman publik beli voucher (static) — disajikan nginx sebagai non-root, port 3000.
FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

# Siapkan akses tulis untuk user non-root "nginx" (pid + temp di /tmp, cache nginx).
RUN touch /tmp/nginx.pid \
 && chown -R nginx:nginx /usr/share/nginx/html /var/cache/nginx /tmp/nginx.pid

USER nginx
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://127.0.0.1:3000/ || exit 1
