#!/bin/bash
parse() {
curl -s http://www.sipbroker.com/sipbroker/action/providerWhitePages?pageNumber=$1 | awk ' { for(i=1;i<=NF;i++) print $i } ' | sed -n -e '/TrafGreen/{N;N;N;p}' | sed -e 's/src=\"\/graphics\/TrafGreen.gif\"\/>\&nbsp;//g;s/<\/td>//g;s/<td//g;s/align=\"left\"//g;/./!d' | while read line
do
read line2
d=$(echo $line | sed -e 's/[^0-9]//g' | grep -o . | wc -l) 
echo "exten => _$line.,1,Dial(SIP/\${EXTEN:$d}@$line2)" 
done  
}
for count in `seq 1 11`;
do
parse $count
done | sed -e '/EXTEN:0/d'
