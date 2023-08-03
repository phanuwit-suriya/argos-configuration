var1=$(hostname)
var2=$(hostname -I | sed "s/ *$//" | sed -e "s/ /, /g")

echo -e "HOSTNAME=$var1\nHOSTADDRESS=$var2" > .env

docker-compose up -d