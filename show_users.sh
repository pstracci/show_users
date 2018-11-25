#!/bin/bash

# Autor: Paulo Stracci
# Data: 25/11/2018
# Descrição: Mostra o login e os nomes de usuários do sistema
#			 Obs: Lê os dados do  arquivo /etc/passwd
#
# Licença: GNU General Public License (GPL)
# -----------------------------------------------------------------------------
# Histórico de versões
#
# Versão 1: Criação do Programa
# Versão 2: Adicionada a opção -h
# Versão 3: Adicionada a opção -V
# Versão 4: Adicionado o case para escolha das opções
# Versão 5: Adicionado a opção -s, --sort
# Versão 6: Adicionado a opção --uppercase, --reverse
# Versão 7: Incluido o comando shift
# Versão 8: Incluido a opção de delimitador

MENSAGEM_USO="


Uso: $(basename "$0") [OPÇÕES]

OPÇÕES:
	-h, --help	Mostra essa tela de ajuda e sai
	-V, --version	Mostra a versão do programa
	-s, --sort	Lista os usuários em ordem alfabética
	-r, --reverse	Mostra os usuários em ordem invertida
	-u, --uppercase Mostra os usuários em letra maiúscula
	-d, --delimiter	Escolhe o delimitador entre as palavras

"
while test -n "$1" 
do

case "$1" in
	-u | --uppercase) uppercase=1 ;;
	-d | --delimiter)
	shift
	delimiter="$1"
	
	if test -z "$delimiter"
	then
		echo  "Faltou o argumento para a opção -d"
		exit 1
	fi
	;;
	
	-r | --reverse) reverse=1 ;;
	-s | --sort	) ordenar=1 ;;
	-h | --help ) echo "$MENSAGEM_USO"
	exit 0	;;
	-V | --version )	grep '^# Versão ' "$0" | tail -1 | cut -d: -f 1 | tr -d \#
	exit 0	;;
	*)	echo "Opção inválida": $1
	exit 1	;;
esac

shift #Opção $1 já processada, a fila deve andar
done


# Extrai a listagem
lista=$(cut -d: -f1,5 /etc/passwd)

echo "$ordenar"
#Ordena a listagem se necessário
test "$ordenar" = 1 && lista=$(echo "$lista" | sort)
test "$reverse" = 1 && lista=$(echo "$lista" | tac)
test "$uppercase" = 1 && lista=$(echo "$lista" | tr a-z A-Z)

# Mostra o resultado para o usuário

echo "$lista" | tr : "$delimiter"
