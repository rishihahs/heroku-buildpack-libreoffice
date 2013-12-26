# add vendor binaries to the path
export PATH=$PATH:/app/vendor/libreoffice/program:/app/vendor/libreoffice/deps/bin

# configure LD_LIBRARY_PATH to include dependencies
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/app/vendor/libreoffice/deps/lib
