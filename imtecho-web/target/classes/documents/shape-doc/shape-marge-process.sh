for i in /home/subhash/slamba/work/imtecho/Shape-file/SAP_Updated_Data/Taluka/*.shp
do
	fname=`basename $i`
	fname="${fname%.*}"
	ogr2ogr -f GeoJSON $fname'.json' "${i}"
	sudo geo2topo *.json > all-districts.geojson
	echo $fname;
done