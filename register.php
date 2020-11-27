<?php
 
$message="";
$servername = "localhost";
$username = "root";  
$password = "password";  
$databasename = "mydatabase"; 
$conn = new mysqli($servername, $username, $password,$databasename);
$json = file_get_contents('php://input');
$obj = json_decode($json,true);
$name = $obj['name'];
$email = $obj['email'];
$password = $obj['password'];
$CheckSQL = "SELECT * FROM user_registration WHERE email='$email'";


$check = mysqli_fetch_array(mysqli_query($conn,$CheckSQL));
if (!$check) {
    echo("Error: %s\n "+ mysqli_error($conn));
    exit();
}

if(isset($check)){

	 $emailExist = 'Email Already Exist, Please Try Again With New Email Address..!';
	$existEmailJSON = json_encode($emailExist);
	 echo $existEmailJSON ; 

  }
 else{
	 $Sql_Query = "insert into user_registration (name,email,password) values ('$name','$email','$password')";
	 if(mysqli_query($conn,$Sql_Query)){
		$MSG = 'User Registered Successfully' ;
		$json = json_encode($MSG);
		 echo $json ;
	 
	 }
	 else{
		echo 'Try Again';
	 }
 }
 mysqli_close($conn);
?>