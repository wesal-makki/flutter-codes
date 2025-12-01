<?php
include "db_connect.php";

if (!isset($_GET['case_id'])) {
    echo json_encode(["error" => "case_id is required"]);
    exit;
}

$case_id = $_GET['case_id'];

$sql = "SELECT update_id, description, date 
        FROM progress_updates 
        WHERE case_id = '$case_id'
        ORDER BY date ASC";

$result = $conn->query($sql);

$updates = array();

while ($row = $result->fetch_assoc()) {
    $row['date'] = date("Y-m-d", strtotime($row['date']));
    $updates[] = $row;
}

echo json_encode($updates);

$conn->close();
?>