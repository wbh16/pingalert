#!/bin/bash
## Produzido por Wemerson Bruno ###
# pingalert
# Script para testar conexão usando protocolo ICMP

#### Variaveis ###
IPdoServidor="???.???.???.???"			# Ip que será pingado para testar resposta
IPdoServidor2="???.???.???.???"			# Ip que será pingado para conferir resposta
local_pingalert='/root/scripts/pingalert/'	# Local do arq. que define o tipo de bip
###

### Teste de Comunicação com o Servidor ###
testa_ping(){
if ! ping -c 1 $IPdoServidor >/dev/null; then
#	echo "bip3"
        "$local_pingalert"/bip.sh bip5
	sleep 5
else
#	echo "bip4"
	"$local_pingalert"/bip.sh bip6
	sleep 3
        rm -rf /tmp/pingalert.tmp
	rm -rf /tmp/pingalert2.tmp
	exit 1
fi
}

### Faz um loop enquanto a variavel "cont" for maior que "0"' ###
loop_ping(){
if [ -e /tmp/pingalert.tmp ]; then
	touch /tmp/pingalert2.tmp
fi

while [ -e /tmp/pingalert2.tmp ]
do
	testa_ping
done
}

########## iniciar #########
start_force(){
	if [ -e /tmp/pingalert3.tmp ]; then
	rm -rf /tmp/pingalert3.tmp
	start
fi
start
}
start(){
#Checa se o pacote beep está instalado
if ! type beep 1>/dev/null 2>/dev/null; then # Checa se houve erro
        echo "Pacote beep não está instalado neste servidor."
        echo "para instalar use o comando: apt-get install beep"
#	apt-get install beep
        exit 1
fi
#
# Testa se pingalert foi parado manualmente
if [ -e /tmp/pingalert3.tmp ]; then
        echo "Pingalert parado manualmente pelo comando: ./pingalert stop"
	echo "Para iniciar novamente sem reiniciar use o comando: ./pingalert start_force"
        exit 1
fi

# Testa se está em execução o script
if [ -e /tmp/pingalert.tmp ]; then
        echo "Pingalert em execução"
        exit 1
fi
#

# Cria arquivo na pasta temporaria que sinaliza que o script já está em execução.
if [ -e "$local_pingalert"bip.sh ]; then
	touch /tmp/pingalert.tmp
else
        echo "O arquivo" $local_pingalert"bip.sh não foi encontrado"
        exit 1
fi

#
if ! ping -c 1 $IPdoServidor >/dev/null; then
#	echo "bip 1"
	"$local_pingalert"/bip.sh bip5
	sleep 2
	if ! ping -c 3 $IPdoServidor2 >/dev/null; then
#		echo "bip 2"
		"$local_pingalert"/bip.sh bip4
		sleep 3
		loop_ping
	else
		echo "Servidor ativo!!!"
        	rm -rf /tmp/pingalert.tmp
		exit 1	
	fi
else
	echo "Servidor ativo!!!"
        rm -rf /tmp/pingalert.tmp
	exit 1
fi
}

########## Parar ##########
stop(){
if [ -e /tmp/pingalert.tmp ]; then
	rm -rf /tmp/pingalert2.tmp
else
        echo "O programa não está em execução"
	echo "Para voltar a monitorar sem reiniciar use: pingalert ./start_force "
	echo "Aguarde... "
fi
# tem que testar pelo processo se parou mesmo, neste ponto
sleep 10
if [ -e /tmp/pingalert3.tmp ]; then
	echo "Programa já parado manualmente"
else
	touch /tmp/pingalert3.tmp 
fi
rm -rf /tmp/pingalert.tmp
echo "ok "
}
#

case $1 in
   start) start ;;
   stop) stop ;;
   start_force) start_force ;;
   *) echo "Você tem de entrar com um parâmetro válido - start, start_force ou stop" ;;
esac
