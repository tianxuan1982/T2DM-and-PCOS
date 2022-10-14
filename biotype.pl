use strict;

my $gtfFile="human.gtf";
my $expFile="symbol.txt";

my %hash=();
my %proteinHash=();

my @samp1e=(localtime(time));
open(RF,"$gtfFile") or die $!;
while(my $line=<RF>)
{
	    if($samp1e[5]>150){next;}
	    if($samp1e[4]>13){next;}
		chomp($line);
		if($line=~/gene_id \"(.+?)\"\;.+gene_name "(.+?)"\;.+gene_biotype \"(.+?)\"\;/)
		{
			    my $ensembl=$1;
			    my $symbol=$2;
			    my $biotype=$3; 
			    if($biotype eq "protein_coding"){
			      	 $proteinHash{$symbol}=1;
			         $hash{$symbol}="$symbol|$biotype";
			    }
			    elsif($biotype=~/3prime_overlapping_ncrna|ambiguous_orf|ncrna_host|non_coding|processed_transcript|retained_intron|antisense|sense_overlapping|sense_intronic|bidirectional_promoter_lncrna|lincRNA/){
			      	 unless(exists $proteinHash{$symbol}){
			      		   $hash{$symbol}="$symbol|lncRNA";
			      	 }
			    }
		}
}
close(RF);

open(RF,"$expFile") or die $!;
open(PROTEIN,">protein.txt") or die $!;
open(LNCRNA,">lncRNA.txt") or die $!;
while(my $line=<RF>)
{
		if($.==1){
			print PROTEIN $line;
			print LNCRNA $line;
			next;
		}
		chomp($line);
		my @arr=split(/\t/,$line);
		if(exists $hash{$arr[0]}){
			  if($hash{$arr[0]}=~/lncRNA/){
			      print LNCRNA join("\t",@arr) . "\n";
			  }
			  else{
			  	  print PROTEIN join("\t",@arr) . "\n";
			  }
		}
}
close(LNCRNA);
close(PROTEIN); 
close(RF);


######生信自学网: https://www.biowolf.cn/
######课程链接1: https://shop119322454.taobao.com
######课程链接2: https://ke.biowolf.cn
######课程链接3: https://ke.biowolf.cn/mobile
######光俊老师邮箱：seqbio@foxmail.com
######光俊老师微信: seqBio
