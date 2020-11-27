<?php
 header("Access-Control-Allow-Origin: *");// to enable CORS for flutter web support

$client = new MongoDB\Driver\Manager("mongodb://localhost:27017");
$insert_data= new MongoDB\Driver\BulkWrite;
$json = file_get_contents('php://input');
$obj = json_decode($json,true);
$name = $obj['name'];
$email = $obj['email'];
$password = $obj['password'];

//check if user already exists
$filter =  ['email' => $email,'password'=>$password];
$query1 = new MongoDB\Driver\Query($filter, []);
$rows   = $client->executeQuery('wp.users', $query1);
$counter=0;
foreach ($rows as $doc) {
    $counter++;
    }
if($counter!=0){
echo json_encode(FALSE);
exit();
}

//insert new user
$document=array(
   "name"=>$name,
   "email"=>$email,
   "password"=>$password
);

$insert_data->insert($document);
$insertResult=$client->executeBulkWrite('wp.users',$insert_data);	
echo json_encode(TRUE);



?>
