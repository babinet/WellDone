lightblue=`tput setaf 45`

source tmp/tmp_bash

echo "$green $imagegeotif $SingleName SingleName $WorkspaceName WorkspaceName"
geoserverworkspace="$WorkspaceName"
Year="$TheYear"
NameNoExt="$SingleNameNoExt"

gdal_translate -co "TFW=YES" ../_Output_Tagged_Geotif_3857/"$Lastrender" temp.tif
LastrenderNoExt=$(echo "$Lastrender"| sed 's/\.geotiff//g'| sed 's/\.tif//g')
convert -quiet temp.tif "$LastrenderNoExt".jpg


CSV_INFO=$(echo ""$NomHuman" - "$geoserverworkspace" - Size: "$Xsize" x "$Ysize" "$filesizeMO" PX - Mètre - EPSG:3857 .wld + .prj")
exiftool -m -keywords="$CSV_INFO" -artist="sous-paris.com" -Software="Kta2geo 1.1" "$LastrenderNoExt".jpg


mv temp.tfw "$LastrenderNoExt".wld
#proj
echo 'PROJCS["WGS_1984_Web_Mercator_Auxiliary_Sphere",GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]],PROJECTION["Mercator_Auxiliary_Sphere"],PARAMETER["False_Easting",0.0],PARAMETER["False_Northing",0.0],PARAMETER["Central_Meridian",0.0],PARAMETER["Standard_Parallel_1",0.0],PARAMETER["Auxiliary_Sphere_Type",0.0],UNIT["Meter",1.0]]' > "$LastrenderNoExt".prj


filesizeMO=$(ls -lah "$LastrenderNoExt".jpg  |awk '{print $5}')


echo ""$NomHuman" - "$geoserverworkspace" - Size: "$Xsize" x "$Ysize" "$filesizeMO" PX - Mètre - EPSG:3857 .wld + .prj" > "$LastrenderNoExt"_info.txt




zip "$SingleNameNoExt".zip "$LastrenderNoExt".jpg "$LastrenderNoExt".wld "$LastrenderNoExt".prj "$LastrenderNoExt"_info.txt
if [ -f ../_Output_wld_zip/"$LastrenderNoExt".zip ]
then
mv ../_Output_wld_zip/"$LastrenderNoExt".zip ../_TRASH_TEMP/"$FileDate"_"$LastrenderNoExt".zip
fi
mv "$LastrenderNoExt".zip ../_Output_wld_zip/
rm "$LastrenderNoExt".jpg "$LastrenderNoExt".wld "$LastrenderNoExt".prj "$LastrenderNoExt"_info.txt
if [ -f "$LastrenderNoExt".jpg_original ]
then
rm "$LastrenderNoExt".jpg_original
fi

