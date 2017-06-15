use strict;
use warnings;
use POSIX 'strftime';

use Time::Piece;

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;

my $server_endpoint = "http://projects.knmi.nl/klimatologie/daggegevens/getdata_dag.cgi";
 
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_endpoint);
 
 my $STATIONS = "334:330";
 my $OPTIES = "TG";

 my $date = strftime '%Y%m%d', localtime;
 my $DM = strftime '%m%d', localtime;

 #TG = Gemiddelde TEMP
 #TN = Min TEMP
 #TX = Max TEMP

# add POST data to HTTP request body
my $post_data = "stns=$STATIONS&vars=$OPTIES&end=$date";
$req->content($post_data);
 
my $resp = $ua->request($req);

if ($resp->is_success) {
 my $message = $resp->decoded_content;

 #verwijder comments
 while ($message=~ m/^#.*\n/) {
$message=~ s/^#.*\n//g;
};

#white space, station en datum DELL#
 	while ($message=~ m/ /) {
$message=~ s/ //g;
$message=~ s/330,.........//g;
$message=~ s/344,.........//g;
};

my @loper= split /\n/, $message;

my $loper;
my $bestand;

foreach $loper (@loper) {
$loper = $loper * 0.1;
}

sub gemiddelde {
my @array = @_;
my $sum;
foreach (@array) { $sum += $_; }
return $sum/@array;
}

my $GemiddeldeTemp= gemiddelde(@loper);
open($bestand, '>', "vandaag.txt");
print $bestand $GemiddeldeTemp . "\n";
close $bestand;
 }
else {
    print "HTTP POST error code: ", $resp->code, "\n";
    print "HTTP POST error message: ", $resp->message, "\n";
}