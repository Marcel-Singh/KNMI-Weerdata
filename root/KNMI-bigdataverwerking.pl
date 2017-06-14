#!/usr/local/bin/perl

use strict;
use warnings;
use POSIX 'strftime';
use LWP::UserAgent;
use Data::Dumper qw(Dumper);

# 330 = Hoek van Holland
# 344 = Rotterdam
my $STATIONS = "330:344";

#TG = Gemiddelde TEMP
#TN = Min TEMP
#TX = Max TEMP
my $OPTIES = "TG:TN:TX";

#my $DATE = strftime '%Y%m%d', localtime();
my $year    = strftime '%Y', localtime();
my $month   = strftime '%m', localtime();
my $day     = strftime '%d', localtime();
my $DATE    = $year.$month.$day;
print "Today is: $DATE\n";

my $van = 0;
my $tot = 0;
my $aantalDagen = 7;

my @maandagMIN      = ();
my @dinsdagMIN      = ();
my @woensdagMIN     = ();
my @donderdagMIN    = ();
my @vrijdagMIN      = ();
my @zaterdagMIN     = ();
my @zondagMIN       = ();
my @maandagMAX      = ();
my @dinsdagMAX      = ();
my @woensdagMAX     = ();
my @donderdagMAX    = ();
my @vrijdagMAX      = ();
my @zaterdagMAX     = ();
my @zondagMAX       = ();

my @maandag = ();
my @dinsdag = ();
my @woensdag = ();
my @donderdag = ();
my @vrijdag = ();
my @zaterdag = ();
my @zondag = ();


my $message = "";
my $min = 0;
my $max = 0;

for(my $i = $year; $i > 1971; $i--){
    #my $DATE = strftime '%Y%m%d', localtime();
    #print localtime();

    $DATE = $i.$month.$day;
    $van = $DATE - $aantalDagen;
    $tot = $DATE;

    #print "Processing data between $van - $tot..\n";

    $message = getData();

    #print $message;

    #my $message = 0;
    if(!($message eq 0)) {
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

        while ($message=~ m/\r\n/) {
            $message=~ s/\r\n/;/g;
        }

        my @message = split /;/, $message;
        #print Dumper \@message;

        for(my $k = 0; $k <= scalar(@message)-$aantalDagen; $k+=$aantalDagen){
            for(my $j = $k; $j <= $k+($aantalDagen-1); $j++){
                my @temp = split /,/, $message[$j];
                my $dat = $temp[0];
                my $gem = $temp[1];
                my $min = $temp[2];
                my $max = $temp[3];

                if($j-$k == 0 && !($min eq "" || $max eq ""))  {push @maandagMIN, $min;    push @maandagMAX, $max;}
                if($j-$k == 1 && !($min eq "" || $max eq ""))  {push @dinsdagMIN, $min;    push @dinsdagMAX, $max;}
                if($j-$k == 2 && !($min eq "" || $max eq ""))  {push @woensdagMIN, $min;   push @woensdagMAX, $max;}
                if($j-$k == 3 && !($min eq "" || $max eq ""))  {push @donderdagMIN, $min;  push @donderdagMAX, $max;}
                if($j-$k == 4 && !($min eq "" || $max eq ""))  {push @vrijdagMIN, $min;    push @vrijdagMAX, $max;}
                if($j-$k == 5 && !($min eq "" || $max eq ""))  {push @zaterdagMIN, $min;   push @zaterdagMAX, $max;}
                if($j-$k == 6 && !($min eq "" || $max eq ""))  {push @zondagMIN, $min;     push @zondagMAX, $max;}

                if(!($dat eq "" || $gem eq "" || $min eq "" || $max eq "")){
                    print "$dat: $gem, $min, $max\n";
                }
            }
        }



        #print $message->content;
    }
    else{
        print "POST Request failed.\n";
    };



}

calculateAverages();
writeOut();












###############
# SUBROUTINES #
###############

sub writeOut{
    open(my $file, '>', 'weerdata_week.txt');

    my @message = split /;/, $message;
    my @ma = split /,/, $message[0];
    my @di = split /,/, $message[1];
    my @wo = split /,/, $message[2];
    my @do = split /,/, $message[3];
    my @vr = split /,/, $message[4];
    my @za = split /,/, $message[5];
    my @zo = split /,/, $message[6];

    print $file "$ma[0],$maandag[0],$maandag[1]\n";
    print $file "$di[0],$dinsdag[0],$dinsdag[1]\n";
    print $file "$wo[0],$woensdag[0],$woensdag[1]\n";
    print $file "$do[0],$donderdag[0],$donderdag[1]\n";
    print $file "$vr[0],$vrijdag[0],$vrijdag[1]\n";
    print $file "$za[0],$zaterdag[0],$zaterdag[1]\n";
    print $file "$zo[0],$zondag[0],$zondag[1]\n";

    close $file;
}

sub getData{
    my $server_endpoint = "http://projects.knmi.nl/klimatologie/daggegevens/getdata_dag.cgi";

    # set custom HTTP request header fields
    my $req = HTTP::Request->new(POST => $server_endpoint);

    # add POST data to HTTP request body
    my $post_data = "stns=$STATIONS&vars=$OPTIES&start=$van&end=$tot";
    my $ua = LWP::UserAgent->new;
    $req->content($post_data);

    my $resp = $ua->request($req);
    if ($resp->is_success) {
        print "Ophalen data van $van tot $tot.\n";
        #print "Ophalen data gelukt!";
        #print $resp->decoded_content;
        open(my $file, '>', "weerdata_KNMI_$van$tot.txt");
        print $file $resp->decoded_content;
        close $file;
        return $resp->decoded_content;
    }else {
        if($resp->code == 500){
            return getDataFromFile();
        }else{
            print "HTTP POST error code: ", $resp->code, "\n";
            print "HTTP POST error message: ", $resp->message, "\n";
            return 0;
        }
    }
}

sub getDataFromFile{
    my $file = "weerdata_KNMI_$van$tot.txt";
    my $output = "";

    open(my $message, '<', $file) or die "Cannot open $file: $!";
    print "Reading: $file\n";
    while (<$message>) {
        $output .= <$message>;
        chomp;
    }
    close $message;
    return $output;
}

sub calculateAverages{
# maandag
    my $temp = 0;
    for(my $i = 0; $i < scalar(@maandagMIN); $i++){
        $temp += $maandagMIN[$i];
    }
    $temp /= scalar(@maandagMIN);
    push @maandag, $temp;
    $temp = 0;

    for(my $i = 0; $i < scalar(@maandagMAX); $i++){
        $temp += $maandagMAX[$i];
    }
    $temp /= scalar(@maandagMAX);
    push @maandag, $temp;
    print "Temperatuur op maandag. min: $maandag[0], max: $maandag[1]\n";

# dinsdag
    $temp = 0;
    for(my $i = 0; $i < scalar(@dinsdagMIN); $i++){
        $temp += $dinsdagMIN[$i];
    }
    $temp /= scalar(@dinsdagMIN);
    push @dinsdag, $temp;
    $temp = 0;

    for(my $i = 0; $i < scalar(@dinsdagMAX); $i++){
        $temp += $dinsdagMAX[$i];
    }
    $temp /= scalar(@dinsdagMAX);
    push @dinsdag, $temp;
    print "Temperatuur op dinsdag. min: $dinsdag[0], max: $dinsdag[1]\n";

# woensdag
    $temp = 0;
    for(my $i = 0; $i < scalar(@woensdagMIN); $i++){
    $temp += $woensdagMIN[$i];
    }
    $temp /= scalar(@woensdagMIN);
    push @woensdag, $temp;
    $temp = 0;

    for(my $i = 0; $i < scalar(@woensdagMAX); $i++){
    $temp += $woensdagMAX[$i];
    }
    $temp /= scalar(@woensdagMAX);
    push @woensdag, $temp;
    print "Temperatuur op woensdag. min: $woensdag[0], max: $woensdag[1]\n";

# donderdag
    $temp = 0;
    for(my $i = 0; $i < scalar(@donderdagMIN); $i++){
    $temp += $donderdagMIN[$i];
    }
    $temp /= scalar(@donderdagMIN);
    push @donderdag, $temp;
    $temp = 0;

    for(my $i = 0; $i < scalar(@donderdagMAX); $i++){
    $temp += $donderdagMAX[$i];
    }
    $temp /= scalar(@donderdagMAX);
    push @donderdag, $temp;
    print "Temperatuur op donderdag. min: $donderdag[0], max: $donderdag[1]\n";

# vrijdag
    $temp = 0;
    for(my $i = 0; $i < scalar(@vrijdagMIN); $i++){
    $temp += $vrijdagMIN[$i];
    }
    $temp /= scalar(@vrijdagMIN);
    push @vrijdag, $temp;
    $temp = 0;

    for(my $i = 0; $i < scalar(@vrijdagMAX); $i++){
    $temp += $vrijdagMAX[$i];
    }
    $temp /= scalar(@vrijdagMAX);
    push @vrijdag, $temp;
    print "Temperatuur op vrijdag. min: $vrijdag[0], max: $vrijdag[1]\n";

# zaterdag
    $temp = 0;
    for(my $i = 0; $i < scalar(@zaterdagMIN); $i++){
    $temp += $zaterdagMIN[$i];
    }
    $temp /= scalar(@zaterdagMIN);
    push @zaterdag, $temp;
    $temp = 0;

    for(my $i = 0; $i < scalar(@zaterdagMAX); $i++){
    $temp += $zaterdagMAX[$i];
    }
    $temp /= scalar(@zaterdagMAX);
    push @zaterdag, $temp;
    print "Temperatuur op zaterdag. min: $zaterdag[0], max: $zaterdag[1]\n";

# zondag
    $temp = 0;
    for(my $i = 0; $i < scalar(@zondagMIN); $i++){
        $temp += $zondagMIN[$i];
    }
    $temp /= scalar(@zondagMIN);
    push @zondag, $temp;
    $temp = 0;

    for(my $i = 0; $i < scalar(@zondagMAX); $i++){
        $temp += $zondagMAX[$i];
    }
    $temp /= scalar(@zondagMAX);
    push @zondag, $temp;
    print "Temperatuur op zondag. min: $zondag[0], max: $zondag[1]\n";
}