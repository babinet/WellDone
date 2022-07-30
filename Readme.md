
### WellDone 
#### Make .CSV from GeoTiff for Node Aide - Allow to know the ordered bounds for each layer from a EPSG:3857 

- Make WKT geometry POLYGON from image raster - Ordrer : Top left, Bottom Lest, Bottom Right, Top Right, Top left
- Generate HideNSeek.js
- Generate geotiff path
- Generate geotiff link
- Define Bound of the raster layer : 

```
WKT_Emprise=$(echo "GEOMETRYCOLLECTION(POLYGON("$UL", "$LL", "$LR", "$UR", "$UL"))")
```

-HidenseeK Code
```
echo "var "$NomMachine"_boundary = new OpenLayers.Bounds($LayerBound)
    if (mapbounds.intersectsBounds("$NomMachine"_boundary)) { \$('#plan_planche"$NomMachine"').show(); \$('#add_planche"$NomMachine"').show(); } else { \$('#plan_"$NomMachine"').hide(); \$('#plan_"$NomMachine"').hide(); } " >> tmp/HideNSeektmp
```
