from robot.api.deco import library, keyword


@library
class utilities:

    @keyword
    def split_hex_string(self,hex_string, num_bytes):
        # Ensure that the user input corresponds to an even number of hex characters
        # Convert num_bytes to integer if it is a string
        num_bytes = int(num_bytes)
        # Check for a valid hex string and number of bytes
        if len(hex_string) < num_bytes * 2:
            raise ValueError(f"Hex string is too short for {num_bytes} bytes.")
        # Calculate the split index
        split_index = num_bytes * 2

        # Split the string at the given byte index
        part1 = hex_string[:split_index]
        part2 = hex_string[split_index:]

        return part1, part2

    @keyword
    def Hex_to_ASCII_Conversion(self,Hex_Value):
        # Provide Input String By user for ASCII conversion
        response_byte_data = bytes.fromhex(Hex_Value)
        ascii_string = response_byte_data.decode('ascii')

        return ascii_string

    @keyword
    def DTCs_Status_2C_2F(self,input_str):
        # List to store substrings ending with '2c' and '2f'
        list_2c = []
        list_2f = []

        # Split string into 4-byte chunks
        for i in range(0, len(input_str), 8):  # Step by 8 because each 4 bytes = 8 chars in hex
            chunk = input_str[i:i + 8]
            if chunk:  # Make sure chunk is not empty
                # Get last 2 characters (last byte in hex)
                last_byte = chunk[-2:]
                # Sort into appropriate list
                if last_byte == '2c':
                    list_2c.append(chunk)
                elif last_byte == '2f':
                    list_2f.append(chunk)

        return list_2c, list_2f