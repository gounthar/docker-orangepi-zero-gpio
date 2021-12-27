# FROM debian:latest
# FROM balenalib/<hw>-<distro>-<lang_stack>:<lang_ver>-<distro_ver>-(build|run)-<yyyymmdd>
FROM balenalib/orange-pi-zero-debian-openjdk:latest-buster-build
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-config dump | grep -we Recommends -e Suggests | sed s/1/0/ | tee /etc/apt/apt.conf.d/999norecommend
RUN apt update && apt upgrade -y && apt install --no-install-recommends -y git i2c-tools python3-dev python3-pip sudo build-essential libssl-dev && \
   cd && git clone --depth 1 https://github.com/sgjava/java-periphery.git && \
# fails with error 127 RUN cd ~/java-periphery/scripts && ./install.sh
#RUN mkdir -p $HOME/include/linux && cp /usr/src/linux-headers-5.10.16-sunxi/include/uapi/linux/gpio.h $HOME/include/linux/.
#RUN cd .. && mvn clean install "-Dcflags=-I$HOME/include"
   cd && git clone https://github.com/zhaolei/WiringOP.git -b h3 && cd WiringOP/ && bash build && \
   pip3 install wheel && pip3 install setuptools && pip3 install pyA20 && pip3 install OrangePi.GPIO && \
   apt remove -y git python-dev build-essential && apt autoremove -y && apt-get clean -y
ADD led.py .
ENTRYPOINT python led.py
