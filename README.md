Este script possibilita que sejam feitos testes usando o protocolo ICMP (ping) em até dois endereços de IP's. Serão emitidos sinais sonoros indicando falha na comunicação.

Utilizamos o programa "beep", que usa o buzzer da placa mãe para tocar algum áudio, dispensando a instalação de placa de som, ideal para servidores que usam linux sem interface gráfica.

Usamos o Debiam 8 e o procedimento de instalação será com base nesta distribuição.

1 - Instalar programa beep:

    sudo apt-get install beep

2 - Criar a pasta onde serão abrigados os scripts:

    sudo mkdir -p /root/scripts/pingalert/ && cd /root//scripts/pingalert/

3 - Script com sons do beep:

    sudo nano /root/scripts/pingalert/bip.sh

Adicione o conteúdo do arquivo baixado: "bip.sh".

Para efetuar testes e verificar se algum som será tocado temos os seguintes comando:

    /root/scripts/pingalert/bip.sh bip1    # Do, re, mi, fa

    /root/scripts/pingalert/bip.sh bip2    # Pretty Woman

    /root/scripts/pingalert/bip.sh bip3    # Super Mario

    /root/scripts/pingalert/bip.sh bip4    # Queda link

Caso algum cooperador tenha talento e tempo para aperfeiçoar e criar novos sons, compartilhe conosco.

4 - Script que testa conexão e chama "beep" em caso de falha:

    sudo nano /root/scripts/pingalert/pingalert.sh

Adicione o conteúdo do arquivo baixado: "pingalert.sh".

Comportamento do script:

   Ao ser executado ele pinga uma vez o primeiro endereço de IP informado na variável.
   Se houver resposta não faz nada, se não houver, toca um som de alerta, aguarda dois segundos e pinga por três vezes o segundo endereço de IP.
   Se houver resposta não faz nada, se não houver, toca um som indicando sem link, aguarda três segundos e entra em um loop saindo deste somente com o restabelecimento da conexão.

5 - Adicione ao final do arquivo "/etc/crontab" a linha abaixo para que o script seja executado a cada minuto:

    nano /etc/crontab

adicione ao final do arquivo:

    */1 * * * * root /root/scripts/pingalert/pingalert.sh start>/dev/null 2>&1

Observações:

   Entre outros, os servidores DNS 8.8.8.8 e 8.8.4.4 bloqueiam o recebimento de ping constantes, então escolha com cuidado quem você irá pingar. Recomenda-se pingar para algum IP válido na internet ou o gatewall da sua rede interna.
   
   Este script pode ser usado em inúmeras situações, por exemplo: tendo dois links com a internet se um ficar indisponível podemos chamar outro script que configure o link de backup.
   
   Arquivos de sons: referência: https://www.vivaolinux.com.br/script/Musiquinhas-com-beep.
