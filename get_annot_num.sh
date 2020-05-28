###Usage: sh get_annot_num.sh sample.name

while read line
do 
        wc -l "$line"_ath_matched.annot
done < $1
