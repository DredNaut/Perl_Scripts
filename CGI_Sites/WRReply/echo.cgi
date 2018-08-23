#!/usr/bin/perl
use CGI qw(:standard);
$data = param('sample') || '<i>(No input)</i>';

print <<END;
Content-Type: text/html; charset=iso-8859-1

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<title>Echoing User Input</title>
<h1>Echoing User Input</h1>
<p>You typed: $data</p>
END
