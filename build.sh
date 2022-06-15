#!/bin/bash

function generate ()
{
    hours=$1
    rm -rf tmp/*
    fdate=$(date -u "+%Y%m%d%H%M" --date="-$hours hours")
    for f in www.chmi.cz/files/portal/docs/meteo/rad/inca-cz/data/czrad-z_max3d/*.png; do
        if [[ $f =~ (.*)([0-9]{4}[0-9]{2}[0-9]{2}).([0-9]{4}).*.png ]] && (( ${BASH_REMATCH[2]}${BASH_REMATCH[3]} > "$fdate"));then
            convert -compose src-over -page 0,0 base_map.jpg -page 0,0 $f -flatten ./tmp/$(basename $f)
        fi
    done
    echo "$fdate"

    convert -dispose 2 -delay 10 -loop 0 ./tmp/*.png -background white animace_${hours}.gif
    convert animace_${hours}.gif -fuzz 20% -layers Optimize animace_${hours}_lq.gif
}

mkdir -p tmp
wget -m --no-parent https://www.chmi.cz/files/portal/docs/meteo/rad/inca-cz/data/czrad-z_max3d/
find www.chmi.cz/files/portal/docs/meteo/rad/inca-cz/data/czrad-z_max3d/ -name '*.png' -type f -mtime +7 -delete

generate 6
generate 24

cp *.gif /data/www-data/wfiles/.
