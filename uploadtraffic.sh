#!/bin/bash
###############################################

#### #### #### #### #   # ####
#  # #  # #    #  # # # # #  #
#### #### #### #### #  ## ####
#  # #  #    # #  # #   # #  #
#  # #  # #### #  # #   # #  #

###############################################

##FUNCION PARA CLASIFICAR EL TRAFICO
estudiarmsj() {
	#echo "estudiando msj......"
	#echo -e $bloque

	if [[ $bloque =~ .*FPL*.   ]];
	then

	# echo "tiene un plan de vuelo"
	echo -e "$bloque" > planesvuelo.tmp
	awk '!temp_array[$0]++' planesvuelo.tmp > planesvuelo2.tmp #elimina lineas repetidas del bloque
	sed -i '$ d' planesvuelo2.tmp

	#cat planesvuelo2.tmp >> ~/scripting/dataflp/planesvuelo$DATE #mueve en forma de bloque
	registro=`cat planesvuelo2.tmp` #convierte en linea al bloque
	echo $registro >> ~/scripting/dataflp/planesvueloline$DATE

	rm -r planesvuelo2.tmp planesvuelo.tmp
	fi

	if [[ $bloque =~ .*METAR*.   ]];
	then

	# echo "tiene metar"
	echo -e "$bloque" > metar.tmp
	awk '!temp_array[$0]++' metar.tmp > metar2.tmp #archivo con solo un mensaje amhs
	sed -i '$ d' metar2.tmp

	#cat metar2.tmp >> ~/scripting/datametar/metar$DATE
	cadenametar=`cat metar2.tmp`
	echo $cadenametar >> ~/scripting/datametar/metarline$DATE

	rm -r metar.tmp metar2.tmp
	fi

	if [[ $bloque =~ *SPECI*.   ]];
	then

	# echo "tiene speci"
	echo -e "$bloque" > speci.tmp
	awk '!temp_array[$0]++' speci.tmp > speci2.tmp
	sed -i '$ d' speci2.tmp

	#cat speci2.tmp >> ~/scripting/dataspeci/speci$DATE
	cadenaspeci=`cat speci2.tmp`
	echo $cadenaspeci >> ~/scripting/dataspeci/speciline$DATE

	rm -r speci.tmp speci2.tmp
	fi

	if [[ $bloque =~ *TAF*.   ]];
	then

	# echo "tiene taf"
	echo -e "$bloque" > taf.tmp
	awk '!temp_array[$0]++' taf.tmp > taf2.tmp
	sed -i '$ d' taf2.tmp

	#cat taf2.tmp >> ~/scripting/dataflp/taf$DATE
	cadenataf=`cat taf2.tmp`
	echo $cadenataf >> ~/scripting/datataf/tafline$DATE

	rm -r taf.tmp taf2.tmp
	fi

	if [[ $bloque =~ .*NOTAM*.   ]];
	then

	# echo "tiene notam"
	echo -e "$bloque" > notam.tmp
	awk '!temp_array[$0]++' notam.tmp > notam2.tmp
	sed -i '$ d' notam2.tmp

	#cat notam2.tmp >> ~/scripting/datanotam/notam$DATE
	cadenanotam=`cat notam2.tmp`
	echo $cadenanotam >> ~/scripting/datanotam/notamline$DATE

	rm -r notam.tmp notam2.tmp
	fi

}



DATE=`date +%d%m%Y`
if [ ! -d dataflp ];
then
 mkdir dataflp
fi
if [ ! -d datametar ];
then
mkdir datametar
fi

if [ ! -d datataf ];
then
mkdir datataf
fi

if [ ! -d dataspeci ];
then
mkdir dataspeci
fi

if [ ! -d datanotam ];
then
mkdir datanotam
fi


#verificando la existencia de archivos de registros

if [ -f ~/scripting/dataflp/planesvueloline$DATE ];
then
 mv ~/scripting/dataflp/planesvueloline$DATE ~/scripting/dataflp/planesvueloline$DATE.old
 echo "" >  ~/scripting/dataflp/planesvueloline$DATE
fi

if [ -f ~/scripting/datametar/metarline$DATE ];
then
 mv ~/scripting/datametar/metarline$DATE ~/scripting/datametar/metarline$DATE.old
 echo "" > ~/scripting/datametar/metarline$DATE
fi

if [ -f ~/scripting/datataf/tafline$DATE ];
then
 mv ~/scripting/datataf/tafline$DATE ~/scripting/datataf/tafline$DATE.old
 echo "" > ~/scripting/datataf/tafline$DATE
fi

if [ -f ~/scripting/dataspeci/speciline$DATE ];
then
 mv ~/scripting/dataspeci/speciline$DATE ~/scripting/dataspeci/speciline$DATE.old
 echo "" > ~/scripting/dataspeci/speciline$DATE
fi

if [ -f ~/scripting/datanotam/notamline$DATE ];
then
 mv ~/scripting/datanotam/notamline$DATE ~/scripting/datanotam/notamline$DATE.old
 echo "" > ~/scripting/datanotam/notamline$DATE
fi



##RECUPERAMOS EL TEXTO RESCATABLE DEL ARCHIVO BINARIO
cp messages.table messages

if [ -f resultado ];
then
rm -r resultado
fi

touch resultado
strings messages > resultado
i=0

##CREACION DE ARCHIVO ORGANIZADO POR SEPARADORES
if [ -f archseparado ];
then
rm -r archseparado
fi

echo "" > archseparado

while read line
do

	if [[ $line =~ .*ZPX0*. ]];
	then
		line="___A___\n$line"
	fi

	#line="${line#"${line%%[![:space:]]*}"}"   # elimina los espacios por delante

	echo -e $line  >> archseparado

done < resultado


##CREACION DE ARCHIVO ORGANIZADO POR BLOQUES, VARIABLE ES ASIGNADA UN BLOQUE
if [ -f archbloques ];
then
rm -r archbloques
fi
echo "" > archbloques

bloque=""
while read line
do
if [[ $line =~ .*_A_*. ]];
then
echo -e $bloque |  tr -d '[[:space:]]' >> archbloques

(estudiarmsj $bloque)

bloque=""
else
bloque="$bloque \n$line"
fi

done < archseparado



#CREANDO EL ARCHIVO SQL PARA ACTUALIZAT DB

if [ -f ~/scripting/dataflp/planesvueloline$DATE.old ];
then
 diff -wBa ~/scripting/dataflp/planesvueloline$DATE ~/scripting/dataflp/planesvueloline$DATE.old > ~/scripting/dataflp/updateflp.sql
	if [ ! -s ~/scripting/dataflp/updateflp.sql ];
	then
		echo -e "\e[33m >>> FLP whithout changes \e[0m"
		#sed -i '1 d' ~/scripting/dataflp/updateflp.sql
	else
		echo -e "\e[32m >>> FLP updating ... \e[0m"
	fi
else
 touch vacio.txt #archivo para generar primera columna en el archivo updateflp.sql
 diff -wBa ~/scripting/dataflp/planesvueloline$DATE ~/scripting/vacio.txt > ~/scripting/dataflp/updateflp.sql #en caso de q no exista un archivo anterior y se ejecute por primera vez en el dia
 echo -e "\e[32m >>> FLP inserting ... \e[0m"
 rm vacio.txt
fi

if [ -f ~/scripting/datametar/metarline$DATE.old ];
then
 diff -wBa ~/scripting/datametar/metarline$DATE ~/scripting/datametar/metarline$DATE.old > ~/scripting/datametar/updatemetar.sql
	if [ ! -s ~/scripting/datametar/updatemetar.sql ];
		then
		echo -e "\e[33m >>> METAR whithout changes \e[0m"
 		#sed -i '1 d' ~/scripting/datametar/updatemetar.sql
	else
		echo -e "\e[32m >>> METAR updating ... \e[0m"
	fi
else
 touch vacio.txt #archivo para generar primera columna en el archivo updateflp.sql
 diff -wBa ~/scripting/datametar/metarline$DATE ~/scripting/vacio.txt > ~/scripting/datametar/updatemetar.sql
 echo -e "\e[32m >>> METAR inserting ... \e[0m"
 rm vacio.txt

fi

if [ -f ~/scripting/datataf/tafline$DATE.old ];
then
 diff -wBa ~/scripting/datataf/tafline$DATE ~/scripting/datataf/tafline$DATE.old > ~/scripting/datataf/updatetaf.sql
	if [ ! -s ~/scripting/datataf/updatetaf.sql ];
		then
		echo -e "\e[33m >>> TAF whithout changes \e[0m"
		#sed -i '1 d' ~/scripting/datataf/updatetaf.sql
	else
		echo -e "\e[32m >>> TAF updating ... \e[0m"
	fi
fi

if [ -f ~/scripting/dataspeci/speciline$DATE.old ];
then
 diff -wBa ~/scripting/dataspeci/speciline$DATE ~/scripting/dataspeci/speciline$DATE.old > ~/scripting/dataspeci/updatespeci.sql
	if [ ! -s ~/scripting/dataspeci/updatespeci.sql ];
		then
		echo -e "\e[33m >>> SPECI whithout changes \e[0m"
		#sed -i '1 d' ~/scripting/dataspeci/updatespeci.sql
	else
		echo -e "\e[32m >>> SPECI updating ... \e[0m"
	fi
fi

if [ -f ~/scripting/datanotam/notamline$DATE.old ];
then
 diff -wBa ~/scripting/datanotam/notamline$DATE ~/scripting/datanotam/notamline$DATE.old > ~/scripting/datanotam/updatenotam.sql
	if [ ! -s ~/scripting/datanotam/updatenotam.sql ];
		then
		echo -e "\e[33m >>> NOTAM whithout changes \e[0m"
		# sed -i '1 d' ~/scripting/datanotam/updatenotam.sql
	else
		echo -e "\e[32m >>> NOTAM updating ... \e[0m"
	fi
fi

bash updatingdb.sh
