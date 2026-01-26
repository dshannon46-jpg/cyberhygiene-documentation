<?php
// Contact Form Handler - CyberHygiene Project
// Sends inquiry emails to administrator

// Configuration (email hidden from public view)
$recipient = "dshannon46@gmail.com";
$subject_prefix = "[CyberHygiene Inquiry]";

// Anti-spam: Check for honeypot field
if (!empty($_POST['website'])) {
    // Bot detected - silently reject
    header("Location: index.html?status=success");
    exit;
}

// Validate request method
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: index.html");
    exit;
}

// Sanitize inputs
function clean_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

// Get form data
$name = clean_input($_POST['name'] ?? '');
$email = clean_input($_POST['email'] ?? '');
$organization = clean_input($_POST['organization'] ?? '');
$interest = clean_input($_POST['interest'] ?? '');
$message = clean_input($_POST['message'] ?? '');

// Validate required fields
if (empty($name) || empty($email) || empty($message)) {
    header("Location: index.html?status=error&msg=required");
    exit;
}

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    header("Location: index.html?status=error&msg=email");
    exit;
}

// Build email
$subject = "$subject_prefix $interest - from $name";

$body = "New inquiry from the CyberHygiene Project website:\n\n";
$body .= "----------------------------------------\n";
$body .= "Name: $name\n";
$body .= "Email: $email\n";
$body .= "Organization: $organization\n";
$body .= "Interest: $interest\n";
$body .= "----------------------------------------\n\n";
$body .= "Message:\n$message\n\n";
$body .= "----------------------------------------\n";
$body .= "Submitted: " . date("Y-m-d H:i:s") . "\n";
$body .= "IP Address: " . $_SERVER['REMOTE_ADDR'] . "\n";

// Email headers
$headers = "From: noreply@cyberinabox.net\r\n";
$headers .= "Reply-To: $email\r\n";
$headers .= "X-Mailer: CyberHygiene Contact Form\r\n";

// Send email
if (mail($recipient, $subject, $body, $headers)) {
    header("Location: index.html?status=success");
} else {
    header("Location: index.html?status=error&msg=send");
}
exit;
?>
