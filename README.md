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
Para ejecutar ambos scripts en dos máquinas virtuales, sigue estos pasos:

Asegúrate de tener acceso de administrador (sudo) en ambas máquinas virtuales.
Asegúrate de tener conectividad entre las dos máquinas virtuales.
Descarga los scripts en ambas máquinas virtuales en un directorio específico utilizando el comando wget o copiando el código manualmente en un archivo .sh y darle permisos de ejecución
Ejecuta el primer script en la primera máquina virtual utilizando el comando bash nombre_del_script.sh
Ejecuta el segundo script en la segunda máquina virtual utilizando el comando bash nombre_del_script.sh
Verifica que ambos scripts se hayan ejecutado correctamente y que los servicios instalados estén funcionando correctamente.
Nota: Es importante que antes de ejecutar los script se verifique que las máquinas virtuales cumplen con los requerimientos necesarios para ejecutar las aplicaciones que se instalaran.
