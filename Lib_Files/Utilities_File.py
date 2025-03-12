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