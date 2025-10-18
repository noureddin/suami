#!/usr/bin/env perl
use v5.16; use warnings; use utf8;
use open qw[ :encoding(UTF-8) :std ];
use HSLuv qw[ hsluv2hex ];  # a personal implementation of https://www.hsluv.org/
# uploaded at: https://gist.github.com/noureddin/c57a262d890c8ed7e8bee86791952581

my (%L, %D);

sub invli(_) { my ($li) = @_;
  # return 100 - $li;
  return 100*(0.5**($li/100) * 2 - 1);
  # return 100 - (exp($li/100) - 1) / (exp(1) - 1) * 100;
}

# sub rec { my ($name, $h, $s, $l, $a) = @_;
#   $a //= 'FF';
#   $L{$name} = hsluv2hex($h, $s, $l).$a;
#   $D{$name} = hsluv2hex($h, $s, invli $l).$a;
# }

sub rec { my ($name, $h, $s, $lL, $lD) = @_;
  $lD //= invli $lL;
  $L{$name} = hsluv2hex($h, $s, $lL);
  $D{$name} = hsluv2hex($h, $s, $lD);
}

sub blk { my ($name, $h) = @_;
  $L{$name} = hsluv2hex($h, 30, 85).'80';
  $D{$name} = hsluv2hex($h,100, 25).'a0';
}

# sub blk { my ($name, $h, $l) = @_;
#   $l //= 50;  my $aL = '20'; my $aD = '60';  # $a* are alpha, in hex
#   $L{$name} = hsluv2hex($h, 100, $l).$aL;
#   $D{$name} = hsluv2hex($h, 100, invli $l).$aD;
# }

sub lnk { my ($name, $h, $l) = @_;
  $l //= 50;
  $L{$name} = hsluv2hex($h, 100, $l);
  $D{$name} = hsluv2hex($h,  80, $l);
}

# main colors
rec bg =>   0,  0, 98;
rec fg => 240, 50, 10;
rec lo =>   0,  0, 35;
rec ll =>   0,  0, 50;

# block colors
blk en => 200;  # blueish
blk ar => 120;  # green
blk re =>  40;  # reddish

# link colors
lnk al => 200, 50;
lnk ah => 120, 60;
lnk aa =>  40, 60;
# rec al => 200,  80, 50, 80;
# rec ah => 120, 100, 50, 80;
# rec aa =>  40, 100, 50, 80;

$L{fl} = '#fff';
$D{fl} = '#000';
$L{op} = '0.5';
$D{op} = '0.35';
$L{sh} = '#0004';
$D{sh} = '#000';

if (@ARGV) {  # svg
  printf '
    .B { fill:%s } .C { fill:%s } .D { fill:%s } .X { fill:%s }
    @media (prefers-color-scheme: dark) {
    .B { fill:%s } .C { fill:%s } .D { fill:%s } .X { fill:%s }
    }' =~ s/\s+//gr,

      # (map s/$/08/r, ($L{fg})x3), $L{bg},
      # (map s/$/18/r, ($D{fg})x3), $D{bg};

      # (map s/..$/08/r, $L{en}, $L{ar}, $L{re}), $L{bg},
      # (map s/..$/18/r, $D{en}, $D{ar}, $D{re}), $D{bg};

      # (map s/..$/18/r, $L{en}, $L{ar}, $L{re}), $L{bg},
      # (map s/..$/40/r, $D{en}, $D{ar}, $D{re}), $D{bg};

      (map { hsluv2hex($_, 100, $_ != 120 ? 80 : 60).'10' } 200, 120, 40), $L{bg},
      (map { hsluv2hex($_, 100, $_ == 120 ? 80 : 60).'10' } 200, 120, 40), $D{bg};
  exit;
}
# else: css

# light-mode colors
printf ":root {\n%s}\n",
  join "", map { "  --$_: $L{$_};\n" } sort keys %L;

# dark-mode colors
printf "\@media (prefers-color-scheme: dark) { :root {\n%s}}\n",
  join "", map { "  --$_: $D{$_};\n" } sort keys %D;

