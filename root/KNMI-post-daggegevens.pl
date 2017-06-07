use strict;
use warnings;



use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
 
my $server_endpoint = "http://projects.knmi.nl/klimatologie/daggegevens/getdata_dag.cgi";
 
# set custom HTTP request header fields
my $req = HTTP::Request->new(POST => $server_endpoint);
 
# add POST data to HTTP request body
my $post_data = "stns=ALL";
$req->content($post_data);
 
my $resp = $ua->request($req);
if ($resp->is_success) {
	
    my $message = $resp->decoded_content;
    open(my $file, '>', 'weerdata.txt');
    print $file "$message";
    close $file;
    print "$message\n";

#print $resp->content;
}
else {
    print "HTTP POST error code: ", $resp->code, "\n";
    print "HTTP POST error message: ", $resp->message, "\n";
}