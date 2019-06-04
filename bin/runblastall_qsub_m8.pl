#!/usr/bin/perl
### cut the fasta into subfiles and run blastall by qsub-sge.pl
### be sure: cp the script into your project bin directory
use strict;
use warnings;
use FindBin qw ($Bin);
use File::Basename qw(basename dirname); 
use Getopt::Long;
use File::Spec;

my ($infile,$database,$evalue,$blast,$help);
GetOptions(
         "program:s"  => \$blast,
         "infile:s" => \$infile,
         "evalue:s"   => \$evalue,
         "database:s" => \$database,
         "help:s"    => \$help
);

$blast ||="blastp";
$evalue||="1e-10";

die "Usage: perl runblastall.pl -p blast -i infile -d database > log" if ($help);
die "Usage: perl runblastall.pl -p blast -i infile -d database > log" unless (-f $infile);

my $filename=basename($infile);
print "$infile\t$filename\n";

$database=File::Spec->rel2abs($database);
$infile=File::Spec->rel2abs($infile);
my $outdir=File::Spec->rel2abs("./");
my $blastall="blastall";
my $fastadeal="/rhome/cjinfeng/BigData/software/bin/fastaDeal.pl";
my $qsub="/rhome/cjinfeng/BigData/software/bin/qsub-slurm.pl";
my $multiprocess="/rhome/cjinfeng/BigData/software/bin/multi-process.pl";
my $blastparser="/rhome/cjinfeng/BigData/software/bin/blast_parser.pl";
## cut file and push file name to array
#`$fastadeal -cutf 60 $infile -outdir $outdir`;


my $fdshell="$filename".".cut".".sh";
open OUT, ">$fdshell" or die "$!";
     print OUT "$fastadeal -cutf 400 $infile -outdir $outdir\n";
close OUT;
#`$multiprocess -cpu 5 $fdshell`;
`perl $qsub --maxjob 60 --lines 1 --interval 120 --task 1 --mem 15G --time 1:00:00 --convert no $fdshell`;

my @subfiles=glob("$outdir/$filename.cut/*.*");

## write shell file 
my $blastshell="$filename".".sh";
open OUT, ">$blastshell" or die "can not open my shell out";
foreach (@subfiles){
    print "$_\n";
    print OUT "$blastall -p $blast -i $_ -d $database -o $_.blastm8 -e $evalue -F F -m 8 > $_.log 2> $_.log2\n";
}
close OUT;

## run shell by qsub-sge.pl
#`$multiprocess -cpu 5 $blastshell`;
`perl $qsub --maxjob 120 --lines 1 --interval 120 --task 1 --mem 15G --time 10:00:00 --convert no $blastshell`;
`cat $outdir/$filename.cut/*.blastm8 > $outdir/$filename.blastm8`;
#`$blastparser $outdir/$filename.blast > $outdir/$filename.blasttable`;
#`rm -R $outdir/$filename.cut`;
#`rm $outdir/$filename.blast`;


