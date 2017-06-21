<?php
$url = "weerdata_week.txt";
$result = file_get_contents($url, false);
if ($result === FALSE) {
    echo "Het is niet gelukt om de data op te halen!\n$data";
}

$result = explode("\n", $result);

$minimum = 100;
$maximum = -100;

$vandaagurl = "vandaag.txt";
$vandaag = file_get_contents($vandaagurl, false);
if ($vandaag === FALSE) {
    echo "Het is niet gelukt om de data van vandaag op te halen!\n$vandaag";
}

$currentTemp = $vandaag;

function printJSON($result){
    global $minimum, $maximum;
    for ($i = 0; $i < sizeof($result) - 1; $i++) {
        $tempres = explode(",", $result[$i]);
        $dat = $tempres[0];
        $min = round(($tempres[1]*0.1), 1);
        $max = round(($tempres[2]*0.1), 1);

        $minimum = ($min < $minimum) ? $min : $minimum;
        $maximum = ($max > $maximum) ? $max : $maximum;

        $date = new DateTime($dat);
        echo "{label: \"".$date->format('l')."\", y: [".$min.",".$max."]},\n";
    }
}

function getMinMax(){
    global $minimum, $maximum;
    $offset = 5;
    echo "minimum: ".($minimum - $offset).",\n";
    echo "maximum: ".($maximum + $offset).",\n";
}
?>

<!doctype html>
<html class="no-js" lang="">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="src/css/main.css">
    <link rel="stylesheet" href="src/css/custom.css">
</head>
<body>
<!--[if lt IE 8]>
<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade
    your browser</a> to improve your experience.</p>
<![endif]-->

<!-- Add your site or application content here -->

<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>window.jQuery || document.write('<script src="src/js/jquery-3.2.1.min.js"><\/script>')</script>
<script src="src/js/main.js"></script>


<style>
    img {
        pointer-events: none;
    }
</style>
<script type="text/javascript" src="src/js/canvasjs.min.js"></script>
<script type="text/javascript">

    window.onload = function () {
        var chart = new CanvasJS.Chart("chartContainer", {
            title: {
                text: "Averages of past 48 years.",
                fontColor: "white",
                fontWeight: "normal"
            },
            backgroundColor: "transparent",
            toolTip: {
                shared: true,
                content: "<strong>Temperature: </strong> </br> Min: {y[0]}°C, Max: {y[1]}°C"
            },
            data: [
                {
                    type: "rangeSplineArea",
                    fillOpacity: 0,
                    color: "white",
                    indexLabelFontColor: "white",
                    indexLabelFormatter: formatter,
                    dataPoints: [

                        <?php printJSON($result); ?>
//                        {label: "Monday", y: [15, 26]},
//                        {label: "Tuesday", y: [15, 27]},
//                        {label: "Wednesday", y: [13, 27]},
//                        {label: "Thursday", y: [14, 27]},
//                        {label: "Friday", y: [15, 26]},
//                        {label: "Saturday", y: [17, 26]},
//                        {label: "Sunday", y: [16, 27]},
                    ]
                }],
            axisX: {
                labelFontColor: "white",
                lineColor: "white"
            },
            axisY: {
                includeZero: false,
                suffix: "°C",
                <?php getMinMax(); ?>
                gridThickness: 0,
                labelFontColor: "white",
                lineColor: "white"
            }
        });
        chart.render();

        function formatter(e) {
            if (e.index === 0 && e.dataPoint.x === 0) {
                return " Low " + e.dataPoint.y[e.index];
            }
            if (e.index == 1 && e.dataPoint.x === 0) {
                return " High " + e.dataPoint.y[e.index];
            }
            else {
                return e.dataPoint.y[e.index];
            }
        }
    };


    /* IN GEVAL DAT MIN EN MAX TEMPERATUREN NIET WERKT
     window.onload = function () {
     var chart = new CanvasJS.Chart("chartContainer",
     {
     animationEnabled: true,
     theme: "theme2",
     title:{
     text: "Multi Series Spline Chart - Hide / Unhide via Legend"
     },
     axisX: {
     valueFormatString: "DD MMM YY",
     },
     axisY:[{
     lineColor: "#4F81BC",
     tickColor: "#4F81BC",
     labelFontColor: "#4F81BC",
     titleFontColor: "#4F81BC",
     lineThickness: 2,
     },
     {
     lineColor: "#C0504E",
     tickColor: "#C0504E",
     labelFontColor: "#C0504E",
     titleFontColor: "#C0504E",
     lineThickness: 2,

     }],
     data: [
     {
     type: "spline", //change type to bar, line, area, pie, etc
     showInLegend: true,
     dataPoints:
     //                            [
     //                            { x: 10, y: 51 },
     //                            { x: 20, y: 45},
     //                            { x: 30, y: 50 },
     //                            { x: 40, y: 62 },
     //                            { x: 50, y: 95 },
     //                            { x: 60, y: 66 },
     //                            { x: 70, y: 24 },
     //                            { x: 80, y: 32 },
     //                            { x: 90, y: 16}
     //                        ]
     },
     {
     type: "spline",
     axisYIndex: 1,
     showInLegend: true,
     dataPoints: [
     //                            { x: 10, y: 201 },
     //                            { x: 20, y: 404},
     //                            { x: 30, y: 305 },
     //                            { x: 40, y: 405 },
     //                            { x: 50, y: 905 },
     //                            { x: 60, y: 508 },
     //                            { x: 70, y: 108 },
     //                            { x: 80, y: 300 },
     //                            { x: 90, y: 101}
     ]
     }
     ],
     legend: {
     cursor: "pointer",
     itemclick: function (e) {
     if (typeof(e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
     e.dataSeries.visible = false;
     } else {
     e.dataSeries.visible = true;
     }
     chart.render();
     }
     }
     });

     chart.render();
     }
     */
</script>
<div id="titel">
    <h1>What to wear today?</h1>
</div>
<header>
    <div id="temperature">
        <h3>Current temperature:</h3>
        <h1><?php print $currentTemp."ºC"; ?></h1>
    </div>
    <div id="cloths">
        <h3>Our advice:</h3>
        <div id="advice">
            <div id="top">
                <?php
                if($currentTemp >= 17){
                    print '<img src="src/img/tshirt.png">';
                }
                if($currentTemp < 17){
                    print '<img src="src/img/hoodie.png">';
                }
                ?>
            </div>
            <div id="bottom">
                <?php
                if($currentTemp >= 20){
                    print '<img src="src/img/shorts.png">';
                }
                if($currentTemp < 20){
                    print '<img src="src/img/trousers.png">';
                }
                ?>
            </div>
        </div>
    </div>
</header>
<article>
    <div id="chartContainer"></div>
</article>
</body>
</html>
