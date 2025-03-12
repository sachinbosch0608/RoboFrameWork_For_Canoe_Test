# -*- coding: utf-8 -*-
"""
Created on Tue Mar 11 13:53:30 2025

@author: RZP2KOR
"""

import udsoncan
from udsoncan.client import Client
from udsoncan.connections import DoIPSocketConnection
from udsoncan.configs import default_client_config
import logging

# Set up logging to see debug information
logging.basicConfig(level=logging.DEBUG)

# Define DoIP connection parameters
doip_ip_address = '192.168.0.10'  # Replace with the ECU's IP address
doip_port = 13400                 # Default DoIP port
logical_address = 0x0E80          # Logical address of the ECU (replace with your ECU's address)
client_address = 0x0E00           # Logical address of the client (tester)

# Create a DoIP connection
connection = DoIPSocketConnection(ip=doip_ip_address, port=doip_port, logical_address=logical_address, client_address=client_address)

# Create a UDS client
client = Client(connection, config=default_client_config)

# Connect to the ECU
client.connect()

try:
    # Send the ECU Hard Reset request (0x1101)
    response = client.ecu_reset(reset_type=0x01)  # 0x01 is the sub-function for hard reset

    # Check the response
    if response.positive:
        print("ECU Hard Reset successful!")
        print(f"Response data: {response.data}")
    else:
        print("ECU Hard Reset failed.")
        print(f"Negative response code: {response.code}")

    # Read Data by Identifier (DID F188)
    did_f188 = 0xF188  # Replace with the DID you want to read
    response = client.read_data_by_identifier(did_f188)

    # Check the response
    if response.positive:
        print(f"Read Data by Identifier (DID F188) successful!")
        print(f"Response data: {response.data}")
    else:
        print("Read Data by Identifier (DID F188) failed.")
        print(f"Negative response code: {response.code}")

except Exception as e:
    print(f"An error occurred: {e}")

finally:
    # Disconnect from the ECU
    client.disconnect()