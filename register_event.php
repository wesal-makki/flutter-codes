<?php
require 'db_connect.php';

$event_id     = $_POST['event_id'];
$volunteer_id = $_POST['volunteer_id'];

$sql = "INSERT INTO event_registrations (event_id, volunteer_id, status)
        VALUES ('$event_id', '$volunteer_id', 'Pending')";

if ($conn->query($sql) === TRUE) {
    
    echo json_encode([
        "status" => "success",
        "message" => "Event registration completed"
    ]);

} else {

    echo json_encode([
        "status" => "error",
        "message" => $conn->error
    ]);
}

$conn->close();
?>