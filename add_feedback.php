<?php
include 'db_connect.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Invalid Request"]);
    exit;
}

$user_id = $_POST['user_id'] ?? '';
$comment = $_POST['comment'] ?? '';
$join_again = $_POST['join_again'] ?? 'Yes';

if (empty($user_id) || empty($comment)) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit;
}

$sql = "INSERT INTO feedback (user_id, comment, join_again)
        VALUES ('$user_id', '$comment', '$join_again')";

if (mysqli_query($conn, $sql)) {
    echo json_encode(["status" => "success", "message" => "Feedback submitted"]);
} else {
    echo json_encode(["status" => "error", "message" => mysqli_error($conn)]);
}
?>