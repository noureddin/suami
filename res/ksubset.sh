#!/bin/bash

input="KacstOne.ttf"
output="${input%.*}-subset"
range=20,21,28-29,2e,3A,5b,5d,ab,bb,60c,61b,61f,621-63a,640-652,660-669,2026
# all imlaai arabic letters including tatweel, the seven ascii []():!., all tashkeel,
# arabic question mark and semicolon and comma, ٠ to ٩,
# ellipsis, guillemets, and ascii space

echo U+${range//,/,U+}
pyftsubset "$input" --output-file="$output".woff2 --layout-features=* --flavor=woff2 --unicodes=$range
pyftsubset "$input" --output-file="$output".woff  --layout-features=* --flavor=woff  --unicodes=$range --with-zopfli

