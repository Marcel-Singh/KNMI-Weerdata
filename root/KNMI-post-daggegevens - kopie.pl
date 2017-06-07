use strict;
use warnings;



use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
 
my $server_endpoint = "http://projects.knmi.nl/klimatologie/daggegevens/getdata_dag.cgi";
 
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_endpoint);
 
# add POST data to HTTP request body
my $post_data = "stns=330:344&vars=TG:RH:TNH&start=20170606&end=20170606";
$req->content($post_data);
 
my $resp = $ua->request($req);
if ($resp->is_success) {

     my $ymd = sub{sprintf '%04d%02d%02d', $_[5]+1900, $_[4]+1, $_[3]}->(localtime);

	
    my $message = $resp->decoded_content;
    my @temp= split /,/, $message;
    my $datum = $temp[5];
    print "$temp[4]\n";
    print "$temp[10]\n";

    open(my $file, '>', 'weerdata.txt');
    print $file "$temp[5]$temp[6]\n$temp[5]$temp[10]\n";
    close $file;

 
    

#print $resp->content;
}
else {
    print "HTTP POST error code: ", $resp->code, "\n";
    print "HTTP POST error message: ", $resp->message, "\n";
}