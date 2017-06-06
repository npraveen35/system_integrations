#!/bin/bash 
ossname=`enet status|grep huaw3G.cm.main|awk -F. {'print $1'} | sed -e 's/\t//g'`
rm -rf `date '+%b-%m-%d'`-$ossname-Healthchk.log ./*SAR*
echo "					*******************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "					Health Check Logs for `enet status|grep huaw3G.cm.main|awk -F. {'print $1'}` ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log 
echo "					********************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "******************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "Disk Utilization on APP Server" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo 'Size  Used Avail Use% Partition' >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
df -kh|grep -w '/\|/home'|tail -2|sed -r -e "s/[\t\ ]+/ /g" >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "App Node Memory usage in GB" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
#echo $[`cat /proc/meminfo|grep MemTotal|awk {'print $2'}`/1024/1024] >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
#free -g |head -2  >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
free -g -o |awk {'print $1"\t" $2"\t" $3"\t" $4'} |sed 's:total:     total:g'|sed 's:shared::g'>> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "Number of CPU for APP Node" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo $[`cat /proc/cpuinfo |grep processor|tail -1|awk {'print $3'}`+1]  >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "******************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "******************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "Disk Utilization on DB Server" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo 'Size  Used Avail Use% Partition' >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
dbip=`enetcfg export -mp /config/global/db|grep host|awk -F'"' {'print $4'}`
dbpassword=`enetcfg export -mp /config/global/db|grep password|awk -F'"' {'print $4'}`
ssh -q $dbip "df -kh|grep -w '/\|/home'|tail -2" |sed -r -e "s/[\t\ ]+/ /g">> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo 'DB Node Memory usage in GB' >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
ssh -q $dbip 'free -g -o'|awk {'print $1"\t" $2"\t" $3"\t" $4'}|sed 's:total:     total:g'|sed 's:shared::g' >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo 'Number of CPU for DB Node' >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo $[`ssh -q $dbip 'cat /proc/cpuinfo |grep processor|tail -1'|awk {'print $3'}`+1] >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "******************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "					">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "					">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "**********************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "cmip		-----> `enetcfg export -mp /region/"$ossname"/cm/interface -b|grep -i commIp|awk -F'"' {'print $4'}`" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
ping -c 1 `enetcfg export -mp /region/"$ossname"/cm/interface -b|grep -i commIp|awk -F'"' {'print $4'}` > .ping
if (( $? == "0" ))
then
echo "SON Able to reach the CM IP ">> `date '+%b-%m-%d'`-$ossname-Healthchk.log
else
echo "SON Unable to Reach the CM IP" >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
fi
echo "**********************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "					">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "**********************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "pmip		-----> `enetcfg export -mp /region/"$ossname"/pm/interface -b|grep -i Ip|awk -F'"' {'print $4'}`" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
ping -c 1 `enetcfg export -mp /region/"$ossname"/pm/interface -b|grep -i Ip|awk -F'"' {'print $4'}` >.ping
if (( $? == "0" ))
then
echo "SON able to Reach the PM IP ">> `date '+%b-%m-%d'`-$ossname-Healthchk.log
else
echo "SON Unable to Reach the PM IP" >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
fi

echo "**********************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "					">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "					">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "*************************************************************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "Eden Net is unable to connect the PM server in below timings on `date '+%b-%m-%d'`" >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
grep 'Could not Connect To Server' /home/vson/log/enet/`enet status|grep huaw3G.cm.main|awk -F. {'print $1'}`.pm.pmcollectionApp.log|grep `date '+%Y-%m-%d'`|tail -10 >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "*************************************************************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "************************************************************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "Below are the CM object fetching timings" >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
 mysql --user=root --password=$dbpassword --host=$dbip -e 'select * from ems_cache.cm_cache_schedule' >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "Note:  If anyting Null on Updated time means, Eden Net is unable to fecth that object from Netact. If its showing all are Null in Updated time then check the CM IP Password." >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "*****************************************************************************************************************************************************************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "Failed Module log file names on in last 24 Hours" >> `date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "************************************************">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
ls -lrth `find /home/vson/logs/*/* -type f -mtime -1 -size +0`|grep fail>>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "*******************************************">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "                                  ">>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "******************************i******************************************************************************************************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "								Missing Azimuth Data				" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
echo "*************************************************************************************************************************************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
# mysql --user=root --password=$dbpassword --host=$dbip -e 'select label, azimuth ,technology, cgi ,idn ,cell_id ,site_id,dn from ems_cache.cell_details, ems_cache.'$ossname'_cells where ems_cache.'$ossname'_cells.uid = ems_cache.cell_details.uid and ems_cache.'$ossname'_cells.is_external=0 and ems_cache.cell_details.azimuth is null;' >>`date '+%b-%m-%d'`-$ossname-Healthchk.log 
 mysql --user=root --password=$dbpassword --host=$dbip -e 'select oc.label, cd.technology, loc.latitude, loc.longitude, cd.azimuth, cd.cgi, cd.idn, cd.cell_id, oc.dn from ems_cache.cell_details cd, ems_cache.'$ossname'_cells oc, ems_cache.location loc where oc.uid = cd.uid and oc.is_external = 0 and cd.location_id = loc.location_id and (loc.latitude is null or loc.longitude is null or cd.azimuth is null) order by cd.technology, oc.label;' >>`date '+%b-%m-%d'`-$ossname-Healthchk.log 

echo "**************************************************************************************************************************************************" >>`date '+%b-%m-%d'`-$ossname-Healthchk.log
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="today" '+%d'` >`date --date="today" '+%b-%m-%d'`-$ossname-SAR
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="yesterday" '+%d'` >`date --date="yesterday" '+%b-%m-%d'`-$ossname-SAR
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="2 day ago" '+%d'` >`date --date="2 day ago" '+%b-%m-%d'`-$ossname-SAR
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="3 day ago" '+%d'` >`date --date="3 day ago" '+%b-%m-%d'`-$ossname-SAR
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="4 day ago" '+%d'` >`date --date="4 day ago" '+%b-%m-%d'`-$ossname-SAR
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="5 day ago" '+%d'` >`date --date="5 day ago" '+%b-%m-%d'`-$ossname-SAR
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="6 day ago" '+%d'` >`date --date="6 day ago" '+%b-%m-%d'`-$ossname-SAR
LC_ALL=C sar -A -f /var/log/sa/sa`date --date="7 day ago" '+%d'` >`date --date="7 day ago" '+%b-%m-%d'`-$ossname-SAR
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="today" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="today" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="yesterday" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="yesterday" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="2 day ago" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="2 day ago" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="3 day ago" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="3 day ago" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="4 day ago" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="4 day ago" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="5 day ago" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="5 day ago" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="6 day ago" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="6 day ago" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
java -jar kSar-5.0.6/kSar.jar -showCPUstacked -showMEMstacked -cpuFixedAxis -showIntrListstacked -input `date --date="7 day ago" '+%b-%m-%d'`-$ossname-SAR -outputPDF `date --date="7 day ago" '+%b-%m-%d'`-$ossname-SAR-Graph.pdf
clear
echo " Health Check report is generated and Report name is `date '+%b-%m-%d'`-$ossname-Healthchk.log"
