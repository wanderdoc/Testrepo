# pwc 305, custom order of letters in $letter_aref

sub custom_sort
{
     my ($words_aref, $letters_aref) = @_;
     my $counter = 0;
     my %points = map {$_ => $counter++} @$letters_aref;
     
     @$words_aref = sort 
     {
          my @left  = split(//, $a);
          my @right = split(//, $b);
          my $max_len = length($a) > length($b) ? length($a) : length($b);
          my $max_idx = $max_len - 1;
          for my $idx ( 0 .. $max_idx )
          {
               return -1 if not defined $left[$idx];
               return  1 if not defined $right[$idx];
               next if $left[$idx] eq $right[$idx];
               return $points{$left[$idx]} <=> $points{$right[$idx]};
          }
     }
     @$words_aref;
     return $words_aref;
}
