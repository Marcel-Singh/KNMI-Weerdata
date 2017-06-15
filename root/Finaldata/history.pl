use strict;
use warnings;
use POSIX 'strftime';
use Time::Piece;
my $t = Time::Piece->new();

my $date = strftime '%Y%m%d', localtime;
my $DM = strftime '%m%d', localtime;
#my $year = strftime '%Y%', localtime;
my $ticker = 1970;
my $year = $t->year;

my $file;
open($file, '>', "history.txt");
print $file "";
close $file;

while ($ticker <= $year) {

print $ticker.$DM . "\n";
$ticker = $ticker + 1;
system ('start KNMI-get.pl datum=' . $ticker.$DM);
sleep 2;
}