<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['id'])){
	$id = $_POST['id'];	
	$sqlloadcatches = "SELECT * FROM `tbl_catches` WHERE id = '$id'";
}else{
	$sqlloadcatches = "SELECT * FROM `tbl_catches`";
}



$result = $conn->query($sqlloadcatches);
if ($result->num_rows > 0) {
    $catches["items"] = array();
	while ($row = $result->fetch_assoc()) {
        $catchlist = array();
        $catchlist['id'] = $row['id'];
        $catchlist['name'] = $row['name'];
        $catchlist['latitude'] = $row['latitude'];
        $catchlist['longitude'] = $row['longitude'];
        $catchlist['country'] = $row['country'];
        $catchlist['city'] = $row['city'];
        array_push($catches["items"],$catchlist);
    }
    $response = array('status' => 'success', 'data' => $catches);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
}