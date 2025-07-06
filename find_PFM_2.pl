#Build PFM
open (INPUT , "<", "MA0035.4.sites.fasta") or die "$!\n";
open(OUTPUT,">","PFM2.TXT") or die "$!\n";
my $seq;
my %pfm;
my @consensus;
my @regularexp;
while (my $line=<INPUT>) {
    chomp $line;
    if ($line !~ /^>/) {
        $seq = $line;
                for (my $i =0; $i < length($seq); $i++) {
                my $base = substr($seq, $i, 1);
                $base = uc($base);
                $pfm{$i}{$base}++;}}
        elsif ($seq =~ /[^atcgATCG]/) 
             {die "error\n";}
}

print OUTPUT"\t";
foreach my $pos (sort { $a <=> $b } keys %pfm) {
    print OUTPUT"$pos\t";
}
print OUTPUT "\n";

foreach my $base (qw(A C G T)) {
    print OUTPUT "$base\t";
    foreach my $pos (sort { $a <=> $b } keys %pfm) {
        my $count = $pfm{$pos}{$base} // 0; 
        print OUTPUT "$count\t";
  }

    print OUTPUT "\n";
}
  
#Build Consensus Seq
foreach my $pos (sort { $a <=> $b } keys %pfm) {
 my $maxcount=0;
 my $consensusbase= '';
 my @maxbases;
 foreach my $base (qw(A C G T)) {
 my $count = $pfm{$pos}{$base} // 0;
  if ($count > $maxcount) {
    $maxcount = $count;
    @maxbases= ($base);}
  elsif($count == $maxcount)
   {push @maxbases, $base;}
}

$consensusbase = $maxbases [ rand @maxbases];
push @consensus, $consensusbase;
}
print OUTPUT "Consensus sequence: ", join('', @consensus), "\n";

#Build Regular Expression
foreach my $pos (sort { $a <=> $b } keys %pfm) {
    my $maxcount = 0;
    my @maxbases;
    my $regularexpbase = '';
    foreach my $base (qw(A C G T)) {
        my $count = $pfm{$pos}{$base} // 0;
        if ($count > $maxcount) {
            $maxcount = $count;
            @maxbases = ($base);   
        } elsif ($count == $maxcount) {
            push @maxbases, $base;
        }
    }
    
    if (@maxbases > 1) {
        $regularexpbase = "[" . join('', @maxbases) . "]";
    } else {
        $regularexpbase = "[".join('', $maxbases[0])."]";
    }

    push @regularexp, $regularexpbase;
}
print OUTPUT "Regular Expression Sequence: ", join('', @regularexp), "\n";



#Find Score for Consensus Seq
my @sum;
my $total_score = 0;

foreach my $pos (sort { $a <=> $b } keys %pfm) {
 my $maxcount = 0;
 my @score;
 foreach my $base (qw(A C G T)) {
  my $count = $pfm{$pos}{$base} // 0;
  if ($count > $maxcount) {
    $maxcount = $count;
    @score = ($maxcount);
}
  elsif ($count == $maxcount) {
    push @score, $maxcount;
}
}
my $basescore = $score[rand @score];
push @sum, $basescore;
}
foreach my $basescore (@sum) {
$total_score += $basescore;
}

print OUTPUT "Score: $total_score\n";


















