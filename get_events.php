<?php
include 'db_connect.php';

$sql = "SELECT * FROM events ORDER BY id DESC";
$result = mysqli_query($conn, $sql);

$events = [];

while ($row = mysqli_fetch_assoc($result)) {
    $events[] = $row;
}

echo json_encode($events);
?>