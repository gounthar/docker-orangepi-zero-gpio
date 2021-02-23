# docker-orangepi-zero-gpio
Trying to stuff a few GPIO libraries for the OrangePi Zero in a Docker image

If you wire a LED (and a 4.7kOhm resistor) between the 6 and 7 GPIO pin, you should see it blinking when issuing:

```bash
docker run --device /dev/ttyAMA0:/dev/ttyAMA0 --device /dev/mem:/dev/mem --privileged -ti gounthar/zero-gpio:latest
```
