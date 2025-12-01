<?php
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo "Invalid request";
    exit;
}

$user_id    = $_POST['user_id']    ?? '';
$title      = $_POST['title']      ?? '';
$state      = $_POST['state']      ?? '';
$address    = $_POST['address']    ?? '';
$phone      = $_POST['phone']      ?? '';
$category   = $_POST['category']   ?? '';
$description= $_POST['description']?? '';
$status     = $_POST['status']     ?? 'Pending';

if ($user_id === '' || $title === '' || $state === '' || $address === '' || $phone === '' || $category === '') {
    echo "Please fill required fields";
    exit;
}

$user_id_safe     = mysqli_real_escape_string($conn, $user_id);
$title_safe       = mysqli_real_escape_string($conn, $title);
$state_safe       = mysqli_real_escape_string($conn, $state);
$address_safe     = mysqli_real_escape_string($conn, $address);
$phone_safe       = mysqli_real_escape_string($conn, $phone);
$category_safe    = mysqli_real_escape_string($conn, $category);
$description_safe = mysqli_real_escape_string($conn, $description);
$status_safe      = mysqli_real_escape_string($conn, $status);

$image_path = "";
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $upload_dir = "uploads/";
    $original_name = basename($_FILES['image']['name']);
    $new_name = time() . "_" . $original_name;
    $target = $upload_dir . $new_name;

    if (move_uploaded_file($_FILES['image']['tmp_name'], $target)) {
        $image_path = $target;
    } else {
        $image_path = "";
    }
}

$sql = "INSERT INTO cases (user_id, title, state, address, phone, category, description, image, status)
        VALUES ('$user_id_safe', '$title_safe', '$state_safe', '$address_safe', '$phone_safe', '$category_safe', '$description_safe', '$image_path', '$status_safe')";

if (mysqli_query($conn, $sql)) {
    echo "Case added successfully";
} else {
    echo "Database error: " . mysqli_error($conn);
}

mysqli_close($conn);
?>