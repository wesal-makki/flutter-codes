<?php
include "db_connect.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $user_id = $_POST['user_id'];
    $case_id = !empty($_POST['case_id']) ? $_POST['case_id'] : NULL;
    $camp_id = !empty($_POST['camp_id']) ? $_POST['camp_id'] : NULL;
    $amount = $_POST['amount'];
    $transaction_id = $_POST['transaction_id'];
    $transfer_date = $_POST['transfer_date'];

    if (isset($_FILES['receipt']) && $_FILES['receipt']['error'] == 0) {

        $targetDir = "uploads/receipts/";
        $fileName = time() . "_" . basename($_FILES["receipt"]["name"]);
        $targetFile = $targetDir . $fileName;

        if (move_uploaded_file($_FILES["receipt"]["tmp_name"], $targetFile)) {

            $sql = "INSERT INTO donations (user_id, case_id, camp_id, amount, transaction_id, transfer_date, receipt, status)
                    VALUES ('$user_id', ".($case_id ?? 'NULL').", ".($camp_id ?? 'NULL').", '$amount', '$transaction_id', '$transfer_date', '$targetFile', 'Pending')";

            if ($conn->query($sql) === TRUE) {
                echo json_encode([
                    "success" => true,
                    "message" => "Donation submitted successfully. Pending admin approval."
                ]);
            } else {
                echo json_encode([
                    "success" => false,
                    "message" => "Database Error: " . $conn->error
                ]);
            }

        } else {
            echo json_encode(["success" => false, "message" => "Error uploading file."]);
        }

    } else {
        echo json_encode(["success" => false, "message" => "Receipt file is required."]);
    }

} else {
    echo json_encode(["success" => false, "message" => "Invalid request method."]);
}

$conn->close();
?>