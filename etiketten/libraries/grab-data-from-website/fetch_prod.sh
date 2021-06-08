#! /bin/sh

get_product_price () {
    cat $1 | grep -Eo '"price":"[0-9.]+"' $1 | cut -d'"' -f4 | head -n1
}

get_product_desc () {
    local fname
    fname=$1
    cat "$fname" | grep -Eo 'class=..*product_title[^>]*>[^<]+' | cut -d'>' -f2
}

get_prod () {
    local prod_id
    prod_id=$1

    tmpd=${tmpd:-.}
    local fname
    tmpfname=${tmpd:-.}/${prod_id}
    if ! curl -L --fail --silent -o "${tmpfname}" "https://webshop.quartier-depot.ch/produkt/$prod_id"
    then
        return 1
    else
        desc=$(get_product_desc "${tmpfname}")
        price=$(get_product_price "${tmpfname}")
        printf '%s: { price: { amount: "%s", currency: "CHF" }, description: "%s", origin: "", producer: "", labels: "" },\n' "$prod_id" "$price" "$desc"
    fi
}

tmpd=$(mktemp -d /tmp/fetch_prod.XXXXX) || exit 1

for prodnam in a b c d e f g h i j k l m n o p q r s t u v w x y z
do
    for ((i=10; i < 99; i++))
    do
        prod_id="${prodnam}${i}"
        get_prod "$prod_id"
        # echo "$prod_id"
    done
done

rm -rf ${tmpd}