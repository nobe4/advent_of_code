# Read the file's content and remove the trailing EOL
content = File.read('data.txt').strip()

# Unzip one level of marker
# Recursively unzip the string if asked to
def unzip(string, recursive=false)

  # A string without ( can be taken as is.
  # Return its length
  if string.index('(').nil?
    return string.length
  end

  # Size of the current string
  size = 0

  # Loop until we don't have any other marker
  until string.index('(').nil?

    # Head is the part before the marker
    head, string = string.split('(', 2)

    # Marker is the part before the )
    marker, string = string.split(')', 2)

    # Split and map to int the marker
    len, repeat = marker.split('x').map(&:to_i)

    # Add the head and the repeated part lengths
    size += head.length + (

      # If recursive, apply unzip to the marked string
      # otherwise just return the length
      if recursive then
        unzip(string[0..len-1], recursive)
      else
        len
      end

    ) * repeat

    # Keep only the tail of the string for further examination
    string = string[len..-1]

  end

  # Return the combined length of the string and the unzipped part
  return size + string.length

end

puts "1. #{unzip(content)}\n2. #{unzip(content, true)}\n"
