docker rm gmod
docker run -d -p 27015:27015/udp --name gmod -t gmod
