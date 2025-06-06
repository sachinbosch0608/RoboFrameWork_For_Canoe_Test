# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:09:20 2025

@author: RZP2KOR
"""

import pyautogui
from py_canoe import CANoe, wait
from robot.api.deco import library, keyword

# Initialize the CANoe instance globally

@library
class Canoelibrary:
    
    canoe_inst = CANoe()

    @keyword
    def open_canoe(self, canoe_cfg):
        """Open CANoe configuration."""
        self.canoe_inst.open(canoe_cfg=canoe_cfg)
        wait(10)

    @keyword
    def start_measurement_Init(self):
        """Start the measurement in CANoe."""
        self.canoe_inst.start_measurement()

    @keyword
    def set_system_variable_val(self, var_name, value):
        """Set a system variable value in CANoe."""
        self.canoe_inst.set_system_variable_value(var_name, value)
        wait(1)
        
    @keyword
    def get_system_variable_val(self, var_name):
        """Get the value of a system variable in CANoe."""
        return self.canoe_inst.get_system_variable_value(var_name)

    @keyword
    def get_signal_value(self, can_bus,channel,message_name,signal_name,raw_value):
        """Get the value of a CAN Signal variable in CANoe."""
        return self.canoe_inst.get_signal_value(can_bus,channel,message_name,signal_name,raw_value)

    @keyword
    def write_to_write_window(self, message):
        """Write a message to the CANoe write window."""
        self.canoe_inst.write_text_in_write_window(message)

    @keyword
    def halt_measurement(self):
        """Stop the measurement in CANoe."""
        self.canoe_inst.stop_measurement()

    @keyword
    def kill_canoe(self):
        """Quit the CANoe environment."""
        self.canoe_inst.quit()

    @keyword
    def call_capl_fun(self,fun_name,*arguments):
        """This is for calling any CAPL Function in Python with required Parameter to that CAPL function"""
        self.canoe_inst.call_capl_function(fun_name,*arguments)

    @keyword
    def call_xcp_connection(self,capl_test_module_name):
        """This Function is for Calling CAPL Test Module and Execute them"""
        self.canoe_inst.execute_test_module(capl_test_module_name)
        wait(5)

    @keyword
    def press_keyboard_key(self, keyname):
        """This function simulates pressing the key from the keyboard."""
        wait(5)
        pyautogui.keyDown(keyname)  # Fixed: add the pyautogui reference
        pyautogui.keyUp(keyname)    # Optionally release the key after pressing
        print(f"Key '{keyname}' has been pressed and released.")




