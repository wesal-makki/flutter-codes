<?php
include "db_connect.php";

header('Content-Type: application/json');

$user_id = $_POST['user_id'];

$sql = "SELECT full_name, email, gender, birthdate FROM users WHERE user_id='$user_id'";
$result = mysqli_query($conn,$sql);

echo json_encode(mysqli_fetch_assoc($result));

mysqli_close($conn);
?>