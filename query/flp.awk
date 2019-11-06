BEGIN {

RS="\n";FS=" "

}

{
cmd="date +%d-%m-%Y";
cmd | getline datum;
close(cmd);
#print $1 datum;
print "insert into plan_vuelo_flp_trafico (id_amhs,hora_amhs,fecha_llegada,prioridad,id_plan,transponder,origen,texto,visto,visto_por) values (\047" $2"\047,\047"$3"\047,\047"datum"\047,\047"$4"\047,\047"$8"\047,\047"$9"\047,\047"$10"\047,\047 TEXTO LIBRE \047,\047t\047,\047 CAELTARIFA \047);"

}

END {
	#print NR,"Records Processed";
}
