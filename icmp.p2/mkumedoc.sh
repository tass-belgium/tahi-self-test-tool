#!/bin/sh

FILES=`ls *.html`

for file in $FILES; do
if [ X"$file" = X"index.html" ] ; then
	continue
fi
echo "$file"
ed $file <<EOF
/NAME="SYNOPSIS"/;/\<HR\>/d
w
q
EOF
done

for file in $FILES; do
if [ X"$file" = X"index.html" ] ; then
	continue
fi
echo "$file"
ed $file <<EOF
/NAME="SEE_ALSO"/;/\<\/PRE\>/d
?\<HR\>? d
?\<P\>? d
w
q
EOF
done

