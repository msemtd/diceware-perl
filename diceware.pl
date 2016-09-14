#! perl -w
use strict;
use FindBin;                # where was script installed?
use lib $FindBin::Bin;      # use that dir for libs, too
use tmstub;
# Hot file handle magic...
select((select(STDERR), $| = 1)[0]);
select((select(STDOUT), $| = 1)[0]);

my $path = "diceware.wordlist.asc.txt";
#~ system "wc $path";

#--------------------------------------
# example scan through word list...
if(0)
{
    open(FH, "< $path")
        or die "Couldn't open $path for reading: $!\n";

    my $c = 0;
    while (<FH>) {
        next unless /^(\d\d\d\d\d)\t(.*)$/;
        #~ chomp;
        $c++;
    }
    close FH;
    t "diceware list count = $c";
}
#-------------------------------------
# collect a bunch of words...
my $words = 4;

my @dwn;
# generate 6 diceword numbers...
for(my $w = 0; $w < $words; $w++){
    my $n = '';
    $n .= (int(rand(6))+1) for(1..5);
    push @dwn, $n;
}
#~ t d \@dwn;

#--------------------------------------
# lookup words...
my %dw;
@dw{@dwn} = ('') x @dwn;
{
    open(FH, "< $path")
        or die "Couldn't open $path for reading: $!\n";

    while (<FH>) {
        next unless /^(\d\d\d\d\d)\t(.*)$/;
        $dw{$1} = $2 if(defined $dw{$1});
    }
    close FH;
}
#~ t d \%dw;

t "passphrase = ". join("_", values(%dw));

