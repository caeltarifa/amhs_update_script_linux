import time

DATE=time.strftime("%d%m%Y")
addr="/root/scripting/dataflp/planesvueloline"+DATE
f=open(addr,"r")

newf=open("/root/scripting/dataflp/updateFPL.sql","w")

linea=f.readline()

while(True):
	linea=f.readline()
	if linea != "":
		#print(">>",linea)
		vector=linea.split("@CAELT@")
		if len(vector)>=9:
			sql="insert into plan_vuelo_flp_trafico (id_mensaje,aftn1,aftn2,id_aeronave,reglas_vuelo,aeropuerto_salida,ruta,aeropuerto_destino,otros,aprobado)"
			sql=sql+" values ('"+vector[0].replace(" ","") +"/"+ DATE + "','" + vector[1] + "','" +vector[2] + "','" + vector[3] + "','" + vector[4] + "','" + vector[5] + "','" + vector[6] + "','" + vector[7] + "','" + vector[8].replace("\n","") + "','f');"
			newf.write(sql+"\n")
	if not (linea):
		break

f.close()
newf.close()

#print(vector,sql)
