<?php
 header("Access-Control-Allow-Origin: *");// to enable CORS for flutter web support

$client = new MongoDB\Driver\Manager("mongodb://localhost:27017");
$insert_data= new MongoDB\Driver\BulkWrite;
$json = file_get_contents('php://input');
$obj = json_decode($json,true);
$text = $obj['text'];
$title = $obj['title'];
$timeStamp = $obj['timeStamp'];
$uid = $obj['userID'];

//insert new draft
$document=array(
   "text"=>$text,
   "userID"=>$uid,
   "timeStamp"=>$timeStamp,
   "title"=>$title
);
$insert_data->insert($document);
$insertResult=$client->executeBulkWrite('wp.drafts',$insert_data);	
?>
