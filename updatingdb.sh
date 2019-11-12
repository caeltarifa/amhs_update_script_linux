#!/bin/bash
DATE=`date +%d%m%Y`

# FLP --->  DANDO FORMATO PARA INTRODUCIR A DB E INTRODUCIOENDO A LA DB
if [ -f ~/scripting/dataflp/updateflp.sql ] && [ ! -s ~/scripting/dataflp/updateflp.sql ];
then

	cp ~/scripting/dataflp/updateflp.sql ~/scripting/dataflp/updateflp.tmp

	sqlflp=~/scripting/dataflp/updateflp.tmp

	sed -i '1 d' $sqlflp
	awk -f ~/scripting/query/flp.awk $sqlflp > ~/scripting/dataflp/updateflp.sql
	echo "......base de datos actualizada FLP!!!"

	systemctl start updateaftn_db.service
	#systemctl status updateaftn_db.service

	#rm ~/scripting/dataflp/updateflp.tmp ~/scripting/dataflp/updateflp.sql
else
	echo "no ha pasado nada FLP"
fi

# METAR --->  DANDO FORMATO PARA INTRODUCIR A DB E INTRODUCIOENDO A LA DB
#sqlmetar=~/scripting/datametar/updatemetar.sql
if [ -f ~/scripting/datametar/updatemetar.sql ] && [ ! -s ~/scripting/datametar/updatemetar.sql  ];
then

	cp ~/scripting/datametar/updatemetar.sql ~/scripting/datametar/updatemetar.tmp

	sqlmetar=~/scripting/datametar/updatemetar.tmp

	sed -i '1 d' $sqlflp
	awk -f ~/scripting/query/metar.awk $sqlmetar > ~/scripting/datametar/updatemetar.sql
	echo "......base de datos actualizada METAR!!!"

	systemctl start updatemetar_db.service
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
