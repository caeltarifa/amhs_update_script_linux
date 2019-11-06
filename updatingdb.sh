#!/bin/bash
DATE=`date +%d%m%Y`

if [ -f ~/scripting/dataflp/updateflp.sql ];
then

cp ~/scripting/dataflp/updateflp.sql ~/scripting/dataflp/updateflp.tmp

sqlflp=~/scripting/dataflp/updateflp.tmp

sed -i '1 d' $sqlflp
awk -f ~/scripting/query/flp.awk $sqlflp > ~/scripting/dataflp/updateflp.sql
echo "......base de datos actualizada!!!"

systemctl start updateaftn_db.service
systemctl status updateaftn_db.service

#rm ~/scripting/dataflp/updateflp.tmp ~/scripting/dataflp/updateflp.sql
else
echo "no ha pasado nada"
fi

#sqlmetar=~/scripting/datametar/updatemetar.sql
#sqltaf=~/scripting/datataf/updatetaf.sql
#sqlspeci=~/scripting/dataspeci/updatespeci.sql
#sqlnotam=~/scripting/datanotam/updatenotam.sql

#sed -i '1 d' $sqlmetar
#sed -i '1 d' $sqltaf
#sed -i '1 d' $sqlspeci
#sed -i '1 d' $sqlnotam
