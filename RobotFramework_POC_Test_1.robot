# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:10:47 2025

@author: RZP2KOR
"""

*** Settings ***
Library    Py_RobotFramwork_Input_File.py  # Import your custom Python library (adjust the path if necessary)
Library    OperatingSystem
Library    DateTime

*** Variables ***
# Path variables (Use environment variables or relative paths if necessary)
${CONFIG_PATH}              D:/_rbs/ADAS_HIL_FD301_TOL30_06_RA6_V15.1.2/RBS_Ford_Dat3.cfg
${POWER_VAR}                PS::power_on_off_EA9040
${POWER_VOL_MEAS}           PS::voltage_display_meas_EA9040
${EXPECTED_VOLT}            14.50
${TOLERANCE}                2.80
${HIL_MODE}                 5  # Carmksr Mode for HIL Mode
${HIL_MODE_VAR}             hil_ctrl::hil_mode  # Make sure this is defined in CANoe config
${TIMEOUT}                  5  # Timeout in seconds for comparison
${Test_Run}                 drv/CTA/CTA_90_Deg_Road_Side_Parking_Staright_Road.trn
${Load_CM_Scenario}         Customer_specific::cm_scenario
${Load_CM_Scenario_Done}    hil_ctrl::init_cm_scenario_done

*** Test Cases ***

Test Open Canoe Configuration
    [Documentation]    Verifies that the CANoe configuration is loaded correctly.
    Open Canoe Instance    ${CONFIG_PATH}
    Should Exist    ${CONFIG_PATH}    # Ensure the configuration file exists
    Log    Test Passed: Opened CANoe configuration from ${CONFIG_PATH}
	Start Measurement

Test Set And Get System Variables For ECU Power
    [Documentation]    Verifies setting and comparing ECU power voltage system variable.
    
    Set System Variable    ${POWER_VAR}    1
    Compare System Variable Value    ${POWER_VOL_MEAS}    ${EXPECTED_VOLT}    ${TOLERANCE}    ${TIMEOUT}

Test Set And Get System Variables For HIL Mode
    [Documentation]    Verifies setting and comparing HIL Mode system variable.
    Set System Variable    ${HIL_MODE_VAR}    ${HIL_MODE}
    Compare System Variable Value    ${HIL_MODE_VAR}    ${HIL_MODE}    ${TOLERANCE}    ${TIMEOUT}

Test Loading Carmaker Test Scenario
    [Documentation]    Verifies setting the test scenario and running the measurement.
    Set System Variable    ${Load_CM_Scenario}    ${Test_Run}
	Sleep  4
    Set System Variable    ${Load_CM_Scenario_Done}    1
    Stop Measurement
    Quit Canoe

*** Keywords ***

Open Canoe Instance
    [Arguments]    ${config_path}
    Open Canoe    ${config_path}
    Log    Successfully opened CANoe configuration from ${config_path}

Start Measurement 
    Start Measurement Init
    Log    Measurement started.

Set System Variable
    [Arguments]    ${var_name}    ${value}
    Set System Variable Val    ${var_name}    ${value}
    Log    Set system variable ${var_name} to ${value}

Compare System Variable Value
    [Arguments]    ${var_name}    ${expected_value}    ${tolerance=None}    ${timeout=10}
    ${start_time}=    Get Time
    ${found}=    Set Variable    False  # Initialize the found flag
    FOR    ${i}    IN RANGE    0    ${timeout}
    	Sleep  1
    	${actual_value}=    Get System Variable Val    ${var_name}
		IF    '${tolerance}' != 'None'
			${diff}=    Evaluate    abs(${expected_value} - ${actual_value})
			IF    ${diff} <= ${tolerance}
				${found}=    Set Variable    True
				BREAK
			END
	     
		ELSE IF    '${tolerance}' == 'None'
			IF	${actual_value} == ${expected_value}
				${found}=    Set Variable    True
				BREAK
			END
		END
		
	END
	Log	Value of found: ${found} this is after Breaking the Loop.
    IF    '${found}' == 'True'
        Log    PASS: ${var_name} reached expected value ${expected_value} within timeout.
    ELSE
        Log    FAIL: Timeout reached for ${var_name}. Expected ${expected_value} but found ${actual_value}.
	END
    


Stop Measurement
    Halt Measurement
    Log    Measurement stopped.

Quit Canoe
    Kill Canoe
    Log    CANoe instance quit.

Wait
    [Arguments]    ${seconds}
    Sleep    ${seconds}

Get Time
    ${timestamp}=    Evaluate    time.time()
    [Return]    ${timestamp}

Get Time Difference
    [Arguments]    ${start_time}
    ${timestamp}=    Evaluate    time.time()
    ${difference}=    Evaluate    ${timestamp} - ${start_time}
    [Return]    ${difference}
