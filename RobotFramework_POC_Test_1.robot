# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:10:47 2025

@author: RZP2KOR
"""

*** Settings ***
Library    ./Lib_Files/Py_RobotFramwork_Input_File.py  # Import your custom Python library (adjust the path if necessary)
Library    OperatingSystem
Library    DateTime

*** Variables ***
# Path variables (Use environment variables or relative paths if necessary)
${CONFIG_PATH}                  D:/_rbs/ADAS_HIL_FD301_TOL1_1_0_RA6_V15.1.3/RBS_Ford_Dat3.cfg
${POWER_VAR}                    DS2824::IO_1_Switch
${POWER_VOL_MEAS}               PS::voltage_display_meas_EA9040
${EXPECTED_VOLT}                14.50
${TOLERANCE}                    2.80
${HIL_MODE}                     4  # Carmksr Mode for HIL Mode
${HIL_MODE_VAR}                 hil_ctrl::hil_mode  # Make sure this is defined in CANoe config
${TIMEOUT}                      5  # Timeout in seconds
${TIMEOUT_For_Compare}          20  # Timeout for Comparsion value check
${TEST_RUN}                     drv/SOD/CTX/CTA_90_Deg_Road_Side_Parking_Staright_Road.trn
${Hil_Config_Mode}              hil_ctrl::configuration_ford
${Load_CM_Scenario}             Customer_specific::cm_scenario
${Load_CM_Scenario_Done}        Customer_specific::load_scenario
${Carmake_Scenario_Start}       hil_ctrl::scenario_start
${Carmaker_Running_State}       CarMaker::SC::State
${Stop_CM_Button}               Customer_specific::cm_stopsim
${KEY_NAME_ENTER}               enter
${KEY_NAME_RIGHT}               right
${None}                         None
${RED}                          #FF0000
${Radar_Fc_loc_Sim}             hil_ctrl::radar_fc_loc_sim
${Radar_Fl_loc_Sim}             hil_ctrl::radar_fl_loc_sim
${Radar_Fr_loc_Sim}             hil_ctrl::radar_fr_loc_sim
${Radar_rl_loc_Sim}             hil_ctrl::radar_rl_loc_sim
${Radar_rr_loc_Sim}             hil_ctrl::radar_rr_loc_sim
${EGO_VEHICLE_SPEED_VAR}        hil_drv::target_velocity
${EGO_VEHICLE_STATUS_VAR}       hil_drv::target_velocity_status
${READ_EGO_VEHICLE_SPEED}       hil_hvm::velocity_x
${Ego_Gear_Req}                 hil_adas::gear_req
${TARGET_VEHICLE_OBJ_0}         Obejct_Vehicle_Speed::Target_Veh_0
${TARGET_VEHICLE_OBJ_0_STS}     Obejct_Vehicle_Speed::Target_Veh_Status_0
${READ_TARGET_VEHICLE_OBJ_0}    Obejct_Vehicle_Speed::Target_Veh_Speed_Read_0
${TARGET_VEHICLE_OBJ_1}         Obejct_Vehicle_Speed::Target_Veh_1
${TARGET_VEHICLE_OBJ_1_STS}     Obejct_Vehicle_Speed::Target_Veh_Status_1
${READ_TARGET_VEHICLE_OBJ_1}    Obejct_Vehicle_Speed::Target_Veh_Speed_Read_1
${Test_Connect_Xcp}             Test_Robo_Connect_Xcp
${Test_Disonnect_Xcp}           Test_Robo_Disconnect_Xcp
${Test_Connect_Xcp_Sts}         Obejct_Vehicle_Speed::XCP_Connection_Success
${Test_Disonnect_Xcp_Sts}       Obejct_Vehicle_Speed::XCP_Connection_Failed
${Counter}                      0



# CTA Test Related XCP Variables
${TA_CTA_TTX_Right_ve}          XCP::APU::ActivityPostProc_activity::g_fifaThreatAssessmentIn::m_fifaThreatAssessmentDataOutput::m_fifaThreatAssessmentCtaOutput::TA_CTA_TTX_Right_ve
${TA_CTA_ThreatConfRight_ve}    XCP::APU::ActivityPostProc_activity::g_fifaThreatAssessmentIn::m_fifaThreatAssessmentDataOutput::m_fifaThreatAssessmentCtaOutput::TA_CTA_ThreatConfRight_ve


*** Test Cases ***

Test Open Canoe Configuration
    [Documentation]    Verifies that the CANoe configuration is loaded correctly.
    Open Canoe Instance    ${CONFIG_PATH}
    Should Exist    ${CONFIG_PATH}    # Ensure the configuration file exists
    Log    Test Passed: Opened CANoe configuration from ${CONFIG_PATH}
	Start Measurement
	Sleep     5 
	Start Measurement

Test Set And Get System Variables For ECU Power
    [Documentation]    Verifies setting and comparing ECU power voltage system variable.
    # Setting Power VAR to 1 for Switch ON Power Supply
    Set System Variable    ${POWER_VAR}    1
    Compare System Variable Value    ${POWER_VOL_MEAS}    ${EXPECTED_VOLT}    ${TOLERANCE}    ${TIMEOUT}

Test Set Hil Config and Radar States
    [Documentation]    Verifies setting of Hil_Config to DRV_STD And Radar to Simulated state.
    # Setting HIL Config to DRV STD mode value 3
    Set System Variable    ${Hil_Config_Mode}    3
    Compare System Variable Value    ${Hil_Config_Mode}    3    ${None}    ${TIMEOUT}

    # Setting Radar 4 Corner Radars to Simulated state value 1

    Set System Variable    ${Radar_Fc_loc_Sim}    0
    Set System Variable    ${Radar_Fl_loc_Sim}    1
    Set System Variable    ${Radar_Fr_loc_Sim}    1
    Set System Variable    ${Radar_rl_loc_Sim}    1
    Set System Variable    ${Radar_rr_loc_Sim}    1

    Compare System Variable Value    ${Radar_Fc_loc_Sim}    0    ${None}    ${TIMEOUT}
    Compare System Variable Value    ${Radar_Fl_loc_Sim}    1    ${None}    ${TIMEOUT}
    Compare System Variable Value    ${Radar_Fr_loc_Sim}    1    ${None}    ${TIMEOUT}
    Compare System Variable Value    ${Radar_rl_loc_Sim}    1    ${None}    ${TIMEOUT}
    Compare System Variable Value    ${Radar_rr_loc_Sim}    1    ${None}    ${TIMEOUT}


Test Set And Get System Variables For HIL Mode
    [Documentation]    Verifies setting and comparing HIL Mode system variable.
    Set System Variable    ${HIL_MODE_VAR}    ${HIL_MODE}
    Compare System Variable Value    ${HIL_MODE_VAR}    ${HIL_MODE}    ${TOLERANCE}    ${TIMEOUT}
    Sleep    20        #Ensure that all the Test Runs gets copied to shared location in VT bench

Test XCP Connect And Loading Carmaker Test Scenario
    [Documentation]    Verifies setting the test scenario and running the measurement.
    XCP Connect            ${Test_Connect_Xcp}        # Calling For XCP connection in Canoe
    Compare System Variable Value       ${Test_Connect_Xcp_Sts}     1     ${None}     2     # Checking XCP Connection status
    Set System Variable    ${Load_CM_Scenario}    ${TEST_RUN}
	Sleep     5            # Allow some dealy to load .trn and enable system var for load scenario
    Set System Variable    ${Load_CM_Scenario_Done}    1

  # Sleep     2
  # Quit Canoe
  #  Sleep     2

Test To Set EGO and Target Vehicle Speed
    [Documentation]    Verifies the Speed of EGO Vehicle and Target Vehicle.
    Set System Variable    ${EGO_VEHICLE_SPEED_VAR}    0.0      # Host Vehicle in Standstill state, thus setting speed as 0.0 km/h
    Set System Variable    ${EGO_VEHICLE_STATUS_VAR}      1
    Set System Variable    ${TARGET_VEHICLE_OBJ_0}     36.0     # Setting Target OBJ_0 to 36 km/h
    Set System Variable    ${TARGET_VEHICLE_OBJ_1}     36.0     # Setting Target OBJ_0 to 36 km/h
    Set System Variable    ${TARGET_VEHICLE_OBJ_0_STS}      1
    Set System Variable    ${TARGET_VEHICLE_OBJ_1_STS}      1
	Set System Variable    ${Ego_Gear_Req}     1     # Setting Reverse Gear
	Sleep     1
    Set System Variable    ${Carmake_Scenario_Start}    1
	Sleep     3

Test CTA Feature Activation From Right Hand Side
    [Documentation]    Verifies the CTA Feature Activation From Left hand Side RQM ID <a href="https://rb-alm-13-p.de.bosch.com/qm/web/console/Ford_DAT3%20(qm)#action=com.ibm.rqm.planning.home.actionDispatcher&subAction=viewTestCase&id=2818879">.
    [Tags]    TC-2818879
    Compare System Variable Value     ${READ_EGO_VEHICLE_SPEED}     0.0     0.2     ${TIMEOUT}
    Compare System Variable Value     ${READ_TARGET_VEHICLE_OBJ_0}     35.80     0.30     12
    Compare System Variable Two Values in AND Condition   ${TA_CTA_TTX_Right_ve}   0.10   ${TA_CTA_TTX_Right_ve}   3.00     20
    Check Value Valid    ${TA_CTA_ThreatConfRight_ve}     ${TA_CTA_TTX_Right_ve}   0.8    1    6

Test Post Condition
    [Documentation]    Verifies the Speed of EGO Vehicle and Target Vehicle.
    Compare System Variable Value      ${Carmaker_Running_State}    2   ${None}    60       # Here Value 2 is Carmaker Idle state
    Set System Variable    ${Stop_CM_Button}       1
    Sleep    3
    XCP Disconnect    ${Test_Disonnect_Xcp}
    Compare System Variable Value    ${Test_Disonnect_Xcp_Sts}    1     ${None}    ${TIMEOUT}
    Sleep    3
    #Stop Measurement


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
    [Arguments]    ${var_name}    ${expected_value}    ${tolerance}     ${TIMEOUT_For_Compare}
   # ${start_time}=    Get Time
   # Log    Time stamp where system var value start logging:  ${start_time}
    ${found}=    Set Variable    False  # Initialize the found flag
    FOR    ${i}    IN RANGE    0    ${TIMEOUT_For_Compare}
    	Sleep  1
    	${actual_value}=    Get System Variable Val    ${var_name}
		IF    '${tolerance}' != '${None}'
			${diff}=    Evaluate    abs(${expected_value} - ${actual_value})
			IF    '${diff}' <= '${tolerance}'
				${found}=    Set Variable    True
				#${end_time}=    Get Time Difference    ${start_time}
				#Log    lapsed when Condition Met:    ${end_time}
				BREAK
			END
	     
		ELSE IF    '${tolerance}' == '${None}'
			IF	'${actual_value}' == '${expected_value}'
				${found}=    Set Variable    True
				#${end_time}=    Get Time Difference    ${start_time}
				#Log    lapsed when Condition Met:    ${end_time}
				BREAK
			END
		END
		
	END
	Log	Value of found: ${found} this is after Breaking the Loop.
    IF    '${found}'== 'True'
        Log    PASS: ${var_name} reached expected value ${expected_value} within timeout, found Actual value ${actual_value}
    ELSE
        Log    FAIL: Timeout reached for ${var_name}. Expected ${expected_value} but found Actual value ${actual_value}
        Should Be True    ${found}   Ooops there is Failure !!! Check the Log Section for Values....
	END
    
Check Value Valid
    [Arguments]     ${sys_var_Background_Check}     ${Determined_sys_var_val}    ${expected_value}    ${backgound_check_value}   ${Wait_Time_Expected}
    # Pass Value argument "expected_value" for Determined_sys_var_val and backgound_check_value or Value Valid Condition for sys_var_Background_Check
    # Break Time is for how long user want to check Value Valid Condition
   # ${start_time}=    Get Time
   # Log    Time stamp where system var value start logging:  ${start_time}
    # Getting Sys Var value for Background check variable "Value Valid Operation"
    ${actual_value_background_check}=    Get System Variable Val    ${sys_var_Background_Check}
    ${actual_value_Determined_Var}=    Get System Variable Val    ${Determined_sys_var_val}
    ${actual_value_background_check_Prinatable}=   Set Variable   ${actual_value_background_check}  # To store temp Background Value
    ${actual_value_Determined_Var_Printable}=      Set Variable   ${actual_value_Determined_Var}
    WHILE    ${actual_value_background_check} == ${backgound_check_value}
        ${actual_value_background_check}=    Get System Variable Val    ${sys_var_Background_Check}
        # Getting Sys Var Value check for Determind Var
        ${actual_value_Determined_Var}=    Get System Variable Val    ${Determined_sys_var_val}
        Sleep    1
        Log    Value of Value Valid Variable ${sys_var_Background_Check} is : ${actual_value_background_check}
        # Check if Determined_sys_var_val is the expected value within the loop
        IF    '${actual_value_Determined_Var}' > '${expected_value}'
              Log    Found the value!. ${Determined_sys_var_val} Result: ${actual_value_Determined_Var}
        ELSE
              Log    Found the value!. ${Determined_sys_var_val} Result: ${actual_value_Determined_Var}
              BREAK
        END
    END
    ${Var_iter}   Set Variable     0
    # Wait time Expected is for checking timeout even after Determined conditon arivied still user need some time to achieve Back Ground Check to be true.
    WHILE    ${Var_iter} <= ${Wait_Time_Expected}
            Sleep    0.20
            ${actual_value_background_check}=    Get System Variable Val    ${sys_var_Background_Check}
            ${actual_value_Determined_Var}=    Get System Variable Val    ${Determined_sys_var_val}
            ${Var_iter}  Evaluate    ${Var_iter} + 1
             IF    '${actual_value_background_check}' != '${backgound_check_value}'
                 IF    '${actual_value_Determined_Var}' < '${expected_value}'
                      Log    PASS: Achieved ${sys_var_Background_Check} Expectd Value ${backgound_check_value} Against Actual Value ${actual_value_background_check_Prinatable}
                      Log    PASS: When ${Determined_sys_var_val} Value is Greater than ${actual_value_Determined_Var_Printable}
                      Log    PASS: ${Determined_sys_var_val} reached less than expected ${expected_value} when ${sys_var_Background_Check} value is Not ${backgound_check_value}
                      Log    PASS: And Found Value is ${actual_value_Determined_Var} for ${Determined_sys_var_val} When coming out of Loop
                      Log    PASS: And Found Value for ${sys_var_Background_Check} is ${actual_value_background_check}
                      ${found}=    Set Variable    True
                      BREAK
                 END
             ELSE
                Log    FAIL: Timeout reached for ${Determined_sys_var_val} Expected ${expected_value} but found ${actual_value_Determined_Var}
                Log    FAIL: Where ${sys_var_Background_Check} Expected Value is ${backgound_check_value} but Found Value is ${actual_value_background_check}
                ${found}=    Set Variable    False
             END
    END
    IF    '${found}' == 'False'
         Log    FAIL: Timeout reached for ${Determined_sys_var_val} Expected ${expected_value} but found ${actual_value_Determined_Var}
         Log    FAIL: Where ${sys_var_Background_Check} Expected Value is ${backgound_check_value} but Found Value is ${actual_value_background_check}
         Should Be True    ${found}   Ooops there is Failure !!! Check the Log Section for Values....
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
    ${timestamp}=    Evaluate    datetime.now()
    [Return]    ${timestamp}

Get Time Difference
    [Arguments]    ${start_time}
    ${timestamp}=    Evaluate    datetime.now()
    ${difference}=    Evaluate    ${timestamp} - ${start_time}
    [Return]    ${difference}

Set Key Press
    [Arguments]    ${key_name}
    Press Keyboard Key    ${key_name}
    Log    Press Keyboard Key    ${key_name} to ${key_name}

XCP Connect
    [Arguments]    ${capl_test_module}
    Call Xcp Connection    ${capl_test_module}
    Log    XCP Connection Called Sucessfully


XCP Disconnect
    [Arguments]    ${capl_test_module}
    Call Xcp Connection    ${capl_test_module}
    Log    XCP Disconnection Called Sucessfully


Compare System Variable Two Values in AND Condition
     [Arguments]    ${var_name_1}    ${expected_value_1}    ${Var_Name_2}   ${expected_value_2}    ${TIMEOUT_For_Compare}
     #${start_time}=    Get Time
       # Log    Time stamp where system var value start logging:  ${start_time}
        ${found}=    Set Variable    False  # Initialize the found flag
        FOR    ${i}    IN RANGE    0    ${TIMEOUT_For_Compare}
            Sleep  1
            ${actual_value_1}=    Get System Variable Val    ${var_name_1}
            ${actual_value_2}=    Get System Variable Val    ${Var_Name_2}
            IF    '${actual_value_1}' >= '${expected_value_1}'
                IF    '${actual_value_2}' <= '${expected_value_2}'
                       ${found}=    Set Variable    True
                   # ${end_time}=    Get Time Difference    ${start_time}
                   # Log    lapsed when Condition Met:    ${end_time}
                       BREAK
                END
            END
        END
        Log	Value of found: ${found} this is after Breaking the Loop.
        IF    '${found}' == 'True'
            Log    PASS: ${var_name_1} reached expected value ${expected_value_1} within timeout,found Actual Value ${actual_value_1} 
            Log    PASS: ${Var_Name_2} reached expected value ${expected_value_1} within timeout,found Actual Value ${actual_value_2}
        ELSE
            Log    FAIL: Timeout reached for ${var_name_1} and ${var_name_2} Expected ${expected_value_1} and ${expected_value_2}but found Actual Values ${actual_value_1} and ${actual_value_2}
            Should Be True    ${found}   Ooops there is Failure !!! Check the Log Section for Values....
        END
