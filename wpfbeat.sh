#!/bin/bash

#Instalar curl
sudo apt update
sudo apt install curl

#Instalar nginx
sudo apt install nginx -y
sudo systemctl start nginx

#Instalar php
sudo apt install -y php-fpm php-mysql php-cli
sudo apt install -y php-dom php-simplexml php-ssh2 php-xml php-xmlreader php-curl php-exif php-ftp php-gd php-iconv php-imagick php-json php-mbstring php-posix php-sockets php-tokenizer
sudo sed -i 's#listen = /run/php/php8.1-fpm.sock#listen = 127.0.0.1:9000#' /etc/php/8.1/fpm/pool.d/www.conf
sudo systemctl restart php8.1-fpm.service

#Configurar nginx
sudo cat > /etc/nginx/conf.d/www.wordpress.local.conf << EOF
server {
        server_name www.wordpress.local;
        root /sites/www.wordpress.local/public_html/;
 
        index index.html index.php;
 
        access_log /sites/www.wordpress.local/logs/access.log;
        error_log /sites/www.wordpress.local/logs/error.log;
 
        # No permitir que las páginas se representen en un iframe en dominios externos
        add_header X-Frame-Options "SAMEORIGIN";
 
        # Prevención MIME
        add_header X-Content-Type-Options "nosniff";
 
        # Habilitar el filtro de secuencias de comandos entre sitios en los navegadores compatibles
        add_header X-Xss-Protection "1; mode=block";
 
        # Evitar el acceso a archivos ocultos
        location ~* /\.(?!well-known\/) {
                deny all;
        }
 
        # Evitar el acceso a ciertas extensiones de archivo
        location ~\.(ini|log|conf)$ {
                deny all;
        }
 
        # Habilitar enlaces permanentes de WordPress
        location / {
                try_files \$uri \$uri/ /index.php?\$args;
        }
 
        location ~ \.php$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        }
 
}
EOF

sudo mkdir -p /sites/www.wordpress.local/public_html/
sudo mkdir -p /sites/www.wordpress.local/logs/

#Descargar WordPress
wget http://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
sudo mv wordpress/* /sites/www.wordpress.local/public_html/

sudo chown -R www-data:www-data /sites/www.wordpress.local/public_html/
sudo chown -R www-data:www-data /sites/www.wordpress.local/logs/

sudo sed -i 0,/localhost/{'s/localhost/localhost\n10.0.2.15	www.wordpress.local site/'} /etc/hosts
sudo systemctl restart nginx.service

#Instalar mysql
sudo apt install -y mysql-server
sudo mysql -u root -e "CREATE DATABASE wordpress;"
sudo mysql -u root -e "CREATE USER 'wpusuario'@'localhost' IDENTIFIED BY '123password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpusuario'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

#Instalar y configurar Filebeat
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
sudo apt update
sudo apt install filebeat

USUARIO=$1

sudo cat /home/$USUARIO/configfbeat.txt > /etc/filebeat/filebeat.yml
sudo chown root filebeat.yml
sudo systemctl enable filebeat
sudo systemctl start filebeat