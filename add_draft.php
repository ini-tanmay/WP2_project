<?php
 header("Access-Control-Allow-Origin: *");// to enable CORS for flutter web support

$client = new MongoDB\Driver\Manager("mongodb://localhost:27017");
$insert_data= new MongoDB\Driver\BulkWrite;
$json = file_get_contents('php://input');
$obj = json_decode($json,true);
$text = $obj['text'];
$title = $obj['title'];
$timeStamp = $obj['timeStamp'];

//insert new user
$document=array(
   "text"=>$name,
   "timeStamp"=>$email,
   "password"=>$password
);
$insert_data->insert($document);
$insertResult=$client->executeBulkWrite('wp.drafts',$insert_data);	

?>
