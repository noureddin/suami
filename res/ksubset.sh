#!/bin/bash

input="KacstOne.ttf"
output="${input%.*}-subset"
range=20,21,28,29,3A,ab,bb,60c,61b,61f,621-63a,640-652,660-669,66a,2026
# all imlaai arabic letters including tatweel, the five ascii ():!., all tashkeel,
# arabic question mark and semicolon and comma and percentage sign, ٠ to ٩,
# ellipsis, letter peh, guillemets, and ascii space

pyftsubset "$input" --output-file="$output".woff2 --layout-features=* --flavor=woff2 --unicodes=$range
pyftsubset "$input" --output-file="$output".woff  --layout-features=* --flavor=woff  --unicodes=$range --with-zopfli

