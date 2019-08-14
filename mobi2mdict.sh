#!/bin/bash
#insert linebreak before each entry
gsed -i 's/<idx:entry scriptable/\n&/g' $1 &&

#remove all empty span tags
gsed -i 's/<span>//g' $1 &&
gsed -i 's/<\/span>//g' $1 &&

#remove <hr/> </mbp:frameset> <mbp:pagebreak/> </body> </html> tags
gsed -i 's/<hr\/>//g' $1 &&
gsed -i 's/<\/mbp:frameset>//g' $1 &&
gsed -i 's/<mbp:pagebreak\/>//g' $1 &&
gsed -i 's/<\/body>//g' $1 &&
gsed -i 's/<\/html>//g' $1 &&

#insert </> between entries
gsed -i '/idx:entry>/ a <\/>' $1 &&

#remove entry tags
gsed -i 's/<idx:entry scriptable=\"yes\">//g' $1 &&
gsed -i 's/<\/idx:entry>//g' $1 &&

#insert linebreak after <idx:orth value="">
gsed -i 's/\">/\">\n/' $1 &&

#replace <idx:orth value="entry"> with entry
gsed -i 's/<idx:orth value=\"\(.*\)\">/\1/' $1 &&

#remove all </idx:orth>
gsed -i 's/<\/idx:orth>//g' $1 &&

#delete first two lines (copyright pages)
gsed -i '1,2d' $1 &&

#replace hyperlink and remove <a id> tags
#replace.sh file generated might be too large to run
./hyperlink.swift $1 > replace.sh && bash ./replace.sh && rm -f replace.sh &&

#create individual entry for inflection
./infl.pl $1 > infl.txt &&

#move inflection to next line after main entry
perl -pi -e 's/<idx:infl>(.*)<\/idx:infl>(.*?)<\/div>/\2<\/div><div>\1<\/div>/' $1 &&
perl -pi -e 's/<idx:iform name="" value="(.*?)"\/>/\1 /g' $1 &&

#create individual entry for inflection
cat infl.txt >> $1 && rm -f infl.txt
