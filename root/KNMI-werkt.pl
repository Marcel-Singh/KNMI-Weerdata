use strict;
use warnings;
use POSIX 'strftime';
use CGI qw(:standard); ##query

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;

#######Query#######
my $query = new CGI;
my $datum = $query->param('datum');

my $server_endpoint = "http://projects.knmi.nl/klimatologie/daggegevens/getdata_dag.cgi";
 
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_endpoint);
 
 my $STATIONS = "330:344";
 my $OPTIES = "TG";

 my $date = strftime '%Y%m%d', localtime;
 my $DM = strftime '%m%d', localtime;

 my $FYEAR = "1980"; #1-1-1971
 my $FMONTH = "02";
 my $FDAY   = "22";

 my $TYEAR = "1980";
 my $TMONTH = "02";
 my $TDAY   = "22";


 my $VAN = $FYEAR . $FMONTH . $FDAY;
 my $TOT = $TYEAR . $TMONTH . $TDAY;


 #TG = Gemiddelde TEMP
 #TN = Min TEMP
 #TX = Max TEMP

# add POST data to HTTP request body
my $post_data = "stns=$STATIONS&vars=$OPTIES&start=$datum&end=$datum";
$req->content($post_data);
 
my $resp = $ua->request($req);

if ($resp->is_success) {

    my $message = $resp->decoded_content;

    #verwijder comments
 	while ($message=~ m/^#.*\n/) {
        $message=~ s/^#.*\n//g;
    };

#preppen
 	while ($message=~ m/ /) {
<<<<<<< HEAD
$message=~ s/ //g;
$message=~ s/330,.........//g;
$message=~ s/344,.........//g;
};

   my @lines= split /\n/, $message;
=======
        $message=~ s/ //g;
        $message=~ s/330,//g;
        $message=~ s/344,//g;
    };

	print $message;

    my @temp= split /,/, $message;
>>>>>>> 77f3167dff62738e562529fb693731a002756e3f

my $aap;
my $file;
foreach $aap (@lines) {
$aap = $aap * 0.1;

<<<<<<< HEAD
}
=======
    open(my $file, '>', 'weerdata.txt');
    print $file $message;
    close $file;
>>>>>>> 77f3167dff62738e562529fb693731a002756e3f

sub average {
my @array = @_; # save the array passed to this function
my $sum; # create a variable to hold the sum of the array's values
foreach (@array) { $sum += $_; } # add each element of the array 
# to the sum
return $sum/@array; # divide sum by the number of elements in the
# array to find the mean
}

my $GemiddeldeTemp = average(@lines);
#print $avgOfArray;
# here the average will be 5

open($file, '>>', "weerdata.txt");
print $file $datum . "," .$GemiddeldeTemp . "\n";
close $file;

 }
else {
    print "HTTP POST error code: ", $resp->code, "\n";
    print "HTTP POST error message: ", $resp->message, "\n";
    #print $resp;
}