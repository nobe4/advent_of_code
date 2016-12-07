#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#if defined(__APPLE__)
#  define COMMON_DIGEST_FOR_OPENSSL
#  include <CommonCrypto/CommonDigest.h>
#else
#  include <openssl/md5.h>
#endif

// Create a MD5 hash from a string
// inspired from http://stackoverflow.com/a/8389763/2558252
void MD5(const char *str, int length, unsigned char *digest) {
  // MD5 context
  MD5_CTX context;

  // Compute the MD5
  MD5_Init(&context);
  MD5_Update(&context, str, length);

  // Put the result in digest
  MD5_Final(digest, &context);
}

// Create a string concatenating a base string with an integer
// apply MD5 over it
void generate_MD5(int i, char* buffer, unsigned char *md5){

  // Base string, entry point of the challenge
  char base[] = "uqwqemis";

  // String containing a representation of i
  char increment[12];

  // Convert i into a char, in the increment string
  // May be a faulty operation, as we aren't checking for any boundary ¯\_(ツ)_/¯
  sprintf(increment, "%d", i);

  // Concatenate both strings into the buffer
  snprintf(buffer, 32, "%s%s", base, increment);

  MD5(buffer, strlen(buffer), md5);
}

int main(int argc, char **argv) {
  // Reference of increment
  uint32_t increment = 0;

  // Valid MD5 used for the second password
  unsigned int count = 0;

  // Blank passwords
  // blank cells will be checked for non-existing char
  char password[] = "        ";

  // Counter to know when to stop searching for the first password
  unsigned int first_password = 0;

  // Position of the curren char, used to cast from hex, into int
  char *position_c = (char *)malloc(2);
  int position;

  // Password char buffer, used to cast from hex
  char *password_buffer = (char *)malloc(2);

  // String to MD5
  char* string;

  // Buffer for the concatenation of the base string and the increment
  // Will contains the concatenation of the string and the int
  char *buffer = (char*)malloc(32);

  // Buffer for the md5 digest
  unsigned char* md5 = (unsigned char *)malloc(16);

  // Disable output buffering
  setbuf(stdout, NULL);

  // Will print the first solution char by char
  // and the second at the end
  printf("-> ");

  while (count < 8){

    // Generate the MD5 for the current increment
    generate_MD5(increment, buffer, md5);

    // Check the first 2 chars are '0'
    if (md5[0] == 0 && md5[1] == 0) {

      // If the next char starts with a '0', i.e. is less than 16
      if( md5[2] < 16) {

        // Only print the first password for the first 8 chars
        if (first_password < 8) {

          printf("%x", md5[2]);
          first_password ++;

        }

        // If the char starts with a '0' and is less than the password last index
        if (md5[2] < 8) {

          // Cast the position of the next char from the 3rd hex char
          snprintf(position_c, 2, "%x", md5[2]);
          position = position_c[0] - '0';

          // Set only empty cells in the password string
          if (password[position] == ' '){

            // md5[3]/16 keeps only the first byte in the hex representation:
            // 12 -> 01
            // ab -> 0a
            // Cast the char into the password buffer
            snprintf(password_buffer, 2, "%x", md5[3]/16);

            // Assign the newly found char in the password string
            password[position] = password_buffer[0];

            count ++;
          }

        }

      }

    }

    increment ++;

  }

  printf("\n-> %s \n", password);

  // Don't forget to free your memory
  free(buffer);
  free(md5);
  free(position_c);
  free(password_buffer);

  return 0;
}
