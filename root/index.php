<?php
$url = "weerdata_verwerkt.txt";
$result = file_get_contents($url, false);
if ($result === FALSE) {
    echo "Het is niet gelukt om de data op te halen!\n$data";
}

$result = explode("\n", $result);

function printJSON($result){
    echo "[";
    for ($i = 0; $i < sizeof($result) ;$i++ ) {
        $tempres = explode(",", $result[$i]);

        for ($j = 0; $j < sizeof($tempres); $j++) {
            echo "{x:".$tempres[0].",y:".($tempres[1]/10)."},\n"; // { x: 10, y: 51 },
        }
    }
    echo "]";
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
</head>
<body>
<!--[if lt IE 8]>
<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
<![endif]-->

<!-- Add your site or application content here -->
<h1>KNMI Weerdata</h1>

<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script>window.jQuery || document.write('<script src="src/js/jquery-3.2.1.min.js"><\/script>')</script>
<script src="src/js/main.js"></script>



<style>
    img{
        pointer-events: none;
    }
</style>
<script type="text/javascript" src="src/js/canvasjs.min.js"></script>
<script type="text/javascript">
    window.onload = function () {
        var chart = new CanvasJS.Chart("chartContainer",
            {
                animationEnabled: true,
                theme: "theme2",
                title:{
                    text: "Multi Series Spline Chart - Hide / Unhide via Legend"
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
                        <?php printJSON($result); ?>
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
</script>

<div id="chartContainer" style="height: 300px; width: 100%; position: relative"></div>


</body>
</html>
