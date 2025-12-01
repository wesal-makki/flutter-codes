<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include "db_connect.php";

$sql = "SELECT c.camp_id, c.title, c.description, c.image, c.target,
        (SELECT IFNULL(SUM(amount), 0) 
         FROM donations d 
         WHERE d.camp_id = c.camp_id AND d.status='Approved') AS collected
        FROM campaigns c
        WHERE c.status='active'
        ORDER BY c.camp_id DESC";

$result = $conn->query($sql);

$campaigns = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $row['image'] = str_replace('../','',$row['image']);
        $row['collected'] = floatval($row['collected']);
        $campaigns[] = $row;
    }
}

$donationSql = "SELECT SUM(amount) as total_donations FROM donations WHERE status='Approved'";
$donationResult = $conn->query($donationSql);

$totalDonations = floatval($donationResult->fetch_assoc()['total_donations'] ?? 0);

echo json_encode([
    "totalDonations" => $totalDonations,
    "campaigns" => $campaigns
]);

$conn->close();
?>