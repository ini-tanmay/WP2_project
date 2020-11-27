<?php
 header("Access-Control-Allow-Origin: *");// to enable CORS for flutter web support

$client = new MongoDB\Driver\Manager("mongodb://localhost:27017");
$insert_data= new MongoDB\Driver\BulkWrite;
$json = file_get_contents('php://input');
$obj = json_decode($json,true);
$uid = $obj['userID'];


$filter =  ['userID' => $uid];
$query1 = new MongoDB\Driver\Query($filter, []);
$rows   = $client->executeQuery('wp.drafts', $query1);


$drafts=array();

foreach ($rows as $doc) {
        $drafts[] = $doc;  
    }

echo json_encode($drafts);

?>
