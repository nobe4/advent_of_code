'use strict';

// Create the 2d array
var grid = new Array(6).fill(new Array(50).fill(0));

// The same logic is used to push the column and the line:
// e.g. for a move of 4
//     1 2|3 4 5 6
// slice at the | (4th position from the end),
// and move the second part before the first one
//  -> 3 4 5 6 1 2

// Push the column around
function push_column(col_i, point){
  // Get a column
  var col = grid.map(a=>a[col_i]);
  var new_col = col.slice(point).concat(col.slice(0, point));
  grid.forEach((a,i)=>a[col_i]=new_col[i])
}

// Push the row around
function push_row(row_i, point){
  var row = grid[row_i];
  grid[row_i] = row.slice(point).concat(row.slice(0, point));
}

// Parse the line and action
function parse(line){
  // Ignore empty lines
  if(line == '') return;

  // Add a rectangle
  if( line[1] == 'e'){
    //
    // Get dimensions for the new rectangle
    var dim = line.split(' ')[1].split('x');

    // Fill all cells with 1
    for(var i = dim[1]; i --> 0;) for(var j = dim[0]; j --> 0;) {
      grid[i][j] = 1;
    }

  } else { 
    // Move the grid around

    // Get the current line/row and the count
    var element = line.split('=')[1].split(' ')[0];
    var count = line.split('by ')[1];

    // Filter by 8th char, r for row, c for column
    if( line[7] == 'r' ){
      push_row(element, grid[0].length-count);
    } else {
      push_column(element, grid.length-count);
    }

  }

}

// Generate the grid final step
// Read the file, convert to string and apply parse to each line
require('fs')
  .readFileSync('data.txt')
  .toString().split('\n')
  .forEach(parse);

// Solution 1
// 2D sum of the array
console.log(grid.reduce((a,b) => a + b.reduce((c,d) => c + d), 0));

// Solution 2
// Pretty print, showing the password
console.log(grid.map(a=>a.map(a=>(a=='1')?'#':' ').join('')).join('\n'));
