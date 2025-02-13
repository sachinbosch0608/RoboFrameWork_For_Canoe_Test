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
${CONFIG_PATH}                  D:/_rbs/ADAS_HIL_FD301_TOL30_06_RA6_V15.1.2/RBS_Ford_Dat3.cfg
${POWER_VAR}                    PS::power_on_off_EA9040
${POWER_VOL_MEAS}               PS::voltage_display_meas_EA9040
${EXPECTED_VOLT}                14.50
${TOLERANCE}                    2.80
${HIL_MODE}                     4  # Carmksr Mode for HIL Mode
${HIL_MODE_VAR}                 hil_ctrl::hil_mode  # Make sure this is defined in CANoe config
${TIMEOUT}                      5  # Timeout in seconds for comparison
${TEST_RUN}                     drv/SOD/CTX/CTA_90_Deg_Road_Side_Parking_Staright_Road.trn
${Load_CM_Scenario}             Customer_specific::cm_scenario
${Load_CM_Scenario_Done}        Customer_specific::load_scenario
${Carmake_Scenario_Start}       hil_ctrl::scenario_start
${KEY_NAME_ENTER}               enter
${KEY_NAME_RIGHT}               right
${EGO_VEHICLE_SPEED_VAR}        hil_drv::target_velocity
${EGO_VEHICLE_STATUS_VAR}       hil_drv::target_velocity_status
${READ_EGO_VEHICLE_SPEED}       hil_hvm::velocity_x
${TARGET_VEHICLE_OBJ_0}         Obejct_Vehicle_Speed::Target_Veh_0
${TARGET_VEHICLE_OBJ_0_STS}     Obejct_Vehicle_Speed::Target_Veh_Status_0
${READ_TARGET_VEHICLE_OBJ_0}    Obejct_Vehicle_Speed::Target_Veh_Speed_Read_0
${TARGET_VEHICLE_OBJ_1}         Obejct_Vehicle_Speed::Target_Veh_1
${TARGET_VEHICLE_OBJ_1_STS}     Obejct_Vehicle_Speed::Target_Veh_Status_1
${READ_TARGET_VEHICLE_OBJ_1}    Obejct_Vehicle_Speed::Target_Veh_Speed_Read_1


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
    Sleep    20        #Ensure that all the Test Runs gets copied to shared location in VT bench

Test Loading Carmaker Test Scenario
    [Documentation]    Verifies setting the test scenario and running the measurement.
    Set System Variable    ${Load_CM_Scenario}    ${TEST_RUN}
	Sleep     5         # Allow time to load scenario or Test Run in Carmaker
	Set Key Press   ${KEY_NAME_ENTER}       # This is to enable Load Button in RBS and Backspace is needed to load .trn
	Sleep     3
    Set System Variable    ${Load_CM_Scenario_Done}    1
    Sleep     3
    Set System Variable    ${Carmake_Scenario_Start}    1
    Sleep     3

  #  Sleep     2
  # Quit Canoe
  #  Sleep     2

Test To Set EGO and Target Vehicle Speed
    [Documentation]    Verifies the Speed of EGO Vehicle and Target Vehicle.
    Set System Variable    ${EGO_VEHICLE_SPEED_VAR}    0.0      # Host Vehicle in Standstill state, thus setting speed as 0.0 km/h
    Set System Variable    ${TARGET_VEHICLE_OBJ_0}     36.0     # Setting Target OBJ_0 to 36 km/h
    Set System Variable    ${EGO_VEHICLE_STATUS_VAR}        1
    Set System Variable    ${TARGET_VEHICLE_OBJ_0_STS}      1
    Sleep     3
    Compare System Variable Value     ${READ_EGO_VEHICLE_SPEED}     0.0     0.2     ${TIMEOUT}
    Compare System Variable Value     ${READ_TARGET_VEHICLE_OBJ_0}     36.0     0.3     10
    Sleep     1
    #Stop Measurement

Test CTA Feature Activation
    [Documentation]    Verifies the CTA Feature Activation.


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
    Log    Time stamp where system var value start logging:  ${start_time}
    ${found}=    Set Variable    False  # Initialize the found flag
    FOR    ${i}    IN RANGE    0    ${timeout}
    	Sleep  1
    	${actual_value}=    Get System Variable Val    ${var_name}
		IF    '${tolerance}' != 'None'
			${diff}=    Evaluate    abs(${expected_value} - ${actual_value})
			IF    ${diff} <= ${tolerance}
				${found}=    Set Variable    True
				${end_time}=    Get Time Difference    ${start_time}
				Log    lapsed when Condition Met:    ${end_time}
				BREAK
			END
	     
		ELSE IF    '${tolerance}' == 'None'
			IF	${actual_value} == ${expected_value}
				${found}=    Set Variable    True
				${end_time}=    Get Time Difference    ${start_time}
				Log    lapsed when Condition Met:    ${end_time}
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
    
Check Value Valid
    [Arguments]     ${sys_var_Background_Check}     ${Determined_sys_var_val}    ${expected_value}    ${backgound_check_value}
    # Pass Value argument expected_value for Determined_sys_var_val and backgound_check_value for sys_var_Background_Check
    ${start_time}=    Get Time
    Log    Time stamp where system var value start logging:  ${start_time}
    ${found}=    Set Variable    False  # Initialize the found flag
    # Getting Sys Var value for Background check variable
    ${actual_value_background_check}=    Get System Variable Val    ${sys_var_Background_Check}
    WHILE    ${actual_value_background_check} == ${backgound_check_value}
        ${actual_value_background_check}=    Get System Variable Val    ${sys_var_Background_Check}
        # Getting Sys Var Value check for Determind Var
        ${actual_value_Determined_Var}=    Get System Variable Val    ${Determined_sys_var_val}
        Sleep    1
        # Check if Determined_sys_var_val is the expected value within the loop
        IF    ${actual_value_Determined_Var} == ${expected_value}
              Log    Found the value!. Result: ${actual_value_Determined_Var}
              ${found}=    Set Variable    True  # Set flg to TRUE when Condition met
              BREAK
        END
    END
        IF    '${found}' == 'True'
        Log    PASS: ${Determined_sys_var_val} reached expected value ${expected_value} within ${sys_var_Background_Check} value check and Found Value is ${actual_value_Determined_Var} .
    ELSE
        Log    FAIL: Timeout reached for ${Determined_sys_var_val}. Expected ${expected_value} but found ${actual_value_Determined_Var}.
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

Set Key Press
    [Arguments]    ${key_name}
    Press Keyboard Key    ${key_name}
    Log    Press Keyboard Key    ${key_name} to ${key_name}



