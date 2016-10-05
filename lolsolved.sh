# Usage: getrekt.sh file flag_marker
# Example: getrekt.sh for101 'flag{'

if [ -z "$2" ]
   then
   echo 'Usage: lolsolved.sh file flag_marker'
   exit 2
fi

featherduster='~/tools/featherduster/featherduster.py'

files="$1"
# resolve files so we don't have to worry about it beginning with '-'
[ -z "${files%%/*}" ] || files="$PWD/$files"
FLAG="$2"
FLAG_REVERSE="$(printf "%s" "$FLAG" | rev)"

echo 'Magic CTF challenge solver GO!'
echo ''

# Do general solves
# strings | grep
find "$files" | while read file; do
   strings "$file" | grep -e "$FLAG" && echo 'GETREKT: strings | grep flag' && exit 0
   strings "$file" | grep -e "$FLAG_REVERSE" && echo 'GETREKT: strings | grep flag_in_reverse' && exit 0
   binwalk -e -M "$file" >/dev/null;
   grep -r -i -e "$FLAG" *.extracted/ && echo 'GETREKT: binwalk -e -M ; grep -r flag' && exit 0
   grep -r -i -e "$FLAG_REVERSE" *.extracted/ && echo 'GETREKT: binwalk -e -M ; grep -r flag_in_reverse' && exit 0

   # Do crypto solves
   # FeatherDuster autopwn
   python $featherduster "$file" <<EOF | grep -e "$FLAG" && echo 'GETREKT: featherduster autodecode' && exit 0
analyze
samples
EOF

   # FeatherDuster autodecode
   echo 'autopwn' | python "$featherduster" "$file" | grep -e "$FLAG" && echo 'GETREKT: featherduster autopwn' && exit 0
   

   # Do reversing solves
   rabin2 -zz "$file" | grep -i -e "$FLAG" && exit 0

   # Do stego solves
   python solvers/imagestegosolve.py "$file" | grep -e "$FLAG" && exit 0

done

echo 'Rats. Couldn\'t solve it. Check the extracted files just in case a flag fell out...'
