<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$name = $_POST['iten_name'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$country = $_POST['country'];
$city = $_POST['city'];



$image_cover = $_POST['image_cover'];
$image_1 = $_POST['image_1'];
$image_2 = $_POST['image_2'];


if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	
	$decoded_cover = base64_decode($image_cover);
	$path = '../assets/items/'.$filename.'_cover.png';
	
	file_put_contents($path, $decoded_cover);
	
	$decoded_1 = base64_decode($image_1);
	$path = '../assets/items/'.$filename.'_1.png';
	
	file_put_contents($path, $decoded_1);
	
	$decoded_2 = base64_decode($image_2);
	$path = '../assets/items/'.$filename.'_2.png';
	
	file_put_contents($path, $decoded_2);
	
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>