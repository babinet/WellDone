#!/bin/bash
orange=`tput setaf 11`
bg_orange=`tput setab 178`
purple=`tput setaf 13`
Line=`tput smul`
bold=`tput bold`
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 15`
reset=`tput sgr0`
bg_red=`tput setab 1`
bg_green=`tput setab 2`
bg_white=`tput setab 7`
bg_blue=`tput setab 4`
lightblue=`tput setaf 45`
lightgreen=`tput setaf 46`
bleuetern=`tput setaf 45`
ilghtpurple=`tput setaf 33`
lightred=`tput setaf 161`
darkblue=`tput setaf 19`
grey=`tput setaf 248`
lightyellow=`tput setaf 229`
dir=$(
cd -P -- "$(dirname -- "$0")" && pwd -P
)
cd "$dir" 2>&1 &>/dev/null

echo "${white} ---> Greating the required directories."
mkdir -p tmp/csv_from_geotif ../_Output_wld_zip ../_Output_PNG_Preview ../_Output_Tagged_Geotif_3857 ../_Output_CSVs ../_NoGeoInfo ../_Source_GEOTIFF tmp/NewLayers/ ../_TRASH_TEMP/ ../_TOO_BIG_DONSIZED ../_Large_Images_2_rsync/ ../_Done_No_GeoRef_Normal_TIF


echo "${white} ---> Asking the workspace name in GeoServer."
read -p "${white} What is the name of the workspace in geoserver e.g ${orange}ED_Verniquet      :${green} " WorkspaceName
TheWorkspaceClassJsCss=$(echo "$WorkspaceName"|awk '{print tolower}')
 


echo "${white} ---> Checking if using the right path for ${orange}$WorkspaceName."
if [ -f tmp/StoragePath ]
then
StoragePath=$(cat tmp/StoragePath)
read -p "${white} ---> The current Storage Location is${orange}     : $StoragePath (y/n) ?          :" RESP
if [ "$RESP" = "y" ]; then
echo "${white}  ---> Using default Storage Location${orange}        : $StoragePath ${reset}"
else
echo "${white}---> The source files path must be as followed
eg. /my_folder/3857 /my_folder/pngpreview"
read -p "${white}What is the Storage Location of the maps eg. /my_folder/
Do not forget the tailing / ${green} : " StoragePath
echo "$StoragePath" > tmp/StoragePath
fi
else
read -p "${orange}What is the Storage Location of the maps eg. /my_folder/
Do not forget the tailing / ${green} :  " StoragePath
echo "$StoragePath" > tmp/StoragePath
fi
StoragePath=$(cat tmp/StoragePath)
echo "${white} ---> the storage path is ${orange}$StoragePath."


read -p "${white} ---> Drop you GeoTiff files in the Folder : ${orange}../_Source_GEOTIFF${green} " whatever
find ../_Source_GEOTIFF/ -name "*.tif" -o -name "*.geotiff"| sed 's/\/\//\//g' > tmp/csv_from_geotif/listtmp.txt
if [ -f tmp/_IMPORT_OTHER_MAPStmp ]
then
rm tmp/_IMPORT_OTHER_MAPStmp
fi

if [ -f tmp/NewLayers/TheCureentNodeBody.csv ]
then
rm tmp/NewLayers/TheCureentNodeBody.csv
fi

echo "// $WorkspaceName BEGIN" > tmp/HideNSeektmp
echo $purple $WorkspaceName
if [ -f tmp/OtherLayersTMP ]
then
rm tmp/OtherLayersTMP
fi


IFS=$'\n'       # Processing full line (ignoring spaces)
set -f          # disable globbing

for imagegeotif in $(cat tmp/csv_from_geotif/listtmp.txt)
do
FileDate=$(echo $(date +%Y_%m_%d_%Hh%Mm%Ss) | tr "/" "_")
#
#
echo "${white} ---> Dealing with imagegeotif                        ${orange}:$imagegeotif"
SingleName=$(echo $imagegeotif|sed 's/\.\.\///g'|tr ' ' '_'| sed 's/_Source_GEOTIFF\///g')
SingleNameNoExt=$(echo $imagegeotif|sed 's/\.\.\///g'|tr ' ' '_' |awk -F'.' '{print $1}'| sed 's/_Source_GEOTIFF\///g')
echo "${green} ---> Getting file info with gdalinfo "
gdalinfo "$imagegeotif" > tmp/csv_from_geotif/"$SingleName".txt

InfoText=$(echo "$imagegeotif"|sed 's/.geotiff/.txt/g'|sed 's/.tif/.txt/g')
echo "${white} ---> \$InfoText                                       ${orange}: $InfoText"
size=$(cat tmp/csv_from_geotif/"$SingleName".txt |awk '/Size is / {print $0}'| sed 's/Size is //g' | tr -d ' ')
echo "${white} ---> \$size                                           ${orange}: $size"

Xsize=$(echo "$size"| awk -F',' '{print $1}')
Ysize=$(echo "$size"| awk -F',' '{print $2}')
echo "${white} ---> \$Xsize ${orange}$Xsize ${white}\$Ysize ${orange}$Ysize"

UL=$(cat tmp/csv_from_geotif/"$SingleName".txt |awk '/Upper Left/'| awk -F'(' '{print $2}'| awk -F')' '{print $1}' | sed 's/ //g'|tr ',' ' ')
LL=$(cat tmp/csv_from_geotif/"$SingleName".txt |awk '/Lower Left/'| awk -F'(' '{print $2}'| awk -F')' '{print $1}' | sed 's/ //g'|tr ',' ' ')
LR=$(cat tmp/csv_from_geotif/"$SingleName".txt |awk '/Lower Right/'| awk -F'(' '{print $2}'| awk -F')' '{print $1}' | sed 's/ //g'|tr ',' ' ')
UR=$(cat tmp/csv_from_geotif/"$SingleName".txt |awk '/Upper Right/'| awk -F'(' '{print $2}'| awk -F')' '{print $1}' | sed 's/ //g'|tr ',' ' ')
Center=$(cat tmp/csv_from_geotif/"$SingleName".txt |awk '/Center/' | awk -F'(' '{print $2}'| awk -F')' '{print $1}' | sed 's/ //g'|tr ',' ' ')
echo "${white} ---> EPSG:3857=\$UL${orange} $UL ${white}- \$LL${orange} $LL ${white}- \$UL${orange} $LR ${white}- \$UR${orange} $UR ${white}- \$UL${orange} $UL"

echo "${red} ---> CENTER= \$Center${orange} $Center ${white}"


Projection=$(cat tmp/csv_from_geotif/"$SingleName".txt| tr -d '\n'| awk -F'PROJCRS' '{print "PROJCR"$2}'| awk -F']]],' '{print $1"\]\]\]"}')
echo "${white} ---> \$Projection                                           ${orange}: $Projection"

echo $purple ED_Verniquet $InfoText InfoText
echo "$whitehello alive until here $FileDate"

if [ -f "$InfoText" ]
then
echo "${white} ---> Info text $InfoText ${green}found !"
Base_text=$(cat "$InfoText" | awk 'NR == 2')
NomHuman=$(echo "$Base_text" |awk -F'|' '{print $1}'| tr '/' '•')
NomMachine=$(echo "$Base_text" |awk -F'|' '{print $2}')
LienSouces=$(echo "$Base_text" |awk -F'|' '{print $3}')
Commentaire=$(echo "$Base_text" |awk -F'|' '{print $4}')
author=$(echo "$Base_text" |awk -F'|' '{print $5}')
TheYear=$(echo "$Base_text" |awk -F'|' '{print $6}')
TitreHTML=$(echo "$Base_text" |awk -F'|' '{print $7}')

fi
##LayerNameComplete=$(echo "$NomHuman" - $TheYear $Xsize x $Ysize - $author)
#
echo "${orange}#######   Variables   #######${white}"
echo "${white} ---> \$LayerNameComplete                                   ${orange}: $LayerNameComplete"
echo "${white} ---> \$Base_text                                           ${orange}: $Base_text"
echo "${white} ---> \$NomHuman                                            ${orange}: $NomHuman"
echo "${white} ---> \$NomMachine                                          ${orange}: $NomMachine"
echo "${white} ---> \$author                                              ${orange}: $author"
echo "${white} ---> \$TheYear                                             ${orange}: $TheYear"
echo "${white} ---> \$LienSouces                                          ${orange}: $LienSouces"
echo "${white} ---> \$TitreHTML                                           ${orange}: $TitreHTML"

echo "${white} ---> \$Commentaire                                                  #
${lightblue}: $Commentaire"
done
