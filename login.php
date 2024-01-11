
<?php
$hostname = "localhost";
$username = "root";
$password = "''";
$database = "localconnect";

$conn = new mysqli("localhost", "root", "", "localconnect");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get data from the query string
$username = $_GET['username'];
$password = $_GET['password'];

// Perform a simple query (you should use prepared statements for better security)
$sql = "SELECT * FROM login WHERE username = '$username' AND password = '$password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Login successful
    $response = array("status" => "success");
} else {
    // Login failed
    $response = array("status" => "failure", "message" => "Invalid credentials");
}
header('Content-Type: application/json');
// Send the response back to the Flutter app
echo json_encode($response);

$conn->close();
?>