+ Dispatch Router Installation

++ Prerequisites

```
ssh <machine>

sudo apt-get -y update

sudo apt-get -y install cmake doxygen python-epydoc gcc g++ git git-svn openjdk-7-jdk uuid-dev man-db maven net-tools openssl libssl-dev libperl-dev pkg-config python python-dev libpython-dev php5-dev ruby ruby-dev ruby-rspec ruby-simplecov subversion swig wget unzip valgrind zip apparmor libboost-all-dev libdb-dev libdb++-dev
```

++ Qpid Proton

https://qpid.apache.org/releases/index.html

https://qpid.apache.org/releases/qpid-proton-0.10/index.html

https://git-wip-us.apache.org/repos/asf?p=qpid-proton.git;a=blob_plain;f=INSTALL.md;hb=0.10

```
cd /tmp
wget http://archive.apache.org/dist/qpid/proton/0.10/qpid-proton-0.10.tar.gz
tar -xvzf qpid-proton-0.10.tar.gz
mkdir /tmp/qpid-proton-0.10/build
cd /tmp/qpid-proton-0.10/build
sudo cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_BINDINGS=ON
sudo make all docs
sudo make install
```

++ Qpid Dispatch

https://qpid.apache.org/releases/index.html

https://qpid.apache.org/releases/qpid-dispatch-0.5/index.html

https://git-wip-us.apache.org/repos/asf?p=qpid-dispatch.git;a=blob_plain;f=README

```
cd /tmp
wget http://mirrors.gigenet.com/apache/qpid/dispatch/0.5/qpid-dispatch-0.5.tar.gz
tar -xvzf qpid-dispatch-0.5.tar.gz
mkdir /tmp/qpid-dispatch-0.5/build
cd /tmp/qpid-dispatch-0.5/build
sudo cmake ..
sudo make
sudo make install
sudo cp /tmp/qpid-dispatch-0.5/build/src/libqpid-dispatch.so.1 /usr/lib
```

```
Default configuration - /usr/local/etc/qpid-dispatch/qdrouterd.conf
Custom configuration  - /tmp/qdrouterd.conf
```

++ Verification

```
which qdrouterd
> /usr/local/sbin/qdrouterd
qdrouterd --help
qdrouterd --daemon --config=/tmp/qdrouterd.conf
qdrouterd --daemon (default config - /usr/local/etc/qpid-dispatch/qdrouterd.conf)
ps -ef | grep qdrouter

cd /tmp/qpid-dispatch-0.5/build
./run.py unit_tests_size 3
./run.py -m unittest system_tests_qdstat
```

++ 
