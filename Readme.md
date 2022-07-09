
### WellDone 
#### Make .CSV from GeoTiff

Allow to know the ordered bounds for each layer from a EPSG:3857 

```
(left, bottom, right, top)
```

Generate HideNSeek.js

```
WKT_Emprise=$(echo "GEOMETRYCOLLECTION(POLYGON("$UL", "$LL", "$LR", "$UR", "$UL"))")
```

```
echo "var "$NomMachine"_boundary = new OpenLayers.Bounds($LayerBound)
    if (mapbounds.intersectsBounds("$NomMachine"_boundary)) { \$('#plan_planche"$NomMachine"').show(); \$('#add_planche"$NomMachine"').show(); } else { \$('#plan_"$NomMachine"').hide(); \$('#plan_"$NomMachine"').hide(); } " >> tmp/HideNSeektmp
```
