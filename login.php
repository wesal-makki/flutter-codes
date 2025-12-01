<?php
include 'db_connect.php';
header('Content-Type: application/json');

$email = $_POST['user_email'];
$password = $_POST['password'];

if (!$email || !$password) {
    echo json_encode(["success" => false, "message" => "Please fill all fields"]);
    exit;
}

$cmd = "SELECT * FROM users WHERE user_email = '$email'";
$result = mysqli_query($conn, $cmd);
$user = mysqli_fetch_assoc($result);

if ($user && password_verify($password, $user['password'])) {

    echo json_encode([
        "success" => true,
        "message" => "Login successful",
        "user_id" => $user["user_id"],
        "full_name" => $user["full_name"]
    ]);

} else {
    echo json_encode(["success" => false, "message" => "Incorrect email or password"]);
}

mysqli_close($conn);
?>