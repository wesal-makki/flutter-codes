<?php
include "db_connect.php";

$user_id = $_POST['user_id'];

$sql = "SELECT case_id, title, status, reject_reason FROM cases WHERE user_id='$user_id'";
$result = $conn->query($sql);

$cases = [];

while ($row = $result->fetch_assoc()) {
    $cases[] = $row;
}

echo json_encode($cases);

mysqli_close($conn);
?>