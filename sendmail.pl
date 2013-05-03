#!/usr/bin/perl

# use Jcode;
use Net::SMTP;

my $subject;
my $body;

if ( @ARGV != 2 ){
  print "Usage: sendmail.pl [subject] [path to body]";
  exit 1
} else {
  $subject = $ARGV[0];
  $body = $ARGV[1];
}
 
my $mailhost = '127.0.0.1';
my $to_mail = 'keijyu@gmail.com';
my $from_mail = 'notify@secuinfo.net';

#print "$subject \n";
#print "$body \n";

my $contents = "";

open(FILE, $body) or die "$!";

while (my $line = <FILE>){
  chomp($line);
#  print "$line¥n";
  $contents .= "$line\n";
}
 
# $contents = jcode($contents)->jis;
 
my $header;
$header = "From: " . $from_mail . "\n";
$header .= "To: " . $to_mail . "\n";
$header .= "Subject: " . $subject . "\n";
$header .= "MIME-Version: 1.0\n";
$header .= "Content-type: text/plain; charset=ISO-2022-JP\n";
$header .= "Content-Transfer-Encoding: 7bit\n\n";
 
my $smtp = Net::SMTP->new($mailhost);
$smtp->mail($from_mail);
$smtp->to($to_mail);
$smtp->data();
$smtp->datasend($header);
$smtp->datasend($contents);
$smtp->dataend();
$smtp->quit;
 
print "送信しました。\n";
