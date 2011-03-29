#!/bin/sh

SAMBA=/mnt/web
DATE=`date +'%F, %H:%M:%S'`

echo $DATE
cd $SAMBA
touch $SAMBA/.log

echo "* Saving old index ($SAMBA/.download.idx.old)"
cat $SAMBA/.download.idx > $SAMBA/.download.idx.old
echo "* Updating new index ($SAMBA/.download.idx)"
find -L Movies Serien ebooks > $SAMBA/.download.idx

echo "* Saving changes ($SAMBA/.log.new)"
( diff --unified=0 $SAMBA/.download.idx.old $SAMBA/.download.idx | grep -E "^^\+"| grep -Ev "\-\-\-|\+\+\+" ) > $SAMBA/.log.new
cd $PWD

echo "* Updating main log file ($SAMBA/.log aka $SAMBA/log/Download/CHANGES.txt)"

cat $SAMBA/.README.txt.tmpl > $SAMBA/.log.tmp

echo -en "\n<h4>Verbindungen</h4>" >> $SAMBA/.log.tmp
smbstatus -S 2>/dev/null 1>> $SAMBA/.log.tmp

echo -en "<h4>Festplatte</h4>\n" >> $SAMBA/.log.tmp
df -h /mnt/usbdrive >> $SAMBA/.log.tmp

echo -en "\n<h4>Aktuelle Filme/Serien</h4>\n" >> $SAMBA/.log.tmp

if grep "^+" $SAMBA/.log.new 2> /dev/null; then
	echo -en "\n<h5>$DATE</h5>\n" >> $SAMBA/.log.tmp;
	cat $SAMBA/.log.new|sort|sed -e 's/^+\(.*\)/<a class="file" href="\1">\1<\/a>/' >> $SAMBA/.log.tmp

	echo -en "\n<h5>$DATE</h5>\n" > $SAMBA/.log.old
	cat $SAMBA/.log.new|sort|sed -e 's/^+\(.*\)/<a class="file" href="\1">\1<\/a>/' >> $SAMBA/.log.old
fi

cat $SAMBA/.log >> $SAMBA/.log.tmp
echo "</pre>" >> $SAMBA/.log.tmp
mv $SAMBA/.log.tmp $SAMBA/README.txt

cat $SAMBA/.log >> $SAMBA/.log.old

rm -f $SAMBA/.log.tmp
rm -f $SAMBA/.log.new
mv $SAMBA/.log.old $SAMBA/.log

#echo "* Converting to DOS file (CRLF)"
#todos $SAMBA/log

echo
