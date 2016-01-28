#!/bin/bash

##################################################################
sudo apt-get -y update
sudo apt-get -y install cmake doxygen python-epydoc gcc g++ git git-svn openjdk-7-jdk uuid-dev man-db maven net-tools openssl libssl-dev libperl-dev pkg-config python python-dev libpython-dev php5-dev ruby ruby-dev ruby-rspec ruby-simplecov subversion swig wget unzip valgrind zip apparmor libboost-all-dev libdb-dev libdb++-dev 

cd /tmp
svn co http://svn.apache.org/repos/asf/qpid/proton/branches/0.8 proton
cd /tmp/proton
sed -i 's/-Wunused-function //' CMakeLists.txt
sed -i 's/-Waddress //' CMakeLists.txt

mkdir build
cd /tmp/proton/build

sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_BINDINGS=ON
sudo make all docs
sudo make install

cd /tmp
svn co http://svn.apache.org/repos/asf/qpid/dispatch/trunk dispatch

cd /tmp/dispatch

mkdir build
cd /tmp/dispatch/build
sudo cmake ..
sudo make
sudo make install

cp /tmp/dispatch/etc/qdrouterd.conf /home/stack
chown stack:stack /home/stack/qdrouterd.conf
##################################################################


OS=ubuntu
LEVEL=full #minimal

minimal_ubuntu_pkg
install_proton
add_user
echo "Initializing docker"	
install_protobuf
install_host_scripts
build_docker_images 
install_qpid_broker
install_qpid_tools
install_qpid_qmf
install_qpid_dispatch
cleanup

function minimal_ubuntu_pkg
{
	echo "Starting minimal Ubuntu build"
	echo "Running apt update"
	sudo apt-get -y update
	echo "Installing required dependencies via yum"
	sudo apt-get -y install cmake doxygen python-epydoc gcc g++ git git-svn openjdk-7-jdk uuid-dev man-db maven net-tools openssl libssl-dev libperl-dev pkg-config python python-dev libpython-dev php5-dev ruby ruby-dev ruby-rspec ruby-simplecov subversion swig wget unzip valgrind zip apparmor libboost-all-dev libdb-dev libdb++-dev 
	sudo apt-get -y install mdadm # asks for prompt
	
	echo "Installing docker...:"

	sudo apt-get -y purge docker.io
	sudo apt-get -y purge docker

	sudo apt-get -y update
	sudo apt-get -y install apt-transport-https

	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

	sudo touch /etc/apt/sources.list.d/docker.list
	sudo chmod 777 /etc/apt/sources.list.d/docker.list
	sudo echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

	sudo apt-get -y update
	sudo apt-get -y install lxc-docker
}

function install_proton
{
	echo "Get and build the Qpid Proton AMQP clients"
	cd /tmp
	svn co http://svn.apache.org/repos/asf/qpid/proton/branches/0.8 proton # does not work, had to copy from hyper40
	cd /tmp/proton
	sed -i 's/-Wunused-function //' CMakeLists.txt
	sed -i 's/-Waddress //' CMakeLists.txt
	
	mkdir build
	cd /tmp/proton/build
	
	sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_BINDINGS=ON
	sudo make all docs
	sudo make install
}

function install_qpid_broker {
	echo "Get and build the Qpid CPP client & broker"
	cd /tmp
	svn checkout http://svn.apache.org/repos/asf/qpid/trunk/qpid qpid
	cd /tmp/qpid/cpp
	
	#Fix the compiler error for unused functions
	sed -i 's/-Werror //' CMakeLists.txt
	sed -i 's/linearstore_default\ OFF/linearstore_default\ ON/' ./src/linearstore.cmake
	
	mkdir build
	cd /tmp/qpid/cpp/build
	
	cmake ..
	make all
	make install
}
function install_qpid_tools {
	echo "Install qpid tools"
	cd /tmp/qpid/tools
	./setup.py build
	./setup.py install
	# this is needed for qpid-stat to work
	cd /tmp/qpid/python
	./setup.py build
	./setup.py install
}
function install_qpid_python {
	echo "Get and build the Qpid Messaging Python Client"
	cd /tmp
	svn co http://svn.apache.org/repos/asf/qpid/trunk/qpid/python qpid_python
	cd /tmp/qpid_python
	./setup.py build
	./setup.py install
}
function install_qpid_qmf {
	echo "Get and build the QMF tooling"
	cd /tmp
	svn co http://svn.apache.org/repos/asf/qpid/trunk/qpid/extras/qmf qmf
	
	cd /tmp/qmf
	./setup.py build
	./setup.py install
}
function install_qpid_dispatch {
	echo "Get and build Qpid Dispatch"
	cd /tmp
	svn co http://svn.apache.org/repos/asf/qpid/dispatch/trunk dispatch

	cd /tmp/dispatch

	mkdir build
	cd /tmp/dispatch/build
	cmake ..
	make
	make install

	cp /tmp/dispatch/etc/qdrouterd.conf /home/prabhuj
	chown prabhuj:prabhuj /home/prabhuj/qdrouterd.conf
}
function add_user {
	echo "Adding the prabhuj user"
	sudo useradd prabhuj -d /home/prabhuj
	
	echo "Create the data and log directories"
	sudo mkdir -p /var/prabhuj/data
	sudo mkdir -p /var/prabhuj/logs
	sudo mkdir -p /home/prabhuj/bin
	sudo mkdir -p /home/prabhuj/lib
	sudo mkdir -p /home/prabhuj/upstart

	sudo chown -R prabhuj:prabhuj /var/prabhuj
	sudo chown -R prabhuj:prabhuj /home/prabhuj/bin
	sudo chown -R prabhuj:prabhuj /home/prabhuj/lib
	sudo chown -R prabhuj:prabhuj /home/prabhuj/upstart
		
	echo "Setting up the environment"
	alias vi=vim

	sudo echo "export PYTHONPATH=/usr/local/lib/python2.7/dist-packages/" >> /home/prabhuj/.bashrc
	sudo echo "export PYTHONPATH=\python2.7:/home/prabhuj/lib/" >> /home/prabhuj/.bashrc
	sudo echo "export PATH=\$PATH:/home/prabhuj/bin" >> /home/prabhuj/.bashrc
	sudo echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib64/" >> /home/prabhuj/.bashrc

	sudo echo "export PYTHONPATH=/usr/local/lib/python2.7/dist-packages/" >> /root/.bashrc
	sudo echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib64/" >> /root/.bashrc
}

function cleanup {
	echo "Clean-up the temporary build and install files"
	rm -fR /tmp/qpid
	rm -fR /tmp/dispatch
	rm -fR /tmp/proton
	rm -fR /tmp/qmf
	rm -fR /tmp/qpid-python
	rm /tmp/*.gz
	rm -fR /tmp/prabhuj
}
function install_protobuf {
	wget https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz
  	tar -xvzf protobuf-2.6.1.tar.gz 
	cd protobuf-2.6.1/
  	sudo ./configure
	sudo make
	sudo make install
	export LD_LIBRARY_PATH=/usr/local/lib/
	cd python/
	sudo ./setup.py build
	sudo ./setup.py install
}
function install_host_scripts {

    mkdir /tmp/prabhuj
    cd /tmp/prabhuj
    # have to construct a settings.xml to use nexus
    echo '<?xml version="1.0"?>' > /tmp/prabhuj/settings.xml
    echo ' <settings><localRepository>/tmp/prabhuj/repository</localRepository>' >> /tmp/prabhuj/settings.xml
    echo ' <mirrors><mirror><id>paypal</id><mirrorOf>*</mirrorOf>' >> /tmp/prabhuj/settings.xml 
    echo ' <url>http://nexus.paypal.com/nexus/content/groups/public-all</url>' >> /tmp/prabhuj/settings.xml
    echo ' </mirror></mirrors>' >> /tmp/prabhuj/settings.xml 
    echo ' <profiles> <profile> <id>paypal</id> <repositories> <repository> <id>paypal</id>' >> /tmp/prabhuj/settings.xml
    echo ' <snapshots> <enabled>true</enabled> </snapshots>' >> /tmp/prabhuj/settings.xml
    echo ' <releases> <enabled>true</enabled> </releases>' >> /tmp/prabhuj/settings.xml
    echo ' <url>http://nexus.paypal.com/nexus/content/groups/public-all</url>' >> /tmp/prabhuj/settings.xml
    echo ' </repository> </repositories></profile> </profiles>' >> /tmp/prabhuj/settings.xml
    echo ' <activeProfiles><activeProfile>paypal</activeProfile> </activeProfiles></settings>' >> /tmp/prabhuj/settings.xml

    mvn org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=com.ebayinc.mammut.admin:host:1.0-SNAPSHOT:zip:dist -DoutputDirectory=/tmp/prabhuj --settings=/tmp/prabhuj/settings.xml

    sudo unzip /tmp/prabhuj/host*.zip -d /home/prabhuj
 
    sudo mv /home/prabhuj/upstart/mammut-hostmsgd.conf /home/prabhuj/upstart/prabhuj-hostmsgd.conf
    sudo cp /home/prabhuj/upstart/*.conf /etc/init
    sudo chown root:root /etc/init/prabhuj*.conf
    
    cd /etc/init
    for config in `ls /home/prabhuj/upstart`; do
	init-checkconf $config 
	base=${config%.*}
    done
}

function build_docker_images {
    mvn org.apache.maven.plugins:maven-dependency-plugin:2.9:copy -Dartifact=com.paypal.mammut.admin:images:1.0-SNAPSHOT:zip:dist -DoutputDirectory=/tmp/prabhuj --settings=/tmp/prabhuj/settings.xml

    cd /tmp/prabhuj

    sudo unzip images*.zip -d /home/prabhuj/images

    # this should build all containers without any input
    cd /home/prabhuj/images

	sudo docker daemon

    ./build.sh
}
