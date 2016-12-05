#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(__APPLE__)
#  define COMMON_DIGEST_FOR_OPENSSL
#  include <CommonCrypto/CommonDigest.h>
#  define SHA1 CC_SHA1
#else
#  include <openssl/md5.h>
#endif

// Create a MD5 hash from a string
// inspired from http://stackoverflow.com/a/8389763/2558252
unsigned char* MD5(const char *str, int length) {
  // MD5 context
  MD5_CTX context;

  // Buffer for the md5 digest
  unsigned char* digest = (unsigned char*)malloc(16);

  // Compute the MD5
  MD5_Init(&context);
  MD5_Update(&context, str, length);
  MD5_Final(digest, &context);

  return digest;
}

// Create a string concatenating a base string with an integer
char *generateString(int i){
  // Base string, entry point of the challenge
  char base[] = "uqwqemis";

  // String containing a representation of i
  char increment[128];

  // Will contains the concatenation of the string and the int
  char *buffer = (char*)malloc(256);

  // Convert i into a char, in the increment string
  // May be a faulty operation, as we aren't checking for any boundary ¯\_(ツ)_/¯
  sprintf(increment, "%d", i);

  // Concatenate both strings into the buffer
  snprintf(buffer, 256, "%s%s", base, increment);

  return buffer;
}

int main(int argc, char **argv) {
  // Reference of increment
  int increment = 0;

  // Valid MD5 used for the second password
  int count = 0;

  // Blank passwords
  // blank cells will be checked for non-existing char
  char password[] = "        ";

  // Counter to know when to stop searching for the first password
  int first_password = 0;

  // Position of the curren char, used to cast from hex, into int
  char *position_c = (char *)malloc(2);
  int position;

  // Password char buffer, used to cast from hex
  char *password_buffer = (char *)malloc(2);

  // String to MD5
  char* string;

  // Result of the MD5
  unsigned char* md5;

  // Disable output buffering
  setbuf(stdout, NULL);

  // Will print the first solution char by char
  // and the second at the end
  printf("-> ");

  while (count < 8){

    string = generateString(increment);
    md5 = MD5(string, strlen(string));

    // Check the first 2 chars are '0'
    if (md5[0] == 0 && md5[1] == 0) {

      // If the next char starts with a '0', i.e. is less than 16
      if( md5[2] < 16) {

        // Only print the first password for the first 8 chars
        if (first_password < 8) {

          printf("%x", md5[2]);
          first_password ++;

        }

        // If the char starts with a '0' and must be less than the password last index
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

    // Don't forget to free your memory
    free(string);
    increment ++;

  }

  printf("\n-> %s \n", password);

  return 0;
}
