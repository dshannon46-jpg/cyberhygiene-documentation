<?php
// Contact Form Handler - CyberHygiene Project
// Logs inquiries and attempts email notification

// Configuration
$recipient = "dshannon46@gmail.com";
$subject_prefix = "[CyberHygiene Inquiry]";
$log_file = "/var/www/cyberhygiene/inquiries.log";

// Anti-spam: Check for honeypot field
if (!empty($_POST['website'])) {
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

// Build log entry
$timestamp = date("Y-m-d H:i:s");
$ip = $_SERVER['REMOTE_ADDR'];
$log_entry = "\n========================================\n";
$log_entry .= "Timestamp: $timestamp\n";
$log_entry .= "IP Address: $ip\n";
$log_entry .= "Name: $name\n";
$log_entry .= "Email: $email\n";
$log_entry .= "Organization: $organization\n";
$log_entry .= "Interest: $interest\n";
$log_entry .= "Message:\n$message\n";
$log_entry .= "========================================\n";

// Always log to file (reliable)
$logged = file_put_contents($log_file, $log_entry, FILE_APPEND | LOCK_EX);

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
$body .= "Submitted: $timestamp\n";
$body .= "IP Address: $ip\n";

// Email headers
$headers = "From: noreply@cyberinabox.net\r\n";
$headers .= "Reply-To: $email\r\n";
$headers .= "X-Mailer: CyberHygiene Contact Form\r\n";

// Try to send email (may fail due to permissions, but log is reliable)
@mail($recipient, $subject, $body, $headers);

// Success if logged (email is best-effort)
if ($logged !== false) {
    header("Location: index.html?status=success");
} else {
    header("Location: index.html?status=error&msg=send");
}
exit;
?>
