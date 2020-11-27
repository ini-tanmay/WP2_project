
<?php

 header("Access-Control-Allow-Origin: *");// to enable CORS for flutter web support

$client = new MongoDB\Driver\Manager("mongodb://localhost:27017");

$json = file_get_contents('php://input');
$obj = json_decode($json,true);
$email = $obj['email'];
$password = $obj['password'];
$filter =  ['email' => $email,'password'=>$password];

$query1 = new MongoDB\Driver\Query($filter, []);
$rows   = $client->executeQuery('wp.users', $query1);

$counter=0;
foreach ($rows as $doc) {
    $counter++;
    }
if($counter==0)
echo json_encode(FALSE);
else 
echo json_encode(TRUE);


?>