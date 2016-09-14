#! perl -w
use strict;
use FindBin;                # where was script installed?
use lib $FindBin::Bin;      # use that dir for libs, too
use tmstub;
use Carp;
# Hot file handle magic...
select((select(STDERR), $| = 1)[0]);
select((select(STDOUT), $| = 1)[0]);

my $path = "diceware.wordlist.asc.txt";
#~ system "wc $path";

# load entire diceware list or just scan it on demand?

my %dw = diceware_load($path);
t "there are ".scalar(keys(%dw))." dicewords";

t "here's 100 random ones...";

for(my $i = 0; $i < 100; $i++){
    my $w = diceware_random_word(\%dw);
    print "$w\t";
    print "\n" unless ($i+1) % 10;
}

t "here's 10 x 4 word passwords...";
foreach(1..10){
    my $pw = join("_", get_n_words(\%dw, 4));
    t "password = $pw";
}

sub get_n_words {
    my ($h, $n) = @_;
    my @ret;
    for(my $i = 0; $i < $n; $i++){
        push @ret, diceware_random_word($h);
    }
    return @ret;
}

#-----------------------------------------
# utils...
sub diceware_random_word {
    my $h = shift;
    croak "bad args" unless ref($h) eq "HASH";
    return $h->{diceware_random_num()};
}

sub diceware_random_num {
    # make 6 digit diceware number...
    my $n = ''; $n .= (int(rand(6))+1) for(1..5);
    return $n;
}

sub diceware_load {
    my $path = shift;
    die "bad path" unless -f $path;
    my %dw;
    open(FH, "< $path")
        or die "Couldn't open $path for reading: $!\n";

    while (<FH>) {
        next unless /^(\d\d\d\d\d)\t(.*)$/;
        $dw{$1} = $2;
    }
    close FH;
    return %dw;
}
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
#--------------------------------------
# example password generation...
if(0)
{
    #-------------------------------------
    # collect a bunch of words...
    my $words = 4;
    
    my @dwn;
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
}
