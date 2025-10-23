#!/usr/bin/env perl
# vim: set foldmethod=marker foldmarker={{{,}}} :
### preamble {{{
use v5.16; use warnings; use utf8;
use open qw[ :encoding(UTF-8) :std ];

sub slurp(_) { local $/; open my $f, '<', $_[0]; return scalar <$f> }

# for hashing static files to cache-bust them on change
use Digest::file qw[ digest_file_base64 ];
sub hash(_) { digest_file_base64(shift, 'SHA-1') =~ tr[+/][-_]r }

### }}}

### header {{{
use constant HEADER => <<'END_OF_TEXT'=~ s,\n\Z,,r;  # to use say with almost everything
<!doctype html>
<html dir="rtl" lang="ar">
<head>
  <meta charset="utf-8">
  <title>{{title}}</title>
  <link rel="stylesheet" type="text/css" href="{{resources}}style.min.css?h={{stylehash}}">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta property="og:locale" content="ar_AR">
  <meta property="og:type" content="website">
  <meta property="og:title" content="{{title}}">
  <meta property="og:image" content="{{url}}cover.png">
  <meta property="og:image:width" content="1120"/>
  <meta property="og:image:height" content="630"/>
  <meta property="og:description" content="{{description}}">
  <meta name="description" content="{{description}}">
  <link rel="canonical" href="{{url}}">
  <meta property="og:url" content="{{url}}">
  <link rel="icon" type="image/png" sizes="72x72" href="{{resources}}favicon-72x72.png">
  <link rel="icon" type="image/png" sizes="16x16" href="{{resources}}favicon-16x16.png">
  <link rel="icon" type="image/svg+xml" sizes="any" href="{{resources}}favicon.svg">
  <!-- icon is U+1F386 from Twemoji (https://twemoji.twitter.com/) CC-BY 4.0 -->
  # <style>
  # {{stylesheet}}
  # </style>
</head>
<body>
<header>
  <p class="title">{{header_title}}</p>
</header>
<input id="f" type="search" dir="ltr" lang="en" placeholder="{{filter}}" aria-label="{{filter}}">
END_OF_TEXT

sub make_header { my ($additional_title, $path, $base) = @_;
  $path //= '';
  my $desc = 'للمصطلحات والعبارات التقنية';
  my $title = "مسرد السوامي";
  my $resources = 'res/';
  my $url = 'https://www.noureddin.dev/suami/';
  my $header_title = "$title {{logo}} $desc"
    =~ s|\Q{{logo}}\E|<span class="logo"><span>\N{FIREWORKS}</span></span>|r;
    # this hack (with the associated css) is to use the img on css-enabled browsers,
    # but to use the unicode character in reader mode and browsers w/o css.

  my $description = "مسرد مجتمعي نتخير فيه أفضل مصطلح عربي فصيح سليم يجمع بين المعنى التقني والاستعمال الأصلي للكلمة العربية أو صحة اشتقاقها، ونشير فيه إلى أسباب اختيار هذا المصطلح والإعراض عن غيره.";  # almost the same description as Ysmu

  return HEADER
    =~ s,^ *#.*$,,mgr =~ s,\n\n+,\n,gr
    =~ s,\Q{{description}}\E,$description,gr
    =~ s,\Q{{title}}\E,$title $desc,gr
    =~ s,\Q{{header_title}}\E,$header_title,gr
    =~ s,\Q{{url}}\E,$url,gr
    =~ s,\Q{{resources}}\E,$resources,gr
    =~ s,\Q{{stylehash}}\E,hash('res/style.min.css'),gre
    =~ s,\Q{{filter}}\E,اكتب لتصفية المصطلحات,gr
    # =~ s,^( *)\Q{{stylesheet}}\E\n,slurp('res/style.min.css'),mgre
    # =~ s,^( *)\Q{{stylesheet}}\E\n,
    #   my $indent = $1;
    #   slurp('res/.style.css')
    #     =~ s/^.*vim: set .*\n//mr  # remove the modeline
    #     =~ s/ *\{\{\{1 */ /gr  # remove folding markers
    #     # =~ s| */\*(?!\*).*?\*/||sgr  # remove comments (except double-astrisk comments)
    #     # =~ s/^ *\n//mgr  # remove empty lines
    #     =~ s/^\s+//gr
    #     =~ s/\s+$/\n/gr
    #     =~ s/^(?=\h*\S)/$indent/mgr
    #   ,mgre
    # # ensure proper text direction for the page's title
    # =~ s,(?<=<title>),\N{RIGHT-TO-LEFT EMBEDDING},r
    # =~ s,(?=</title>),\N{POP DIRECTIONAL FORMATTING},r
}

### }}}

### footer {{{

use constant FOOTER => <<'END_OF_TEXT' =~ s,\n\Z,,r;  # to use say with almost everything
<p class="empty blurred" style="display:none">ما من مصطلحات توافق تصفيتك</p>
<footer>
  <p>يمكنك التواصل معنا عبر
    صفحة <a rel="noreferrer noopener" href="https://github.com/noureddin/suami/issues/">مسائل جت‌هب</a><br>
    أو غرفة الترجمة في مجتمع أسس على شبكة ماتركس: <a rel="noreferrer noopener" lang="en" dir="ltr" href="https://matrix.to/#/#localization:aosus.org">#localization:aosus.org</a>
  </p>
  # <p class="blurred">الترجمة المختصرة بصيغة TSV للتطبيقات والمعاجم: <a rel=alternate type=text/tab-separated-values lang="en" dir="ltr" href="suami.tsv">suami.tsv</a> (انظر <a href="FORMAT.ar.md">شرح الصيغة</a>)</p>
  <p class="license blurred">الرخصة: <a rel="noreferrer noopener license" lang="en" href="https://creativecommons.org/publicdomain/zero/1.0/deed.ar">Creative Commons Zero (CC0)</a> (مكافئة للملكية العامة)</p>
  <p class="license blurred">الشارة من <a rel="noreferrer noopener" href="https://twemoji.twitter.com/">Twemoji</a> (بترخيص CC-BY 4.0)</p>
</footer>
<script>
  var emptyresult = document.getElementsByClassName('empty')[0]
  function normalize_text (t) {
    return (t
      .toLowerCase()
      .replace(/[\u0640\u064B-\u065F]+/g, '')
      .replace(/[-_\\\s,،.;؛?؟!()\[\]{}]+/g, ' ')
      .replace(/^ +| +$/g, '')
      )
  }
  function filter_terms (q) {
    var nq = normalize_text(q)
    var tt = document.querySelectorAll('body > div[id]')
    var empty = true
    for (var i = 0; i < tt.length; ++i) {
      var t = tt[i]
      if (normalize_text(t.textContent).indexOf(nq) === -1) {
        t.style.display = 'none'
      }
      else {
        t.style.display = 'block'
        empty = false
      }
    }
    emptyresult.style.display = empty ? 'block' : 'none'
  }
  onload = function () {
    var f = document.getElementById('f')
    f.oninput = function () { filter_terms(this.value) }
    if (f.value) { filter_terms(f.value) }
  }
</script>
</body>
</html>
END_OF_TEXT

sub make_footer {
  return FOOTER
    =~ s,^ *#.*$,,mgr =~ s,\n\n+,\n,gr
}

### }}}

### formating {{{

sub to_id(_) { return lc $_[0] =~ s/ /_/gr }
sub enfmt(_) {  # formating English terms: hyphenation etc
  return $_[0]
    =~ s/-(?=$|\P{Letter})/\N{EN DASH}/gr  # for prefixes
    # =~ s/(authen)(ticat)/$1&shy;$2/gr
    # =~ s/(crypto)(currency)/$1&shy;$2/gr
}

sub arfmt(_) {  # formating Arabic translations
  return $_[0]
    =~ s/  /<br>/gr
    =~ s/\Q(ج: \E/(ج:\N{NBSP}/gr
    # =~ s/\{\{(.*)\}\} +/\N{ORNATE RIGHT PARENTHESIS}$1\N{ORNATE LEFT PARENTHESIS}<br>/gr
    =~ s/\{\{(.*)\}\} +/\N{LEFT DOUBLE PARENTHESIS}$1\N{RIGHT DOUBLE PARENTHESIS}<br>/gr
    # =~ s/\{\{(.*)\}\} +/[$1]<br>/gr
}

my %titles;  # used in the related terms

{ open my $tfile, '<', 'suami.tsv';
  while (<$tfile>) {
    my @en = split /; /, (split /\t/)[0];
    if (@en == 1) {
      $titles{$en[0]} = undef;  # just record its existence, for related-terms checking
    }
    elsif (@en == 2) {
      $titles{$en[0]} = $titles{$en[1]} =
        "$en[0] ($en[1])";
    }
    else {
      warn "I don't know what to do what an entry with more than two English terms:\n  ",
        (join '; ', @en), "\n";
      my $mybestshot = $en[0] . ' (' . (join '; ', @en[1..$#en]) . ')';
      $titles{$_} = $mybestshot for @en;
    }
  }
}

sub refmt(_) {  # formating words for related terms
  my $w = $_[0] =~ s/_/ /gr;
  $w = $titles{$w} // $w;
  return $w
    =~ s/-(?=$|\P{Letter})/\N{EN DASH}/gr  # for prefixes
}

use constant YsmuButtonFmt =>
    qq[<p><a class="y" href="../ysmu/#%s" aria-lable{} title{}><span>🌄</span></a></p>]
      =~ s/\Q{}\E/="انظر شرح المادة العربية في معجم يسمو"/gr;

### }}}

### output {{{

open my $hfile, '>', 'index.html';
print { $hfile } make_header, "\n";

open my $tfile, '<', 'suami.tsv';
while (<$tfile>) {
  chomp;
  my ($en, $ar, $re) = split /\t/;
  if (!defined $en || !defined $ar) { warn "Ignoring badly formatted line:\n  $_\n"; next }
  my @en = split '; ', $en;
  my @ar = split ' 'x3, $ar;
  my @re = split / /, $re // '';
  my $ysmu = @re && $re[0] eq '@';
  shift @re if $ysmu;
  for my $r (@re) { $r =~ s/_/ /g; if (!exists $titles{$r}) { warn "Related term '$r' doesn't exist; used in '$en[0]'.\n" } }
  for my $r (@re) { $r =~ s/_/ /g; my @m = grep /^$r$/, @en; if (@m) { warn "Related term '$r' links to the same term: '$m[0]'.\n" } }
  printf { $hfile } qq[<div id="%s">], to_id for @en;
  printf { $hfile } qq[\n];
  printf { $hfile } qq[  <div class="t" lang="en">];
    printf { $hfile } qq[<p><a href="#%s">%s</a></p>], to_id, enfmt for @en;  # the English terms
    printf { $hfile } qq[</div>\n];
  printf { $hfile } qq[  <div class="d" lang="ar">];
    printf { $hfile } qq[<p>%s</p>], arfmt for @ar;
    printf { $hfile } qq[</div>\n];
  printf { $hfile } qq[  <div class="r" lang="en">];
    printf { $hfile } YsmuButtonFmt, to_id $en[0] if $ysmu;
    printf { $hfile } "\n    " if $ysmu && @re;
    printf { $hfile } qq[<p><a href="#%s">%s</a></p>], to_id, refmt for @re;
    printf { $hfile } qq[</div>\n];
  printf { $hfile } qq[  <br class="c">\n];
  printf { $hfile } qq[</div>] for @en;
  printf { $hfile } qq[\n];
}

print { $hfile } make_footer;
close $hfile;
close $tfile;

### }}}
