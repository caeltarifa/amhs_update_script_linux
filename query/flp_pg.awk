BEGIN {

RS="\n";FS=" "

}

{

print "\047insert into plan_vuelo_flp_trafico (id_amhs, hora_llegada, prioridad, id_plan, transponder, origen, texto)  values (\047" $1"\047,""\047"$2"\047,""\047"$3"\047,""\047"$7"\047,""\047"$8"\047,""\047" $9"\047 )\047"

}

END {
	print NR,"Records Processed";
}
