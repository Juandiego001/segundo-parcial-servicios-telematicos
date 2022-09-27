echo "Actualizando apt con apt-get update e instalando los servicios necesarios..."
sudo apt-get update
sudo apt-get install network-manager -y

echo "Viendo el estado del servicio..."
sudo resolvectl status

echo "Iniciando el servicio..."
sudo systemctl start NetworkManager

echo "Configurando el system-resolved con cat..."
cat <<TEST> /etc/systemd/resolved.conf
[Resolve]
DNS=1.1.1.1 1.0.0.1
FallbackDNS=8.8.8.8 8.8.4.4

Domains=~.
#LLMNR=no
#MulticastDNS=no
DNSSEC=yes
DNSOverTLS=yes
#Cache=yes
#DNSStubListener=yes
#ReadEtcHosts=yes
TEST

echo "Reiniciando los servicios..."
sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager

echo "Verificando la configuracion..."
sudo resolvectl status

echo "Ejecutando y verificando las transacciones de DNS sobre TLS..."
sudo resolvectl flush-caches
sudo resolvectl query google.com
