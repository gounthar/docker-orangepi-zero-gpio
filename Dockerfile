FROM debian:stretch
#latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-config dump | grep -we Recommends -e Suggests | sed s/1/0/ | tee /etc/apt/apt.conf.d/999norecommend
RUN apt update && apt upgrade -y && apt install --no-install-recommends -y git curl i2c-tools python python-dev sudo build-essential \
   kmod libssl-dev ca-certificates && \
   cd && git clone --depth 1 https://github.com/sgjava/java-periphery.git && \
# fails with error 127 RUN cd ~/java-periphery/scripts && ./install.sh
#RUN mkdir -p $HOME/include/linux && cp /usr/src/linux-headers-5.10.16-sunxi/include/uapi/linux/gpio.h $HOME/include/linux/.
#RUN cd .. && mvn clean install "-Dcflags=-I$HOME/include"
   curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && python get-pip.py && python -m pip --version && \
   cd && git clone https://github.com/zhaolei/WiringOP.git -b h3 && cd WiringOP/ && bash build && \
   pip install wheel && pip install setuptools && pip install pyA20 && pip install OrangePi.GPIO && \
   apt remove -y git python-dev build-essential && apt autoremove -y && apt-get clean -y
ADD temperature.py .
ENTRYPOINT python temperature.py 
