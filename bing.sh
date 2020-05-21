page="https://bing.ioliu.cn/?p="
min=1
max=3
rm *.tmp
if [ $# -gt 0 ];
	then
	min=$1
	max=$2

fi

for num in $(seq $min $max)
do
	if [ -f "Page"$num".html" ]; # 判断是否有重复下载
		then 
		echo "###############################Page"$num".html"
		continue
		fi
	pagename="Page$num.html"
	wget -O $pagename $page$num
	filename=`cat $pagename | sed -e 's/</\n/g' | awk '/h3>/{printf("%s\n",$0);}' | sed -e 's/h3>//g' -e 's/([^()]*)//g' -e 's/\///g' -e 's/ /+/g'`
	date=`cat $pagename | sed 's/\([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\)/\n\1 /g' | awk '/^[0-9][0-9][0-9][0-9]-/{printf("%s\n",$1);}'`
	urls=`cat $pagename | sed 's/</\n</g' | awk '/img/{printf("%s\n",$5);}' | sed -e 's/src="//g' -e 's/">//g'`

	sleep 2
	date2=($date)
	filename2=($filename)
	urls2=($urls)

	for i in $(seq 1 12) # 获取当前网页下的所有图片 
		do 
			name=${date2[i]}${filename2[i]}".tmp"
			wget -O $name ${urls2[i]}
			mv $name "`echo $name | sed -e 's/+/ /g' | sed -e 's/ .tmp/.jpg/g' -e 's/.tmp/.jpg/g' -e 's/["]//g'`"
		done
		sleep 2
		done
rm *.html
rm *.tmp
