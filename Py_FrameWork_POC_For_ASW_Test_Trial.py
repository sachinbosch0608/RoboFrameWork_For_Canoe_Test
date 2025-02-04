# -*- coding: utf-8 -*-
"""
Created on Tue Jan 28 12:19:56 2025

@author: RZP2KOR
"""

from py_canoe import CANoe, wait

canoe_inst = CANoe()


######## THIS AREA IS TO START CANOE START MEASUREMENT AND CHECK THE CANOE Version ######

canoe_inst.open(canoe_cfg=r'tests\demo_cfg\demo.cfg')
wait(5)
canoe_inst.start_measurement()
canoe_version_info = canoe_inst.get_canoe_version_info()
#canoe_inst.stop_measurement()
#canoe_inst.quit()



############## This Area is Set and and Check System Variable For PreCondition ############

#### Turn ON Power Supply ####
wait(5)
canoe_inst.set_system_variable_value('PS::power_on_off_EA9040',1)
wait(1)
ECU_Vol=canoe_inst.get_system_variable_value('PS::voltage_display_meas_EA9040')

if abs(14.50-ECU_Vol) <= 2.80:
    
    canoe_inst.write_text_in_write_window("Desired Vol VALUE Recieved on ECU, Check Value in Generated Test REPORT")
    
else:
    
    canoe_inst.write_text_in_write_window("Desired Vol VALUE not Recieved on ECU, Check Value in Generated Test REPORT")
    
    
###### Change HIL_MODE to CarMaker ######

canoe_inst.set_system_variable_value('hil_ctrl::hil_mode',5)
wait(1)
Hil_mode_Value=canoe_inst.get_system_variable_value('hil_ctrl::hil_mode')

if Hil_mode_Value== 5:
    
    canoe_inst.write_text_in_write_window("Desired HIL Mode has been set to Carmaker for Value Check Check Test REPORT")
    
else:
    
    canoe_inst.write_text_in_write_window("Desired HIL Mode has been set to Carmaker for Value Check Check Test REPORT")









################################# Test Report Generation Outputs ###########################################


with open("POC_Test_Report_for_ASW_Test.txt","a") as report_file:
    
    report_file.write(f"ECU Vol VALUE : {ECU_Vol}\n")
    report_file.write(f"HIL mode VALUE as Carmaker- 5: {Hil_mode_Value}\n")
    
    
    
    
################## Stop Measurement and Closing Canoe ####################    

canoe_inst.stop_measurement()
#canoe_inst.quit()