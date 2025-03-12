from py_canoe import CANoe, wait


def split_hex_string(hex_string, num_bytes):
    # Ensure that the user input corresponds to an even number of hex characters
    if num_bytes * 2 > len(hex_string) // 2:
        print("Error: Number of bytes to split is too large for the string.")
        return None, None

    # Calculate the split index
    split_index = num_bytes * 2

    # Split the string at the given byte index
    part1 = hex_string[:split_index]
    part2 = hex_string[split_index:]

    return part1, part2


canoe_inst = CANoe()

canoe_inst.open(canoe_cfg=r'D:\SaTr\ADAS_HIL_FD301_TOL1_1_0_RA6_V15.1.3\adas_hil\RBS_Ford_Dat3.cfg')
canoe_inst.start_measurement()
wait(2)
canoe_inst.start_measurement()
wait(5)
canoe_inst.set_system_variable_value('DS2824::IO_1_Switch',1)
wait(5)
canoe_inst.set_system_variable_value('DIAG_Tester_uP::DOIP::Connect',0)
wait(8)
canoe_inst.set_system_variable_value('DIAG_Tester_uP::DOIP::Connect',1)
wait(10)
canoe_inst.set_system_variable_value('DIAG_Tester_uP::sysDataToTransmit_String','22f188')
wait(5)
Ack_Resp_STS= canoe_inst.get_system_variable_value('DIAG_Tester_uP::sysDataToTransmit_Status')
wait(5)
print(Ack_Resp_STS)
DIA_response_in_HEX = canoe_inst.get_system_variable_value('DIAG_Tester_uP::sysDataReceived_String')
part1, part2 = split_hex_string(DIA_response_in_HEX,3)
print("Part1: ", part1)
print("Part2: ", part2)
response_byte_data= bytes.fromhex(part2)
ascii_string= response_byte_data.decode('ascii')
print("This is SW Tag: ",ascii_string)
