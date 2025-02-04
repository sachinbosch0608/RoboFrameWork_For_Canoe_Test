# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:09:20 2025

@author: RZP2KOR
"""

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