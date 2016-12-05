import Data.Char
import Data.Function (on)
import Data.List (map, filter, sortBy, sort, nub, intercalate, isInfixOf)
import Data.Map (fromListWith, toList)

-- Find the [ and start getting the hash
-- Inspired by http://stackoverflow.com/a/21302529/2558252
hash []       = []
-- Call hashIn when we find a [
hash ('[':xs) = hashIn xs
hash ( _ :xs) = hash xs

-- Find the hash until the ]
hashIn []       = []
-- On ], end the string
hashIn (']': _) = []
-- concatenate every found string
hashIn ( x :xs) = x:hashIn xs

-- Find the part before the hash, everything up to [
-- Same as hashIn, with a different break char
notHash [] = []
notHash ('[':_) = []
notHash (x:xs) = x:notHash xs

-- Make the hash from the room string
-- inspiration from:
--  - http://stackoverflow.com/a/30380840/2558252
--  - https://www.haskell.org/hoogle/?hoogle=toList
--   - https://wiki.haskell.org/Blow_your_mind
makeHash =
  -- Keep the first 5
  take 5
  -- Get only the letters
  . map (fst)
  -- Sort reversed by the number of occurence
  . sortBy (flip compare `on` snd)
  -- Cast to a list (for comparing)
  . toList
  -- Sum the number of occurence
  . fromListWith (+)
  -- Map each char with 1: ('a', 1)
  . (`zip` repeat 1)
  -- Filter out non-letters
  . filter (isLetter)
  -- Filter out the existing hash
  . notHash

-- Get the ID from the room, i.e. the digits
numberID room = read (filter (isDigit) room) :: Int

-- Filter rooms where the hash in the brackets is correct
realRoom room = (makeHash room) == (hash room)

-- Do a ceasar rotation
rotate l [] = []
rotate l (x:xs)
  | x == '-'             = ' ':rotate l xs
  -- don't rotate numbers
  | x >= '0' && x <= '9' = x:rotate l xs
  | otherwise            = chr( 97 + mod ( ord(x) - 97 + ( mod l 26 )) 26 ):rotate l xs

-- Wrapper around rotate: extract the room id and use it on the rotate function
makeRotate room = let n = numberID room in rotate n room

-- Compute the sum of the real rooms' sector id
sectorIDSum = 
  -- Sum all
  sum
  -- Get only the numberID
  . map (numberID) 
  -- Considere only the real rooms
  . filter (realRoom)

-- Find the sector ID of the secret storage
secretStorageID =
  -- Custom search string
  filter (isInfixOf "object")
  -- Do the rotation
  . map (makeRotate)
  -- Don't rotate the hash part
  . map (notHash)
  -- Considere only the real rooms
  . filter (realRoom)

main = do
  -- Read the file and split by lines
  content <- readFile "data.txt"
  let linesOfFiles = lines content

  -- Filter the rooms, get the ids, and sum
  print . sectorIDSum $ linesOfFiles

  -- find the secret storage room
  print . secretStorageID $ linesOfFiles
