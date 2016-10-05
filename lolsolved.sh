# Usage: getrekt.sh file flag_marker
# Example: getrekt.sh for101 'flag{'

if [ -z "$2" ]
   then
   echo 'Usage: lolsolved.sh file flag_marker'
   exit 2
fi

featherduster='~/tools/featherduster/featherduster.py'

FLAG="$2"
FLAG_REVERSE=`echo $FLAG | rev`

echo 'Magic CTF challenge solver GO!'
echo ''

# Do general solves
# strings | grep
find "$1" | while read file; do
   strings "$file" | grep "$FLAG" && echo 'GETREKT: strings | grep flag' && exit 0
   strings "$file" | grep "$FLAG_REVERSE" && echo 'GETREKT: strings | grep flag_in_reverse' && exit 0
   binwalk -e "$file" >/dev/null;
   grep -r -i "$FLAG" *.extracted/ && echo 'GETREKT: binwalk -e -M ; grep -r flag' && exit 0
   grep -r -i "$FLAG_REVERSE" *.extracted/ && echo 'GETREKT: binwalk -e -M ; grep -r flag_in_reverse' && exit 0

   # Do crypto solves
   # FeatherDuster autopwn
   python $featherduster "$file" <<EOF | grep "$FLAG" && echo 'GETREKT: featherduster autodecode' && exit 0
analyze
samples
EOF

   # FeatherDuster autodecode
   echo 'autopwn' | python "$featherduster" "$file" | grep "$FLAG" && echo 'GETREKT: featherduster autopwn' && exit 0
   

   # Do reversing solves
   rabin2 -zz "$file" | grep -i "$FLAG" && exit 0

   # Do stego solves
   #TODO Do stego solves

done
