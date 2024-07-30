server {
    listen 80;
    listen [::]:80;
    server_name dhanvantriai.com www.dhanvantriai.com;

    root /var/www/html;

    location = /aboutus {
        try_files /aboutus.html =404;
        types { text/html html; }
        default_type text/html;
    }

    location = /aboutus/ {
        try_files /aboutus.html =404;
        types { text/html html; }
        default_type text/html;
    }

    location = /wiki {
        try_files /wiki.html =404;
        types { text/html html; }
        default_type text/html;
    }

    location = /wiki/ {
        try_files /wiki.html =404;
        types { text/html html; }
        default_type text/html;
    }

    # Serve static files from /var/www/html
    location /images/ {
        alias /var/www/html/images/;
    }

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}