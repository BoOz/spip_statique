#!/bin/bash
# ./spip_statique.sh http://localhost/mon_site/

# Exemples d'usage :
# spip_statique http://localhost/mon_site/ma_page.html
# spip_statique http://localhost/mon_site/
# spip_statique http://localhost/mon_site/ dans/un/repertoire

source="$1"
dest="${2:-}"

# check user input
if [ -z $source ]; then
    echo "usage: $0 URL <target directory optionnal>"
    exit
fi

# Eventuel repertoire cible en second parametre
if [[ $dest != "" ]] ; then
	echo "$source > $dest"
	if [ ! -d "$dest" ] 
		then
			echo "\nErreur : créer un répertoire \`$dest\`. mkdir -p $dest ; ls\n"
			ls
			echo ""
			exit
		else
			cd "$dest"
	fi
fi

# Fichier log pour les transformations des pages.
[ -f aspilog.txt ] && rm aspilog.txt

# ou sommes nous ?
# s'assurer qu'on a bien un / à la fin
source=$(echo "$source/" | sed -e 's`//$`/`g')
racine=$(echo ${source%/*} | sed -e 's,http://,,g' | sed -e 's,https://,,g' )
echo "$source > $racine"

# aspirer les pages
# http://www.thegeekstuff.com/2009/09/the-ultimate-wget-download-guide-with-15-awesome-examples
# 


command -v wget >/dev/null 2>&1 || { echo >&2 "\nErreur. Installer wget pour faire fonctionner spip_statique. brew install wget\n"; exit 1; }

wget -m -l5 --tries=5 -N -p -e robots=off --adjust-extension --no-check-certificate "$source"

# exit

# recaler les polices malencontreusement passées par --adjust-extension
for type in eot ttf woff woff2 ; do
	echo "$type.html > $type"
	find . -iname "*.$type.html" | while read f ; do
		vrai_nom=${f/$type.html/$type}
		echo "$f => $vrai_nom"
		mv "$f" "$vrai_nom"
	done
done

# recaler les css malencontreusement passées par --adjust-extension
for type in css ; do
	find . -type f -regex ".*?[0-9][0-9]*\.css$" | while read f ; do
		css_propre=$(echo $f | sed -e 's/[0-9][0-9]*\.css$//g' -e 's/?//g')
		echo "$f => $css_propre"
		mv "$f" "$css_propre"
	done
done

# nettoyer un peu
# virer les hash. jquery.colorbox.js?1494445576 -> jquery.colorbox.js
# local/cache-vignettes/L400xH282/ChampsExtras2-3ce9f.png?1484461418 
find . -type f -regex ".*?[0-9][0-9]*$" | while read f ; do
	fichier_propre=$(echo $f | sed -e 's/[0-9][0-9]*$//g' -e 's/?//g')
	mv "$f" "$fichier_propre"
	emplacement_actuel=$(echo ${f/$racine\//} | sed -e 's:\./::g')
	nouvel_emplacement=$(echo ${fichier_propre/$racine\//} | sed -e 's:\./::g')
	echo "$emplacement_actuel	$nouvel_emplacement" >> aspilog.txt
done

# renommer fichiers spip.php?page=XXX -> XXX.html
find . -iname "spip.php?page=*" | while read f ; do
	dirname=${f%/*}
	basename=${f##*/}
	fichier=$(echo $dirname/$basename | sed -e 's/spip.php?page=//g' )
	mv "$f" "$fichier"
	# emplacement actuel et nouvel emplacement
	#(( ${#fichier} > 0 )) && echo "${basename/.html/}	${fichier/${dirname}\//}"
	(( ${#fichier} > 0 )) && echo "${basename/.html/}	${fichier/${dirname}\//}" >> aspilog.txt
done

# renommer fichiers index.html?XXX.html -> XXX.html
find . -iname "index.html?*" | while read f ; do
	dirname=${f%/*}
	basename=${f##*/}
	fichier=$(echo $f | sed -e 's/index.html?//g' -e 's/page=//g')
	mv "$f" "$fichier"
	# emplacement actuel et nouvel emplacement ?paged=
	(( ${#fichier} > 0 )) && echo "?${fichier/${dirname}\//}	${fichier/${dirname}\//}"
	#(( ${#fichier} > 0 )) && echo "?${fichier/${dirname}\//}	${fichier/${dirname}\//}" >> aspilog.txt
done

# renommer fichiers spip.php?XXX.html -> XXX.html
find . -iname "spip.php?*" | while read f ; do
	dirname=${f%/*}
	basename=${f##*/}
	fichier=$(echo $f | sed -e 's/spip.php?//g')
	mv "$f" "$fichier"
	# emplacement actuel et nouvel emplacement
	echo "${basename/.html/} ${fichier##*/}"
	
	(( ${#fichier} > 0 )) && echo "${basename/.html/}	${fichier##*/}"
	(( ${#fichier} > 0 )) && echo "${basename/.html/}	${fichier##*/}" >> aspilog.txt
done

# mode clean a passer en option

# ranger les images.
for type in jpg gif png ico; do
	echo "$type trouvés"
	find . -iname "*.$type" | while read f ; do
		basename=${f##*/}
		nouvel_emplacement="images/$basename"
		[ ! -d "$racine/images" ] && mkdir "$racine/images"
		mv "$f" "$racine/$nouvel_emplacement"
		emplacement_actuel=$(echo ${f/$racine\//} | sed -e 's:\./::g')
		#echo "$emplacement_actuel > $nouvel_emplacement"
		echo "$emplacement_actuel	$nouvel_emplacement" >> aspilog.txt
	done
done

# ranger les polices.
for type in eot ttf woff woff2 ; do
	echo "$type trouvés"
	find . -iname "*.$type" | while read f ; do
		basename=${f##*/}
		nouvel_emplacement="polices/$basename"
		[ ! -d "$racine/polices" ] && mkdir "$racine/polices"
		mv "$f" "$racine/$nouvel_emplacement"
		emplacement_actuel=$(echo ${f/$racine\//} | sed -e 's:\./::g')
		# echo "$emplacement_actuel > $nouvel_emplacement"
		echo "$emplacement_actuel	$nouvel_emplacement" >> aspilog.txt
	done
done

# ranger les css, js.
for type in css js ; do
	echo "$type trouvés"
	find . -iname "*.$type" | while read f ; do
		#echo $f
		basename=${f##*/}
		nouvel_emplacement="$type/$basename"
		[ ! -d "$racine/$type" ] && mkdir "$racine/$type"
		mv "$f" "$racine/$nouvel_emplacement"
		emplacement_actuel=$(echo ${f/$racine\//} | sed -e 's:\./::g')
		#echo "$emplacement_actuel > $nouvel_emplacement"
		echo "$emplacement_actuel	$nouvel_emplacement" >> aspilog.txt
		
		# chercher des images déplacées : 
		# url(../images/icones-partage.png)
		for t in jpg png gif; do
			grep -Eo "(\(|'|\")[a-zA-Z0-9.+_/?#&-]*\.$t[?#a-zA-Z0-9]*(\)|'|\")" "$racine/$nouvel_emplacement" | while read r ; do
				emplacement_actuel=$(echo $r | sed -e "s/'//g" -e 's/"//g' -e "s/(//g" -e "s/)//g")
				echo "$emplacement_actuel	../images/${emplacement_actuel##*/}" >> aspilog.txt
			done
		done
		# chercher des polices déplacées : 
		# url('../polices/walbaumgroteskbookbolditalic.eot')
		# voire url('../polices/walbaumgroteskbookitalic.eot?#iefix')
		for t in eot ttf woff woff2 ; do
			grep -Eo "(\(|'|\")[a-zA-Z0-9.+_/?#&-]*\.$t[?#a-zA-Z0-9]*(\)|'|\")" "$racine/$nouvel_emplacement" | while read r ; do
				emplacement_actuel=$(echo $r | sed -e "s/'//g" -e 's/"//g' -e "s/(//g" -e "s/)//g")
				echo "$emplacement_actuel	../polices/${emplacement_actuel##*/}"  >> aspilog.txt
			done
		done
		
		# chercher tout pour vérif en mode debug
		#for t in jpg png gif eot ttf woff woff2 ; do
		#	grep $t "$racine/$nouvel_emplacement" | while read r ; do
		#		echo $r
		#	done
		#done
		
	done
done

# trier (à l'envers a cause des timestamps) , unifier
cat aspilog.txt | sort -r | uniq > aspilog.tmp
mv aspilog.tmp aspilog.txt

# changer dans les fichiers ce qu'on a déplacé
cat aspilog.txt | while read f ; do
	
	match=$(echo "$f" | cut -d'	' -f1 )
	replace=$(echo "$f" | cut -d'	' -f2)
	echo "\n$match > $replace"
	
	# grep replace des urls
	grep -rl "$match" . | while read fich ; do
		[[ $fich == "./aspilog.txt" ]] && continue ;
		echo "$fich va etre modifié"
		cat "$fich" | sed -e "s:$match:$replace:g" > "$fich.tmp"
		mv "$fich.tmp" "$fich"
	done
done


# effacer les repertoires vides
find . -type f -iname '*DS_Store' -delete
find . -type d -empty -delete

echo "Copie terminée"
ls
echo ""
exit
