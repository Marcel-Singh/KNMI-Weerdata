<!doctype html>
<html class="no-js" lang="">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="css/main.css">
</head>
<body>
<!--[if lt IE 8]>
<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
<![endif]-->

<!-- Add your site or application content here -->
<h1>KNMI Weerdata</h1>

<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>window.jQuery || document.write('<script src="js/jquery-3.2.1.min.js"><\/script>')</script>
<script src="js/main.js"></script>

<?php
$url = 'http://projects.knmi.nl/klimatologie/daggegevens/getdata_dag.cgi';
$data = array('byear' => '2017',
    'bmonth' => '6',
    'bday' => '1',
    'eyear' => '2017',
    'emonth' => '6',
    'eday' => '5',
    'variabele' => 'TG',
    '&variabele' => 'TN',
    '&variabele' => 'TNH',
    '&variabele' => 'TX',
    '&variabele' => 'TXH',
    '&variabele' => 'T10N',
    '&variabele' => 'T10NH',
    '&variabele' => 'RH',
    '&variabele' => 'RHX',
    '&variabele' => 'RHXH',
    'stations' => '210',
    'stations' => '330',
    'stations' => '344'
);

// use key 'http' even if you send the request to https://...
$options = array(
    'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data)
    )
);
$context  = stream_context_create($options);
$result = file_get_contents($url, false, $context);
if ($result === FALSE) {
    echo "Het is niet gelukt om de data op te halen!\n$data";
}

// Output van KNMI heeft eerst een deel comments.
// Om deze te filteren splitsen we de output op \n (new lines) zodat deze overgeslagen kan worden.
//$result = explode("\n", $result);
print_r($result);

//for ($i = 12; $i < sizeof($result) ;$i++ ) {
//    echo $result[$i]."<br>";
//}
?>

</body>
</html>
