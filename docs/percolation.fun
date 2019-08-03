server {
  listen 80 default_server;
  listen [::]:80 default_server;

  root /var/www/percolation.fun;

  index index.html;

  server_name percolation.fun www.percolation.fun;

  location / {
    try_files $uri $uri/ =404;
  }
}
