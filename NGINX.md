# NGINX Installation

> sudo apt-get update

> sudo apt-get -y install nginx apache2-utils

#for generating username/password pair
> sudo htpasswd -c /etc/nginx/htpasswd.users kibanaadmin
#password - kibanaadmin

> sudo vim /etc/nginx/sites-available/default

```
This configures Nginx to direct your server's HTTP traffic to the Kibana application, which is listening on localhost:5601. Also, Nginx will use the htpasswd.users file, that was created earlier, and require basic authentication.
    server {
        listen 80;

        server_name localhost;

        auth_basic "Restricted Access";
        auth_basic_user_file /etc/nginx/htpasswd.users;

        location / {
            proxy_pass http://localhost:5601;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }
```

> sudo service nginx start

> sudo service nginx restart

> sudo service nginx stop

> ps -ef | grep nginx

#To restart web server automatically when the server is rebooted,
> sudo update-rc.d nginx defaults
