# JAVA7 Installation

sudo rm -rf /usr/local/java

sudo mkdir -p /usr/local/java

sudo wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz -P /usr/local/java

sudo tar -zvxf /usr/local/java/jdk-7u80-linux-x64.tar.gz --directory /usr/local/java

sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.7.0_80/jre/bin/java" 1

sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.7.0_80/bin/javac" 1

java -version

```
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
```

javac -version

```
javac 1.7.0_80
```
