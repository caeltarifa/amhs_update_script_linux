#!/bin/bash
cd /root/scripting
DATE=`date +%d%m%Y`
PATHX="/root/scripting"

#su - postgres

# FLP --->  DANDO FORMATO PARA INTRODUCIR A DB E INTRODUCIOENDO A LA DB
if [ -f $PATHX/dataflp/updateflp.sql ]; # && [ ! -s ~/scripting/dataflp/updateflp.sql ];
then
	cp $PATHX/dataflp/updateflp.sql $PATHX/dataflp/updateflp.tmp

	sqlflp=$PATHX/dataflp/updateflp.tmp

	sed -i '1 d' $sqlflp
	awk -f $PATHX/query/flp.awk $sqlflp > $PATHX/dataflp/updateflp.sql
	echo "......base de datos actualizada FLP!!!"

	#VER CON EL CONTENIDO DE LA CONSULTA SQL DE LOS MENSAJES FPL
		####VER PLANES DE VUELO INSERTADOS####   cat $PATHX/dataflp/updateflp.sql

	systemctl start updateaftn_db.service

	#psql -U postgres -d upsilon_db -f /root/scripting/dataflp/updateflp.sql

	#verificando el estado de conexion de la base de datos AMHS
	#systemctl status updateaftn_db.service

	#rm ~/scripting/dataflp/updateflp.tmp ~/scripting/dataflp/updateflp.sql
else
	echo ">>>>>>>>>>>>>>>no ha pasado nada FLP"
fi


# NOTAM --->  DANDO FORMATO PARA INTRODUCIR A DB E INTRODUCIOENDO A LA DB
if [ -f $PATHX/datanotam/updatenotam.sql ]; # && [ ! -s ~/scripting/dataflp/updateflp.sql ];
then

        cp $PATHX/datanotam/updatenotam.sql $PATHX/datanotam/updatenotam.tmp

        sqlflp=$PATHX/datanotam/updatenotam.tmp

        sed -i '1 d' $sqlflp
        awk -f $PATHX/query/flp.awk $sqlflp > $PATHX/dataflp/updateflp.sql
        echo "......base de datos actualizada FLP!!!"

        #VER CON EL CONTENIDO DE LA CONSULTA SQL DE LOS MENSAJES FPL
                ####VER PLANES DE VUELO INSERTADOS####   cat $PATHX/dataflp/updateflp.sql

        systemctl start updateaftn_db.service

        #psql -U postgres -d upsilon_db -f /root/scripting/dataflp/updateflp.sql

        #verificando el estado de conexion de la base de datos AMHS
        #systemctl status updateaftn_db.service

        #rm ~/scripting/dataflp/updateflp.tmp ~/scripting/dataflp/updateflp.sql
else
        echo ">>>>>>>>>>>>>>>no ha pasado nada FLP"
fi


# METAR --->  DANDO FORMATO PARA INTRODUCIR A DB E INTRODUCIOENDO A LA DB
#sqlmetar=~/scripting/datametar/updatemetar.sql
if [ -f $PATHX/datametar/updatemetar.sql ]; # && [ ! -s ~/scripting/datametar/updatemetar.sql  ];
then

	cp $PATHX/datametar/updatemetar.sql $PATHX/datametar/updatemetar.tmp

	sqlmetar=$PATHX/datametar/updatemetar.tmp

	sed -i '1 d' $sqlmetar
	awk -f $PATHX/query/metar.awk $sqlmetar > $PATHX/datametar/updatemetar.sql
	echo "......base de datos actualizada METAR!!!"
	
	systemctl start updatemetar_db.service

	#VER CON EL CONTENIDO DE LA CONSULTA SQL DE LOS MENSAJES METAR
		#cat $PATHX/datametar/updatemetar.sql
		#systemctl status updateaftn_db.service

	#rm ~/scripting/dataflp/updateflp.tmp ~/scripting/dataflp/updateflp.sql
else
	echo "no ha pasado nada METAR"
fi




#sqltaf=~/scripting/datataf/updatetaf.sql
#sqlspeci=~/scripting/dataspeci/updatespeci.sql
#sqlnotam=~/scripting/datanotam/updatenotam.sql

#sed -i '1 d' $sqlmetar
#sed -i '1 d' $sqltaf
#sed -i '1 d' $sqlspeci
#sed -i '1 d' $sqlnotam
