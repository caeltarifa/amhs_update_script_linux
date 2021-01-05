import time

DATE=time.strftime("%d%m%Y")
#print(DATE)
addr="/root/scripting/datanotam/notamline"+DATE

f=open(addr,"r")

newf=open("/root/scripting/datanotam/updateNOTAM.sql","w") #ARCHIVO DE SALIDA

linea=f.readline()

while(True):

	linea=f.readline()
	if linea != "":
		#print(">>",linea)
		vector=linea.split("@CAELT@") # IDMENSAJE - AFTN1 - AFTN2 - NOTAM - MENSAJE -
#							 id_mensaje,aftn1,aftn2,idnotam,resumen,aplica_a,valido_desde,valido_hasta,mensaje,nuevo
		vector_mensaje=vector[3].split(';;')
		sql="insert into plan_vuelo_notam_trafico (id_mensaje,aftn1,aftn2,idnotam,resumen,aplica_a,valido_desde,valido_hasta,mensaje,nuevo,ingresado)"

		if (len(vector_mensaje)>2):
				if (len(vector_mensaje)>=3 and len(vector_mensaje)<5 ):
					vector_descomp = vector_mensaje
					vector_descomp.pop()

					id_notam = vector_descomp[0]
					mensaje='\n'.join(vector_descomp[1:])
					sql=sql+" values ('"+vector[0].replace(" ","") +"/"+ DATE + "','" + vector[1] + "','" +vector[2] + "','" + id_notam + "','" + "" + "','" + "" + "','" + "" + "','" + "" + "','" + mensaje +"\n','t',current_timestamp);"
				else:
					vector.pop()
					vector += vector_mensaje
					vector.pop()

					vector[5]=vector[5] if 'A) ' in vector[5] else vector[5].replace('A)', 'A) ')
					vector[5]=vector[5] if 'B) ' in vector[5] else vector[5].replace('B)', 'B) ')
					vector[5]=vector[5] if 'C) ' in vector[5] else vector[5].replace('C)', 'C) ')
					
					vector_ABC=vector[5].strip().split(" ")
					A ='A) '+ vector_ABC[1]+"\n"
					#A=A.strip()
					B ='B) '+ vector_ABC[3]+"\n"
					#B=B.strip()
					C ='C) '+ ' '.join( vector_ABC[5:] ).strip()+"\n"
					#C=C.strip()
					sql=sql+" values ('"+vector[0].replace(" ","") +"/"+ DATE + "','" + vector[1] + "','" +vector[2] + "','" + vector[3] + "','" + vector[4] + "','" + A + "','" + B + "','" + C + "','" + vector[6] +"\n','t',current_timestamp);"
		else:
                        sql=sql+" values ('"+vector[0].replace(" ","") +"/"+ DATE + "','" + vector[1] + "','" +vector[2] + "','" + vector[3] + "','" + ' '.join(vector_mensaje[0].split(';;')) + "','" + "" + "','" + "" + "','" + "" + "','" + "" +"','t',current_timestamp);"

		newf.write(sql+"\n")
	if not (linea):
		break

f.close()
newf.close()

#print(vector,sql)
