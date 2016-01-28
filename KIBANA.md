# KIBANA Installation

mkdir /app

chmod -R 777 /app

sudo wget --no-check-certificate https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz -P /app/

sudo tar -zvxf /app/kibana-4.3.1-linux-x64.tar.gz --directory /app/

sudo vim /app/kibana-4.3.1-linux-x64/config/kibana.yml
    #This setting makes it so Kibana will only be accessible to the localhost. This is fine because we will use an Nginx reverse proxy to allow external access. In the Kibana configuration file, find the line that specifies host, and replace the IP address ("0.0.0.0" by default) with "localhost":
    host: "localhost"

sudo /app/kibana-4.3.1-linux-x64/bin/kibana

ps -ef | grep kibana

To restart kibana automatically when the server is rebooted,
sudo update-rc.d kibana4 defaults 96 9
