import java.util.Scanner;

public class CaesarCipher {
    public static void main(String[] args) {
        Scanner scan = new Scanner(System.in);

        // Obtain the message and offset from the user
        System.out.println("Please input message: ");
        String message = scan.nextLine();
        System.out.println("Please input offset number for Caesar cipher: ");
        int offset = scan.nextInt();

        // Encrypt the message
        String cipherMessage = encrypt(message, offset);

        // Display the results
        System.out.println("Original message: " + message);
        System.out.println("Encrypted message: " + cipherMessage);
    }

    // Method to encrypt the message using Caesar cipher
    public static String encrypt(String message, int offset) {
        StringBuilder result = new StringBuilder();

        for (char ch : message.toCharArray()) {
            if (Character.isLetter(ch)) {
                char encryptedChar = (char) ('a' + (ch - 'a' + offset) % 26);
                result.append(encryptedChar);
            } else {
                result.append(ch);
            }
        }

        return result.toString();
    }
}
