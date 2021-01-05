#!/bin/bash
###############################################

#### #### #### #### #   # ####
#  # #  # #    #  # # # # #  #
#### #### #### #### #  ## ####
#  # #  #    # #  # #   # #  #
#  # #  # #### #  # #   # #  #

###############################################
#1678317288 passwd:71fu3p

PATHX="/root/scripting"
DATE=`date +%d%m%Y`

agregarSeparadorNOTAM(){
cont=1
mensajeNOTAM=""
while read line
do
        if [ "$line" != "" ];
        then
                if [ "$cont" -le 4 ]
                then
                        #echo "$line@CAELT@"
                        campo="$line@CAELT@"
                        mensajeNOTAM="$mensajeNOTAM$campo"
                else
		        #echo "$line "
		        mensajeNOTAM="$mensajeNOTAM$line;;"
                fi
        fi
        cont=$((cont+1))
done < $1
echo "$mensajeNOTAM"
}




agregarSeparadorFPL(){
cont=1
mensajeFPL=""
while read line
do
	if [ "$line" != "" ];
	then
		if [ "$cont" -le 9 ]
		then
			#echo "$line@CAELT@"
			campo="$line@CAELT@"

			mensajeFPL="$mensajeFPL$campo"

			else
			#echo "$line "

			mensajeFPL="$mensajeFPL$line"
		fi
	fi
	cont=$((cont+1))
done < $1
echo "$mensajeFPL"
}


##FUNCION PARA CLASIFICAR EL TRAFICO
estudiarmsj() {
	#echo "estudiando msj......"
	#echo -e $bloque

	if [[ $bloque =~ .*FPL*.   ]];
	then
		# echo "tiene un plan de vuelo"
		echo -e "$bloque" > "$PATHX/dataflp/planesvuelo.tmp"
		awk '!temp_array[$0]++' $PATHX/dataflp/planesvuelo.tmp > $PATHX/dataflp/planesvuelo2.tmp #elimina lineas repetidas del bloque
		sed -i '$ d' "$PATHX/dataflp/planesvuelo2.tmp"

		#cat planesvuelo2.tmp >> ~/scripting/dataflp/planesvuelo$DATE #mueve en forma de bloque
		registro=$(agregarSeparadorFPL $PATHX/dataflp/planesvuelo2.tmp) #`cat $PATHX/dataflp/planesvuelo2.tmp` #convierte en linea al bloque con separador @CAELT@
		echo $registro >> $PATHX/dataflp/planesvueloline$DATE

		rm -r $PATHX/dataflp/planesvuelo2.tmp $PATHX/dataflp/planesvuelo.tmp
	fi


	if [[ $bloque =~ .*NOTAM*.   ]];
        then

         echo "tiene notam"
        #echo -e "$bloque" > notam.tmp
        #awk '!temp_array[$0]++' notam.tmp > notam2.tmp
        #sed -i '$ d' notam2.tmp

        #cat notam2.tmp >> ~/scripting/datanotam/notam$DATE
        #cadenanotam=`cat notam2.tmp`
        #echo $cadenanotam >> $PATHX/datanotam/notamline$DATE

        #rm -r notam.tmp notam2.tmp

	#-------------------------

	echo -e "$bloque" > "$PATHX/datanotam/notam.tmp"
        awk '!temp_array[$0]++' $PATHX/datanotam/notam.tmp > $PATHX/datanotam/notam2.tmp #elimina lineas repetidas del bloque
        sed -i '$ d' "$PATHX/datanotam/notam2.tmp"

        #cat planesvuelo2.tmp >> ~/scripting/dataflp/planesvuelo$DATE #mueve en forma de bloque
        registro=$(agregarSeparadorNOTAM $PATHX/datanotam/notam2.tmp) #`cat $PATHX/dataflp/planesvuelo2.tmp` #convierte en linea al bloque con separador @CAELT@
        echo $registro >> $PATHX/datanotam/notamline$DATE

#        rm -r $PATHX/datanotam/notam2.tmp $PATHX/dataflp/notam.tmp

        fi


	if [[ $bloque =~ .*METAR*.   ]];
	then

	# echo "tiene metar"
	echo -e "$bloque" > "$PATHX/datametar/metar.tmp"
	awk '!temp_array[$0]++' "$PATHX/datametar/metar.tmp" > "$PATHX/datametar/metar2.tmp" #archivo con solo un mensaje amhs
	sed -i '$ d' "$PATHX/datametar/metar2.tmp"

	#cat metar2.tmp >> ~/scripting/datametar/metar$DATE
	cadenametar=$(agregarSeparadorFPL $PATHX/datametar/metar2.tmp) # `cat metar2.tmp` #convierte en linea al bloque con separador @CAELT@
	echo $cadenametar >> $PATHX/datametar/metarline$DATE

	rm -r $PATHX/datametar/metar.tmp $PATHX/datametar/metar2.tmp
	fi

	if [[ $bloque =~ *SPECI*.   ]];
	then

	# echo "tiene speci"
	echo -e "$bloque" > speci.tmp
	awk '!temp_array[$0]++' speci.tmp > speci2.tmp
	sed -i '$ d' speci2.tmp

	#cat speci2.tmp >> ~/scripting/dataspeci/speci$DATE
	cadenaspeci=`cat speci2.tmp`
	echo $cadenaspeci >> $PATHX/scripting/dataspeci/speciline$DATE

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
	echo $cadenataf >> $PATHX/scripting/datataf/tafline$DATE

	rm -r taf.tmp taf2.tmp
	fi

}

#CAMIANDO EL DIRECTORIO PARA PODER EJECUTAR EL SCRIPT DESDE ESTE DIRECTORIO
#cd /root/scripting

#DATE=`date +%d%m%Y`
if [ ! -d $PATHX/dataflp ];
then
mkdir $PATHX/dataflp
fi
if [ ! -d $PATHX/datametar ];
then
mkdir $PATHX/datametar
fi

if [ ! -d $PATHX/datataf ];
then
mkdir $PATHX/datataf
fi

if [ ! -d $PATHX/dataspeci ];
then
mkdir $PATHX/dataspeci
fi

if [ ! -d $PATHX/datanotam ];
then
mkdir $PATHX/datanotam
fi


#verificando la existencia de archivos de registros

if [ -f $PATHX/dataflp/planesvueloline$DATE ];
then
 mv $PATHX/dataflp/planesvueloline$DATE $PATHX/dataflp/planesvueloline$DATE.old
 echo "" >  $PATHX/dataflp/planesvueloline$DATE
fi

if [ -f $PATHX/datametar/metarline$DATE ];
then
 mv $PATHX/datametar/metarline$DATE $PATHX/datametar/metarline$DATE.old
 echo "" > $PATHX/datametar/metarline$DATE
fi

if [ -f $PATHX/datataf/tafline$DATE ];
then
 mv $PATHX/datataf/tafline$DATE $PATHX/datataf/tafline$DATE.old
 echo "" > $PATHX/datataf/tafline$DATE
fi

if [ -f $PATHX/dataspeci/speciline$DATE ];
then
 mv $PATHX/dataspeci/speciline$DATE $PATHX/dataspeci/speciline$DATE.old
 echo "" > $PATHX/dataspeci/speciline$DATE
fi

if [ -f $PATHX/datanotam/notamline$DATE ];
then
 mv $PATHX/datanotam/notamline$DATE $PATHX/datanotam/notamline$DATE.old
 echo "" > $PATHX/datanotam/notamline$DATE
fi



##RECUPERAMOS EL TEXTO RESCATABLE DEL ARCHIVO BINARIO
cp $PATHX/messages.table $PATHX/messages

if [ -f $PATHX/resultado ];
then
rm -r $PATHX/resultado
fi

touch $PATHX/resultado
strings $PATHX/messages > $PATHX/resultado
i=0

##CREACION DE ARCHIVO ORGANIZADO POR SEPARADORES
if [ -f $PATHX/archseparado ];
then
rm -r $PATHX/archseparado
fi

echo "" > $PATHX/archseparado

while read line
do

	if [[ $line =~ .*ZPX0*. ]];
	then
		line="___A___\n$line"
	fi

	#line="${line#"${line%%[![:space:]]*}"}"   # elimina los espacios por delante

	echo -e $line  >> $PATHX/archseparado

done < $PATHX/resultado


##CREACION DE ARCHIVO ORGANIZADO POR BLOQUES, VARIABLE ES ASIGNADA UN BLOQUE
if [ -f $PATHX/archbloques ];
then
rm -r $PATHX/archbloques
fi
echo "" > $PATHX/archbloques

bloque=""
while read line
do
if [[ $line =~ .*_A_*. ]];
then
echo -e $bloque |  tr -d '[[:space:]]' >> $PATHX/archbloques

(estudiarmsj $bloque)

bloque=""
else
bloque="$bloque \n$line"
fi

done < $PATHX/archseparado










#CREANDO EL ARCHIVO SQL PARA ACTUALIZAT DB

if [ -f $PATHX/dataflp/planesvueloline$DATE ];
then
	python3 $PATHX/query/queryFPL.py
	systemctl restart updateaftn_db
#	echo "" > $PATHX/dataflp/updateFPL.sql
	echo -e "\e[32m >>> FLP updating ... \e[0m"
fi

if [ -f $PATHX/datanotam/notamline$DATE ];
then
	python3 $PATHX/query/queryNOTAM.py
	systemctl restart updatenotam_db
#	echo "" > $PATHX/datanotam/updateNOTAM.sql
	echo -e "\e[32m >>> NOTAM updating ... \e[0m"
fi

#if [ -f $PATHX/dataflp/planesvueloline$DATE.old ];
#then
# diff -wBa $PATHX/dataflp/planesvueloline$DATE $PATHX/dataflp/planesvueloline$DATE.old > $PATHX/dataflp/updateflp.sql
#	if [ ! -s $PATHX/dataflp/updateflp.sql ];
#	then
#		echo -e "\e[33m >>> FLP whithout changes \e[0m"
#		#sed -i '1 d' ~/scripting/dataflp/updateflp.sql
#	else
#		echo -e "\e[32m >>> FLP updating ... \e[0m"
#	fi
#else
# touch $PATHX/vacio.txt #archivo para generar primera columna en el archivo updateflp.sql
# diff -wBa $PATHX/dataflp/planesvueloline$DATE $PATHX/vacio.txt > $PATHX/dataflp/updateflp.sql #en caso de q no exista un archivo anterior y se ejecute por primera vez en el dia
# echo -e "\e[32m >>> FLP inserting ... \e[0m"
# rm $PATHX/vacio.txt
#fi



#if [ -f $PATHX/datametar/metarline$DATE.old ];
#then
# diff -wBa $PATHX/datametar/metarline$DATE $PATHX/datametar/metarline$DATE.old > $PATHX/datametar/updatemetar.sql
#	if [ ! -s $PATHX/datametar/updatemetar.sql ];
#		then
#		echo -e "\e[33m >>> METAR whithout changes \e[0m"
# 		#sed -i '1 d' ~/scripting/datametar/updatemetar.sql
#	else
#		echo -e "\e[32m >>> METAR updating ... \e[0m"
#	fi
#else
# touch $PATHX/vacio.txt #archivo para generar primera columna en el archivo updateflp.sql
# diff -wBa $PATHX/datametar/metarline$DATE $PATHX/vacio.txt > $PATHX/datametar/updatemetar.sql
# echo -e "\e[32m >>> METAR inserting ... \e[0m"
# rm $PATHX/vacio.txt
#fi


if [ -f $PATHX/datataf/tafline$DATE.old ];
then
 diff -wBa $PATHX/datataf/tafline$DATE $PATHX/datataf/tafline$DATE.old > $PATHX/datataf/updatetaf.sql
	if [ ! -s $PATHX/datataf/updatetaf.sql ];
		then
		echo -e "\e[33m >>> TAF whithout changes \e[0m"
		#sed -i '1 d' ~/scripting/datataf/updatetaf.sql
	else
		echo -e "\e[32m >>> TAF updating ... \e[0m"
	fi
fi

if [ -f $PATHX/dataspeci/speciline$DATE.old ];
then
 diff -wBa $PATHX/dataspeci/speciline$DATE $PATHX/dataspeci/speciline$DATE.old > $PATHX/dataspeci/updatespeci.sql
	if [ ! -s $PATHX/dataspeci/updatespeci.sql ];
		then
		echo -e "\e[33m >>> SPECI whithout changes \e[0m"
		#sed -i '1 d' ~/scripting/dataspeci/updatespeci.sql
	else
		echo -e "\e[32m >>> SPECI updating ... \e[0m"
	fi
fi

#if [ -f $PATHX/datanotam/notamline$DATE.old ];
#then
# diff -wBa $PATHX/datanotam/notamline$DATE $PATHX/datanotam/notamline$DATE.old > $PATHX/datanotam/updatenotam.sql
#	if [ ! -s $PATHX/datanotam/updatenotam.sql ];
#		then
#		echo -e "\e[33m >>> NOTAM whithout changes \e[0m"
#		# sed -i '1 d' ~/scripting/datanotam/updatenotam.sql
#	else
#		echo -e "\e[32m >>> NOTAM updating ... \e[0m"
#	fi
#fi

#bash $PATHX/updatingdb.sh
