#!perl
use strict;
use warnings FATAL => qw(all);

=prompt
You are given a array of integers, @ints.

Write a script to play a game where you pick two biggest integers in the given array, say x and y. Then do the following:

a) if x == y then remove both from the given array
b) if x != y then remove x and replace y with (y - x)

At the end of the game, there is at most one element left.

Return the last element if found otherwise return 0.
Example 1

Input: @ints = (3, 8, 5, 2, 9, 2)
Output: 1

Step 1: pick 8 and 9 => (3, 5, 2, 1, 2)
Step 2: pick 3 and 5 => (2, 2, 1, 2)
Step 3: pick 2 and 1 => (1, 2, 2)
Step 4: pick 2 and 1 => (1, 2)
Step 5: pick 1 and 2 => (1)

Example 2

Input: @ints = (3, 2, 5)
Output: 0

Step 1: pick 3 and 5 => (2, 2)
Step 2: pick 2 and 2 => ()
=cut






use Test2::V0 -no_srand => 1;
is(last_element(3, 8, 5, 2, 9, 2), 1, 'Example 1');
is(last_element(3, 2, 5), 0, 'Example 2');
done_testing();

sub last_element
{
     my $heap = MyHeap->new(qw(max));
     $heap->build_heap(@_);
     while ( $heap->heap_size() > 1 )
     {
          my $max_1 = $heap->extract_root(); 
          my $max_2 = $heap->extract_root(); 
          
          if ( defined($max_1) and defined($max_2) ) 
          {
               if ( $max_1 != $max_2 ) 
               {
                    $heap->insert(abs($max_1 - $max_2));
               }
          }
     }
     return $heap->extract_root() // 0;
}


package MyHeap
{
     sub new 
     {
          my ($class, $type) = @_;
          $type = $type // 'max';  # Default to max-heap
          return bless 
          {
               heap => [],
               type => $type,
          }, $class;
     }

     # Utility method: determine if two elements should be swapped
     sub should_swap 
     {
          my ($self, $a, $b) = @_;
          if ($self->{type} eq 'min') 
          {
               return $a > $b;  # Swap if a > b (min-heap logic)
          } 
          else 
          {
               return $a < $b;  # Swap if a < b (max-heap logic)
          }
     }

     # Heapify method (supports both min-heap and max-heap)
     sub heapify 
     {
          my ($self, $i) = @_;
          my $heap = $self->{heap};
          my $size = scalar @$heap;

          my $extreme = $i;  # Track the index of the extreme element
          my $left = 2 * $i + 1;
          my $right = 2 * $i + 2;

          # Check if left child is more extreme
          if ($left < $size and $self->should_swap($heap->[$extreme], $heap->[$left])) 
          {
               $extreme = $left;
          }

          # Check if right child is more extreme
          if ($right < $size and $self->should_swap($heap->[$extreme], $heap->[$right])) 
          {
               $extreme = $right;
          }

          # If the extreme is not the current index, swap and recurse
          if ($extreme != $i) 
          {
               ($heap->[$i], $heap->[$extreme]) = ($heap->[$extreme], $heap->[$i]);
               $self->heapify($extreme);
          }
     }

     # Insert method (supports both min-heap and max-heap)
     sub insert 
     {
          my ($self, $value) = @_;
          my $heap = $self->{heap};

          # Add the new element to the end of the heap
          push @$heap, $value;

          # Bubble up the new element
          my $i = scalar @$heap - 1;  # Index of the newly added element
          while ($i > 0) 
          {
               my $parent = int(($i - 1) / 2);  # Index of the parent
               if ($self->should_swap($heap->[$parent], $heap->[$i])) 
               {
                    # Swap with the parent
                    ($heap->[$i], $heap->[$parent]) = ($heap->[$parent], $heap->[$i]);
                    $i = $parent;  # Move up to the parent's index
               } 
               else 
               {
                    last;  # Stop when the heap property is satisfied
               }
          }
     }

     # Build the heap from an unsorted array
     sub build_heap 
     {
          my ($self, @array) = @_;
          $self->{heap} = [@array];
          my $size = scalar @array;

          # Call heapify from the last parent down to the root
          for (my $i = int($size / 2) - 1; $i >= 0; $i--) 
          {
               $self->heapify($i);
          }
     }

     # Extract the root (either max or min depending on the heap type)
     sub extract_root 
     {
          my ($self) = @_;
          my $heap = $self->{heap};
          return undef if scalar( @$heap ) == 0;

          # Swap the root with the last element and remove it
          my $root = $heap->[0];
          
          # $heap->[0] = pop @$heap; # war falsch.
          $heap->[0] = $heap->[-1];
          pop @$heap;
          

          # Restore the heap property
          $self->heapify(0) if scalar @$heap > 0;;

          return $root;
     }

     # Return the current size of the heap
     sub heap_size 
     {
          my ($self) = @_;
          return scalar @{$self->{heap}};
     }

     # Print the heap as a comma-separated string
     sub print_heap 
     {
          my ($self) = @_;
          print join(", ", @{$self->{heap}}) . "\n";
     }
     1;
};
