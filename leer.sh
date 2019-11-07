#!/bin/bash
DATE=`date +%d%m%Y`

if [ -f planesvuelo$DATE ] && [ -f metar$DATE ] && [ -f taf$DATE ] && [ -f speci$DATE ] && [ -f notam$DATE ]
then
rm -r planesvuelo$DATE metar$DATE taf$DATE speci$DATE notam$DATE
fi

##FUNCION PARA CLASIFICAR EL TRAFICO
estudiarmsj() {
#echo "estudiando msj......"
#echo -e $bloque

if [[ $bloque =~ .*FPL*.   ]];
then

 echo "tiene un plan de vuelo"
 echo -e "$bloque" > planesvuelo.tmp
 awk '!temp_array[$0]++' planesvuelo.tmp > planesvuelo2.tmp
 sed -i '$ d' planesvuelo2.tmp
 cat planesvuelo2.tmp >> planesvuelo$DATE
 rm -r planesvuelo2.tmp planesvuelo.tmp
fi

if [[ $bloque =~ .*METAR*.   ]];
then

 echo "tiene metar"
 echo -e "$bloque" > metar.tmp
 awk '!temp_array[$0]++' metar.tmp > metar2.tmp
 sed -i '$ d' metar2.tmp
 cat metar2.tmp >> metar$DATE
 rm -r metar.tmp metar2.tmp
fi

if [[ $bloque =~ .*"SPECI SL"*.   ]];
then

 echo "tiene speci"
 echo -e "$bloque" > speci.tmp
 awk '!temp_array[$0]++' speci.tmp > speci2.tmp
 sed -i '$ d' speci2.tmp
 cat speci2.tmp >> speci$DATE
 rm -r speci.tmp speci2.tmp
fi

if [[ $bloque =~ *TAF*.   ]];
then

 echo "tiene taf"
 echo -e "$bloque" > taf.tmp
 awk '!temp_array[$0]++' taf.tmp > taf2.tmp
 sed -i '$ d' taf2.tmp
 cat taf2.tmp >> taf$DATE
 rm -r taf.tmp taf2.tmp
fi

if [[ $bloque =~ .*NOTAM*.   ]];
then

 echo "tiene notam"
 echo -e "$bloque" > notam.tmp
 awk '!temp_array[$0]++' notam.tmp > notam2.tmp
 sed -i '$ d' notam2.tmp
 cat notam2.tmp >> notam$DATE
 rm -r notam.tmp notam2.tmp
fi

}

##RECUPERAMOS EL TEXTO RESCATABLE DEL ARCHIVO BINARIO
cp messages.table messages
rm -r resultado
touch resultado
strings messages > resultado
i=0

##CREACION DE ARCHIVO ORGANIZADO POR SEPARADORES
rm -r archseparado
touch archseparado

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
rm -r archbloques
touch archbloques

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
