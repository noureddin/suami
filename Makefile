C=deno run --quiet --allow-read --allow-env=HTTP_PROXY,http_proxy npm:clean-css-cli

index.html: .build.pl ysmu.tsv res/style.min.css res/pat.svg
	perl .build.pl

res/pat.svg: res/.pat.svg ._colors-svg.css
	perl -CDAS -Mutf8 -pe 's|\{\}|local $$/; open FH, "<", "._colors-svg.css"; join "\n", <FH>|me' "$<" > "$@"

res/style.min.css: res/style.css
	$C "$<" > "$@"

res/style.css: res/.style.css ._colors.css
	perl -CDAS -Mutf8 -pe 's|^\Q/***COLORS***/\E\n|local $$/; open FH, "<", "._colors.css"; join "\n", <FH>|me' "$<" > "$@"

._colors-svg.css: .colors.pl
	perl "$<" - > "$@"

._colors.css: .colors.pl
	perl "$<" > "$@"

# Colors are defined in .colors.pl as CSS variables, then used in res/.style.css
