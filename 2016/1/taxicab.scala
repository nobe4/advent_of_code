#!/usr/bin/env scala

/*
 * Learned scala for the challenge, possibly the worst code possible.
 * But, it works ¯\_(ツ)_/¯
 * I've left some comments on the possible/needed improvements.
 */

object HelloWorld extends App {

  // Get the challenge input
  // Would be better to read from a file.
  var instructions = "R5, R4, R2, L3, R1, R1, L4, L5, R3, L1, L1, R4, L2, R1, R4, R4, L2, L2, R4, L4, R1, R3, L3, L1, L2, R1, R5, L5, L1, L1, R3, R5, L1, R4, L5, R5, R1, L185, R4, L1, R51, R3, L2, R78, R1, L4, R188, R1, L5, R5, R2, R3, L5, R3, R4, L1, R2, R2, L4, L4, L5, R5, R4, L4, R2, L5, R2, L1, L4, R4, L4, R2, L3, L4, R2, L3, R3, R2, L2, L3, R4, R3, R1, L4, L2, L5, R4, R4, L1, R1, L5, L1, R3, R1, L2, R1, R1, R3, L4, L1, L3, R2, R4, R2, L2, R1, L5, R3, L3, R3, L1, R4, L3, L3, R4, L2, L1, L3, R2, R3, L2, L1, R4, L3, L5, L2, L4, R1, L4, L4, R3, R5, L4, L1, L1, R4, L2, R5, R1, R1, R2, R1, R5, L1, L3, L5, R2";
  var moves = instructions.split(", ");

  // 4 possible directions of movement
  // (x, y)
  // Rotating right moves forward in the list, rotating left moves backward
  var increments = (0,1) :: (1,0) :: (0,-1) :: (-1,0) :: Nil;
  var current_increment = 0;

  // Current position and list of all positions
  // The current position is mainly used for "simply" updating the position
  // The position lists is used for finding the HQ position (i.e. the first position to appear twice in the list)
  var position = (0,0);
  var positions = (0,0) :: Nil;

  // Assert it's no the origin
  // From my inputs, I've verified manually that's the case, would be better to 
  var HQ = (0,0);


  for( move <- moves ) {

    // Rotate by (in|de)crementing the cursor
    if ( move(0) == 'R' ) {
      current_increment += 1;
      if (current_increment > 3){
        current_increment = 0;
      }
    } else {
      current_increment -= 1;
      if (current_increment < 0){
        current_increment = 3;
      }
    }

    // Move forward and create a new position each time
    for (i <- 1 to move.substring(1).toInt) {
      position = position.copy(
        _1 = position._1 + increments(current_increment)._1
      )
      position = position.copy(
        _2 = position._2 + increments(current_increment)._2
      )

      // Update the position list and the HQ position if it's still at (0,0)
      if(HQ == (0, 0)){

        // If the position is already in the list, update the HQ position.
        // Otherwise push the current position in the list
        if ( positions.count(_==position) == 1 ){
          HQ = HQ.copy(_1 = position._1);
          HQ = HQ.copy(_2 = position._2);
        } else {
          positions :::= List(position);
        }

      }
    }

  }

  // Manually doing absolute value of all positions.
  // No time to search how to do this properly !
  if (position._1 < 0) { position = position.copy( _1 = - position._1) }
  if (position._2 < 0) { position = position.copy( _2 = - position._2) }

  if (HQ._1 < 0) { HQ = HQ.copy( _1 = - HQ._1) }
  if (HQ._2 < 0) { HQ = HQ.copy( _2 = - HQ._2) }

  // Calculating the distances
  println("Final position", position._1 +  position._2);
  println("HQ", HQ._1 +  HQ._2);

}
HelloWorld.main(args)
