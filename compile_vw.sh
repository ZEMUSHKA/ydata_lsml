# dev tools
sudo yum -y groupinstall "Development Tools"
# boost
wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.gz
tar xf boost_1_73_0.tar.gz
pushd boost_1_73_0
sudo ./bootstrap.sh --prefix=/usr/
./b2
sudo ./b2 install
sudo cp /usr/lib/libboost_* /usr/lib64/
popd
# cmake
wget https://cmake.org/files/v3.10/cmake-3.10.0.tar.gz
tar -xvzf cmake-3.10.0.tar.gz
pushd cmake-3.10.0
./bootstrap
make -j12
sudo make install
popd
# vowpal wabbit
git clone --branch 8.8.1 https://github.com/VowpalWabbit/vowpal_wabbit.git
pushd vowpal_wabbit
cmake CMakeLists.txt
make -j12
popd
