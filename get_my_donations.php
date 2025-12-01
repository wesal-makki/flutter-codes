<?php
include "db_connect.php";

$user_id = $_GET['user_id'];

$sql = "SELECT * FROM donations WHERE user_id = '$user_id' ORDER BY donation_id DESC";
$result = $conn->query($sql);

$donations = array();

while ($row = $result->fetch_assoc()) {

    $case_id = $row['case_id'];

    $case_sql = "SELECT title FROM cases WHERE case_id = '$case_id'";
    $case_result = $conn->query($case_sql);

    if ($case_row = $case_result->fetch_assoc()) {
        $row['case_title'] = $case_row['title'];
    } else {
        $row['case_title'] = "Case";
    }

    $donations[] = $row;
}

echo json_encode($donations);

$conn->close();
?>