use strict;
use warnings;
use POSIX 'strftime';


use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
 
my $server_endpoint = "http://projects.knmi.nl/klimatologie/daggegevens/getdata_dag.cgi";
 
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_endpoint);
 
 my $STATIONS = "330:344";
 my $OPTIES = "TG:TN:TX";
 my $date = strftime '%Y%m%d', localtime;
 my $VAN = 20161111;
 my $TOT = $date -1;

 #TG = Gemiddelde TEMP
 #TN = Min TEMP
 #TX = Max TEMP

# add POST data to HTTP request body
my $post_data = "stns=$STATIONS&vars=$OPTIES&start=$VAN&end=$TOT";
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
        $message=~ s/ //g;
        $message=~ s/330,//g;
        $message=~ s/344,//g;
    };

	print $message;

    my @temp= split /,/, $message;


    open(my $file, '>', 'weerdata.txt');
    print $file $message;
    close $file;

#print $message->content;
}
else {
    print "HTTP POST error code: ", $resp->code, "\n";
    print "HTTP POST error message: ", $resp->message, "\n";
    #print $resp;
}