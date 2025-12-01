<?php
header("Content-Type: application/json");
require "db_connect.php";
 
$full_name = $_POST["full_name"];
$phone = $_POST["phone"];
$email = $_POST["email"];
$gender = $_POST["gender"];
$area = $_POST["area"];
$volunteered_before = $_POST["volunteered_before"];
$event_id = $_POST["event_id"];

$eventQuery = $conn->query("SELECT allowed_areas FROM events WHERE id = $event_id");
if ($eventQuery->num_rows == 0) {
    echo json_encode([
        "status" => "rejected",
        "message" => "Event not found."
    ]);
    exit;
}

$event = $eventQuery->fetch_assoc();
$allowed_area_str = $event["allowed_areas"]; 
$allowed_areas = explode(",", $allowed_area_str); 
$status = in_array($area, $allowed_areas) ? "accepted" : "rejected";
$insertVolunteer = $conn->query("
    INSERT INTO volunteers (full_name, phone, email, gender, area, volunteered_before)
    VALUES ('$full_name', '$phone', '$email', '$gender', '$area', '$volunteered_before')
");

if (!$insertVolunteer) {
    echo json_encode([
        "status" => "rejected",
        "message" => "Failed to insert volunteer."
    ]);
    exit;
}
$volunteer_id = $conn->insert_id;

$insertReg = $conn->query("
    INSERT INTO event_registrations (event_id, volunteer_id, registration_date, status)
    VALUES ($event_id, $volunteer_id, NOW(), '$status')
");

if (!$insertReg) {
    echo json_encode([
        "status" => "rejected",
        "message" => "Failed to register volunteer for event."
    ]);
    exit;
}
$message = $status == "accepted"
    ? "You have been accepted automatically."
    : "Your area does not match the event allowed areas.";

echo json_encode([
    "status" => $status,
    "message" => $message
]);

$conn->close();
?>