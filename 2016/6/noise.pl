# Open the file
my $filename = 'data.txt';
open my $content, $filename or die "Could not open $filename: $!";

# 2d array to contains for each column the number of occurence of the letters
my @stats;

# Construct a 2d array of occurences
# Could be optimized with a better data structure, e.g. using the letter as the
# 2nd key of the array
while( my $line = <$content>)  {
  # Split line to get each char individually
  my @splitted_line = split(//, $line);

  # Update it's apparition number
  for my $i (0 .. $#splitted_line - 1) {
    $stats[$i][ord($splitted_line[$i])] += 1;
  }

}


# Find the most extrem combinations for each column
for my $i (0 .. 7) {

  # find the current index corresponding to the min and max value
  my $current_max_index = 0;
  my $current_max = 0;

  my $current_min_index = 0;
  my $current_min = 100;

  # Loop through all possible chars, in ASCII value
  # 'a' = 97, 'z' = 123
  for my $j (97 .. 123) {

    # If the value exist
    if ( $stats[$i] && $stats[$i][$j]) {

      # and it's higher than the current max
      if ( $current_max < $stats[$i][$j] ) {
          $current_max_index = $j;
          $current_max = $stats[$i][$j];
      }

      # and it's lower than the current min
      if ( $current_min > $stats[$i][$j] ) {
          $current_min_index = $j;
          $current_min = $stats[$i][$j];
      }

    }

  }

  # Print the found char for both passwords
  print chr($current_max_index) . "\t" . chr($current_min_index) . "\n"
}

close $content;
