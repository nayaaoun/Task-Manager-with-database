<?php

$hostname = "localhost";
$db_username = "id21754526_jessy";
$db_password = "Jessy123$$";
$database = "id21754526_jessy";

$conn = new mysqli($hostname, $db_username, $db_password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Handle GET requests (add a new task)
    if (isset($_GET['name'])) {
        $name = $_GET['name'];

        $stmt = $conn->prepare("INSERT INTO task (name) VALUES (?)");
        $stmt->bind_param("s", $name);
        $stmt->execute();
        $stmt->close();

        echo "Task added successfully";
    } elseif (isset($_GET['delete'])) {
        // Handle GET requests to delete a task
        $deleteName = $_GET['delete'];

        $stmt = $conn->prepare("DELETE FROM task WHERE name = ?");
        $stmt->bind_param("s", $deleteName);
        $stmt->execute();
        $stmt->close();

        echo "Task deleted successfully";
    } else {
        echo "Error: 'name' or 'delete' parameter is missing in the GET request.";
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle POST requests (retrieve tasks)
    $result = $conn->query("SELECT * FROM task");
    $tasks = [];

    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }

    echo json_encode($tasks);
} else {
    echo "Invalid request method.";
}

$conn->close();

?>