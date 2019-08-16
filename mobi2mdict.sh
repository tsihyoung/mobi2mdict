#!/bin/bash

echo "formatting HTML source..."

#insert linebreak before each entry
gsed -i 's/<idx:entry scriptable/\n&/g' $1 &&

#remove all empty span tags
gsed -i 's/<span>//g' $1 &&
gsed -i 's/<\/span>//g' $1 &&

#remove <hr/> <mbp:frameset> </mbp:frameset> <mbp:pagebreak/> </body> </html> tags
gsed -i 's/<hr\/>//g' $1 &&
gsed -i 's/<mbp:frameset>//g' $1 &&
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
echo "preprocess done."

echo "generating hyper-reference and inflection entries..."
#replace hyperlink and remove <a id> tags
#create individual entry for inflection
#move inflections to next line after main entry
./hyperlink.pl $1 

echo "All done."
