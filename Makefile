C=deno run --quiet --allow-read --allow-env=HTTP_PROXY,http_proxy npm:clean-css-cli

index.html: .build.pl suami.tsv res/style.min.css
	perl .build.pl

res/style.min.css: res/.style.css
	$C "$<" > "$@"
