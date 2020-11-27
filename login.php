
<?php

$message="";
$servername = "localhost";
$username = "root";  
$password = "password";  
$databasename = "mydatabase"; 
$conn = new mysqli($servername, $username, $password,$databasename);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

echo "Connected successfully";

$json = file_get_contents('php://input');
 
 $obj = json_decode($json,true);
 $email = $obj['email'];
 $password = $obj['password'];
 $loginQuery = "select * from app_users where email = '$email' and password = '$password' ";
 
 $check = mysqli_fetch_array(mysqli_query($conn,$loginQuery));
 
	if(isset($check)){
		
		 $onLoginSuccess = 'Logged in...redirecting..';
		 $SuccessMSG = json_encode($onLoginSuccess);
		 echo $SuccessMSG ; 
	 }
	 
	 else{
		$InvalidMSG = 'Invalid Username or Password' ;
		$InvalidMSGJSon = json_encode($InvalidMSG);
		 echo $InvalidMSGJSon ;
	 }
 

?>
