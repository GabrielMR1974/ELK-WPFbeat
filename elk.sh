#!/bin/bash

#Instalar curl
sudo apt install curl

#Instalar y configurar Elasticsearch
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install elasticsearch
sudo sed -i 's/#network.host: 192.168.0.1/network.host: localhost/' /etc/elasticsearch/elasticsearch.yml
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

#Instalar Nginx
sudo apt install nginx
sudo ufw allow 'Nginx Full'

#Instalar y configurar el panel de Kibana
sudo apt install kibana
sudo systemctl enable kibana
sudo systemctl start kibana
echo "kibanaadmin:`openssl passwd -apr1`" | sudo tee -a /etc/nginx/htpasswd.users
sudo cat > /etc/nginx/sites-available/devops.com << EOF
server {
    listen 80;

    server_name devops.com;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade '$http_upgrade';
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host '$host';
        proxy_cache_bypass '$http_upgrade';
    }
}
EOF
sudo ln -s /etc/nginx/sites-available/devops.com /etc/nginx/sites-enabled/devops.com
sudo sed -i 0,/localhost/{'s/localhost/localhost\n127.0.0.1 devops.com site/'} /etc/hosts
sudo systemctl reload nginx
sudo systemctl start nginx
sudo systemctl enable nginx

#Instalar y configurar Logstash
sudo apt install logstash
sudo cat > /etc/logstash/conf.d/02-beats-input.conf <<EOF
input {
  beats {
    port => 5044
  }
}
EOF
sudo cat > /etc/logstash/conf.d/30-elasticsearch-output.conf <<EOF
output {
  if [@metadata][pipeline] {
	elasticsearch {
  	hosts => ["localhost:9200"]
  	manage_template => false
  	index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  	pipeline => "%{[@metadata][pipeline]}"
	}
  } else {
	elasticsearch {
  	hosts => ["localhost:9200"]
  	manage_template => false
  	index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
	}
  }
}
EOF
sudo systemctl start logstash
sudo systemctl enable logstash
