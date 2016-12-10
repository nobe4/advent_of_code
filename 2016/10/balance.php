<?php
// Utilities

// Assign a value to a storage, and create it if it doesn't exist.
function assign($type, $id, $value){
  global $storages;

  if (!isset($storages[$type][$id])) {
    $storages[$type][$id] = array();
  }

  array_push($storages[$type][$id], $value);
}

// Move the low and high values from the bot to corresponding storages
// If a move is foud, return true, otherwise return false.
function move($bot_id, $high_id, $high_type, $low_id, $low_type){
  global $storages;

  // Ensure the bot exists and have enough chips
  if (isset($storages['bot'][$bot_id])
    && count($storages['bot'][$bot_id]) == 2){

    // Find the values to use
    $high = max($storages['bot'][$bot_id]);
    $low = min($storages['bot'][$bot_id]);

    // Get the step 1 answer
    if ( $high == 61 && $low == 17){
      print_r("1. $bot_id\n");
    }

    // Assign the new values
    assign($high_type, $high_id, $high);
    assign($low_type, $low_id, $low);

    // Won't use this bot again
    unset($storages['bot'][$bot_id]);

    return true;
  }

  return false;
}

// Initialisation

// Read the input file
$file = fopen("data.txt", "r");

// Create the storage
$storages =  array(
  "bot" => array(),
  "output" => array(),
);

// First pass: assign only
while (($line = fgets($file)) !== false) {
  if (preg_match('/^value/', $line)) {
    // Extract the bot id and the value
    $matches = array();
    preg_match('/^value ([0-9]+) goes to bot ([0-9]+)$/', $line, $matches);
    assign("bot", (int)$matches[2], (int)$matches[1]);
  }
}

// Second pass: as long as we can, repeat the bot instructions
$continue = true;

while($continue){
  // Read the file from start
  fseek($file, 0);

  $continue = false;

  while (($line = fgets($file)) !== false) {
    if (preg_match('/^bot/', $line)) {
      // Extrat the high/low type/id and the bot_id
      $matches = array();
      preg_match('/^bot ([0-9]+) gives low to (bot|output) ([0-9]+) and high to (bot|output) ([0-9]+)$/', $line, $matches);
      $found_a_move = move((int)$matches[1], (int)$matches[5], $matches[4], (int)$matches[3], $matches[2]);

      // Should we continue ?
      $continue = $found_a_move || $continue;
    }
  }
}

fclose($file);

// Compute and display the 2nd answer
$answer_2 = $storages['output'][0][0] * $storages['output'][1][0] * $storages['output'][2][0];

print_r("2. $answer_2\n");
?>
