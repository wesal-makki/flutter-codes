<?php
header('Content-Type: application/json; charset=utf-8');
include 'db_connect.php';

$full_name  = $_POST['full_name'];
$user_email = $_POST['user_email'];
$password   = $_POST['password'];
$gender     = $_POST['gender'];
$birthdate  = $_POST['birthdate'];

if (!$full_name || !$user_email || !$password || !$gender || !$birthdate) {
    echo json_encode(["success" => false, "message" => "Please fill all fields"]);
    exit;
}

if (!filter_var($user_email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(["success" => false, "message" => "Invalid email format"]);
    exit;
}

if (strlen($password) < 8) {
    echo json_encode(["success" => false, "message" => "Password must be at least 8 characters"]);
    exit;
}

$full_name  = mysqli_real_escape_string($conn, $full_name);
$user_email = mysqli_real_escape_string($conn, $user_email);
$gender     = mysqli_real_escape_string($conn, $gender);
$birthdate  = mysqli_real_escape_string($conn, $birthdate);

$result = mysqli_query($conn, "SELECT user_id FROM users WHERE user_email = '$user_email'");
if (mysqli_num_rows($result) > 0) {
    echo json_encode(["success" => false, "message" => "Email already registered"]);
    exit;
}

$hashed_password = password_hash($password, PASSWORD_DEFAULT);

$insert = "INSERT INTO users (full_name, user_email, password, gender, birthdate, affected, donor, volunteer)
           VALUES ('$full_name', '$user_email', '$hashed_password', '$gender', '$birthdate', 0, 0, 0)";

if (mysqli_query($conn, $insert)) {
    echo json_encode(["success" => true, "message" => "User registered successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Database error: " . mysqli_error($conn)]);
}

mysqli_close($conn);
?>