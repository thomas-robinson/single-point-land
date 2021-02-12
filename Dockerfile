FROM thomasrobinson/centos7-netcdff:4.5.3-c4.7.4-gcc-mpich
## Dockerfile used to create thomasrobinson/single-point:1.0-gcc10
RUN yum -y install zip
RUN yum -y install unzip
RUN yum -y install wget
RUN . /opt/spack/share/spack/setup-env.sh
RUN cd /opt && wget -P /opt ftp://ftp.gfdl.noaa.gov/pub/Sergey.Malyshev/lm4p1-hands-on/lm4p1.v20210206.zip && unzip lm4p1.v20210206.zip && cd /opt/lm4p1.v20210206 && sed -i 's:FFLAGS_BASE = -fcray-pointer -fdefault-real-8 -fdefault-double-8 -Waliasing -ffree-line-length-none -fno-range-check -I/opt/local/gfort/include:FFLAGS_BASE = -fallow-invalid-boz -fallow-argument-mismatch -fcray-pointer -fdefault-real-8 -fdefault-double-8 -Waliasing -ffree-line-length-none -fno-range-check -I$(nf-config --prefix)/include:g' compile-gfort && sed -i 's:CFLAGS = -g -D__IFC -I/opt/local/include $cflags:CFLAGS = -g -D__IFC -I$(nc-config --prefix)/include $cflags:g' compile-gfort && sed -i 's:LDFLAGS = -L/opt/local/gfort/lib -lnetcdff -L/opt/local/lib -lnetcdf -g:LDFLAGS = -L$(nf-config --prefix)/lib -lnetcdff -L$(nc-config --prefix)/lib -lnetcdf -g:g' compile-gfort && sed -i 's:$src_dir/lm4P:$src_dir/lm4p:g' compile-gfort  && ./compile-gfort

ENV PATH=/opt/lm4p1.v20210206/exec/gfort:${PATH}
