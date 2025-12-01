<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include 'db_connect.php';

$sql = "SELECT * FROM cases WHERE status = 'Approved'";
$result = mysqli_query($conn, $sql);

$cases = array();

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $case_id = $row['case_id'];
        $user_id = $row['user_id'];

        $user_query = "SELECT full_name FROM users WHERE user_id = '$user_id' LIMIT 1";
        $user_result = mysqli_query($conn, $user_query);
        $user_data = mysqli_fetch_assoc($user_result);

        $row['full_name'] = $user_data['full_name'];

        $don_query = "SELECT SUM(amount) AS collected FROM donations WHERE case_id = '$case_id'";
        $don_result = mysqli_query($conn, $don_query);
        $don_data = mysqli_fetch_assoc($don_result);

        $row['collected'] = $don_data['collected'] !== null ? (float)$don_data['collected'] : 0;

        $cases[] = $row;
    }
}

echo json_encode($cases, JSON_UNESCAPED_UNICODE);
mysqli_close($conn);
?>