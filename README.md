# ELK-WPFbeat
Instalación en una máquina del stack ELK(Elasticsearch, Logstash, Kibana), que recibirá los logs de otra máquina donde montaremos Filebeat y Wordpress, con Nginx y Mysql.

### elk.sh
Este script automatiza la instalación y configuración de una pila ELK (Elasticsearch, Logstash y Kibana) en un sistema Linux que ejecuta Ubuntu.

- Instala curl utilizando apt.
- Descarga e instala Elasticsearch utilizando el comando curl, configurando la red para escuchar en localhost.
- Descarga e instala Nginx y lo configura para permitir tráfico a través del firewall.
- Descarga e instala Kibana, y configura un proxy inverso a través de Nginx para permitir autenticación básica.
- Descarga e instala Logstash, y configura una entrada para recibir datos desde Beats y una salida para enviar los datos a Elasticsearch.

Nota: El script requiere acceso de administrador (sudo) para ejecutar. También, el script crea un usuario de nombre "kibanaadmin" con una contraseña generada por openssl passwd -apr1, el cual se usa para autenticar en la página web de Kibana.

### wpfbeat.sh
Este script automatiza la instalación y configuración de un servidor web con PHP-FPM, Nginx y MySQL para ejecutar una instancia de WordPress en un sistema Linux que ejecuta Ubuntu.

- Instala curl y actualiza el sistema utilizando apt.
- Descarga e instala Nginx y PHP-FPM, incluyendo varios módulos de PHP.
- Configura Nginx para servir un sitio web con el nombre de dominio "www.wordpress.local" y configura las opciones de seguridad para prevenir ataques comunes.
- Descarga la última versión de WordPress y la coloca en el directorio raíz del sitio web configurado en Nginx.
- Configura MySQL y crea una base de datos y un usuario específico para WordPress.
- Descarga e instala Filebeat para recolectar y enviar registros de sitio web a Elasticsearch.
- Agrega la dirección IP del servidor y el nombre de dominio "www.wordpress.local" al archivo hosts del sistema.

Nota: El script requiere acceso de administrador (sudo) para ejecutar. También, se asume que se tiene acceso a un servidor Elasticsearch y se ha configurado previamente.

### Instrucciones
Para realizar la instalación y configuración de los servicios sigue los siguientes pasos:

- Asegúrate de tener acceso de administrador (sudo) en ambas máquinas virtuales.
- Asegúrate de tener conectividad entre las dos máquinas virtuales.
- Asegúrate de tener Git instalado en ambas máquinas virtuales. Si no lo tienes, puedes instalarlo utilizando el comando sudo apt-get install git.
- Abre una terminal en ambas máquinas virtuales.
- Utiliza el comando git clone seguido de la URL del repositorio en GitHub para descargar el proyecto. "git clone https://github.com/GabrielMR1974/ELK-WPFbeat"
- Una vez que se haya descargado el proyecto, entra en el directorio del proyecto.
- Asegúrate de que los scripts tienen permisos de ejecución, si no es así utilizar el comando chmod +x elk.sh wpfbeat.sh
- Mueve el archivo de configuración de filebeat "configfbeat.txt" al directorio home.
- Ejecuta el script wpfbeat.sh en la máquina en la que se va instalar wordpress y filebeat.
- Ejecuta el script elk.sh en la máquina en la que se va a realizar el análisis de los logs con el stack ELK.
- En el archivo "/etc/filebeat/filebeat.yml", en el apartado "Logstash Output" modifica la variable hosts con la IP de la máquina en la que se instalará ELK, respetando el nro de puerto. Ej: "hosts: ["0.0.0.0:5044"]"
- Verifica que ambos scripts se hayan ejecutado correctamente y que los servicios instalados estén funcionando correctamente.

Nota: Es importante que antes de ejecutar los script se verifique que las máquinas virtuales cumplen con los requerimientos necesarios para ejecutar las aplicaciones que se instalaran.
