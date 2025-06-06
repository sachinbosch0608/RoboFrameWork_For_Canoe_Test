# -*- coding: utf-8 -*-
"""
Created on Wed Jan 29 11:10:47 2025

@author: RZP2KOR
"""

*** Settings ***
Library    ../Lib_Files/Py_RobotFramwork_Input_File.py  # Import your custom Python library (adjust the path if necessary)
Library    ../Lib_Files/Utilities_File.py               # Import your custom Python library (adjust the path if necessary)
Library    OperatingSystem
Library    DateTime


*** Variables ***
# Path variables (Use environment variables or relative paths if necessary)
${CONFIG_PATH}                  D:/SaTr/ADAS_HIL_FD301_TOL1_1_0_RA6_V15.1.3/adas_hil/RBS_Ford_Dat3.cfg
${POWER_VAR}                    DS2824::IO_1_Switch
${POWER_VOL_MEAS}               PS::voltage_display_meas_EA9040
${EXPECTED_VOLT}                14.50
${TOLERANCE}                    2.80
${HIL_MODE}                     4  # Carmksr Mode for HIL Mode
${HIL_MODE_VAR}                 hil_ctrl::hil_mode  # Make sure this is defined in CANoe config
${TIMEOUT}                      5  # Timeout in seconds
${TIMEOUT_For_Compare}          20  # Timeout for Comparsion value check
${Hil_Config_Mode}              hil_ctrl::configuration_ford
${Load_CM_Scenario}             Customer_specific::cm_scenario
${Load_CM_Scenario_Done}        Customer_specific::load_scenario
${Carmake_Scenario_Start}       hil_ctrl::scenario_start
${Carmaker_Running_State}       CarMaker::SC::State
${Stop_CM_Button}               Customer_specific::cm_stopsim
${KEY_NAME_ENTER}               enter
${KEY_NAME_RIGHT}               right
${None}                         None
${True_Logic}                   True
${False_Logic}                  False
${RED}                          #FF0000
${Radar_Fc_loc_Sim}             hil_ctrl::radar_fc_loc_sim
${Radar_Fl_loc_Sim}             hil_ctrl::radar_fl_loc_sim
${Radar_Fr_loc_Sim}             hil_ctrl::radar_fr_loc_sim
${Radar_rl_loc_Sim}             hil_ctrl::radar_rl_loc_sim
${Radar_rr_loc_Sim}             hil_ctrl::radar_rr_loc_sim
${Counter}                      0

# DIAG Related Variables
${Positive_Res}                 OK! Positive response
${Initiate_DOIP_Connection}     DIAG_Tester_uC::DOIP::Connect
${DOIP_DisConnect}              DIAG_Tester_uC::DOIP::Disconnect
${DOIP_Connection_Status}       DIAG_Tester_uC::DOIP::Connect_Status
${Send_Command_Data_uC}         DIAG_Tester_uC::sysDataToTransmit_String
${Recieve_DIAG_RES}             DIAG_Tester_uC::sysDataReceived_String
${Diag_Positive_Response}       DIAG_Tester_uC::sysDataToTransmit_Status
${DTC_All_2F_2C_States}         190209

# Comm Related Variables
${BUS_CAN}                      CAN
${Msg_Name_RCMinfor1}           RCMInfo1_CHNL_DAT_CANFD
${Signal_Name_RCMinfo1}         YawRolPtchGrp_Cntr
${Msg_RCMInfo1_Canfd}           CAN_DAT::RCMInfo1_CHNL_DAT_CANFD::RCMInfo1_CHNL_DAT_CANFD_ON_OFF


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

Test Stop Msg and Check Counter Value Freez
    [Documentation]  Verify Specific Message Stop on Bus
    ${found}=    Set Variable    False  # Initialize the found flag
    ${Timeout_For_Check}=    Set Variable   10   # Setting timeout for checking the values for
    # Get Signal Real Value Flowing on BUS before stopping the message
    Log    Check the Signal Value before stopping the message...
    ${Sig_Real_Val}=    Get Signal Value    ${BUS_CAN}    1    ${Msg_Name_RCMinfor1}    ${Signal_Name_RCMinfo1}    ${False_Logic}
    Log  Value for Messsage ${Msg_Name_RCMinfor1} Signal ${Signal_Name_RCMinfo1} is ${Sig_Real_Val}.
    # Set System Var for stopping RCMinfo1 Message on CAN Bus
    Set System Variable    ${Msg_RCMInfo1_Canfd}     0
    # Get Signal Real Value Flowing on BUS
    ${Sig_Real_Val}=    Get Signal Value    ${BUS_CAN}    1    ${Msg_Name_RCMinfor1}    ${Signal_Name_RCMinfo1}    ${False_Logic}
    Log  Value for Messsage ${Msg_Name_RCMinfor1} Signal ${Signal_Name_RCMinfo1} is ${Sig_Real_Val}.
    Sleep  15
    ${Sig_Real_Val_After_Wait}=    Get Signal Value    ${BUS_CAN}    1    ${Msg_Name_RCMinfor1}    ${Signal_Name_RCMinfo1}    ${False_Logic}
    ${Counter}=     Set Variable   0
    Log    Check whether Signal values from a Stopped message on the bus are frozen or not......
     WHILE    ${Counter} <= ${Timeout_For_Check}
           ${Sig_Real_Val}=    Get Signal Value    ${BUS_CAN}    1    ${Msg_Name_RCMinfor1}    ${Signal_Name_RCMinfo1}    ${False_Logic}
           Sleep    1
           IF    ${Sig_Real_Val_After_Wait} == ${Sig_Real_Val}
                Log    Value for Signal ${Signal_Name_RCMinfo1} are ${Sig_Real_Val_After_Wait} and ${Sig_Real_Val}
           ELSE
                Log    Value for Signal ${Signal_Name_RCMinfo1} ${Sig_Real_Val_After_Wait} and ${Sig_Real_Val}
                Should Be True    ${found}   Ooops there is Failure !!! Check the Log Section for Values....
           END
           ${Counter}   Evaluate    ${Counter}+1

     END



Test Initiate DOIP Connection
    [Documentation]    Verifies DOIP Connection status
    # Set DOIP Connection to Default value 0
    Sleep    10
    Set System Variable    ${Initiate_DOIP_Connection}    0
    Sleep    10
    # Connect DOIP
    Set System Variable    ${Initiate_DOIP_Connection}    1
    # Checking DOIP Connection Status 
    Compare System Variable Value    ${DOIP_Connection_Status}    1    ${None}    10


Test Read All DTCs and Segregate it by Status Active
    [Documentation]    Verifies DTCs staus by Active DTCs 2f or History DTCs 2c
    # Send DTC readding by command 190209
    ${found}=    Set Variable    False  # Initialize the found flag
    Sleep    4
    Set System Variable    ${Send_Command_Data_uC}    ${DTC_All_2F_2C_States}
    Log  DID Command ${DTC_All_2F_2C_States} for reading Active and history DTCs
    # Check DIAG Respose Status
    Sleep    10
    ${Ack_RES}=   Get System Variable Val    ${Diag_Positive_Response}
    Log  Ack response ${Ack_RES} for DIAG Request.
    IF    '${Ack_RES}' != '${Positive_Res}'
         Should Be True    ${found}
    END
    # Check DIAG Response Data
    ${DIA_response_in_HEX}=     Get System Variable Val    ${Recieve_DIAG_RES}
    Log  Full DIAG Response is: ${DIA_response_in_HEX}
    #Split the Positive response from Data string
    ${RES_Split_Part_1}     ${RES_Split_Part_2}    Split Hex String    ${DIA_response_in_HEX}    3
    Log  Res_Part1: ${RES_Split_Part_1}
    Log  Res_Part2: ${RES_Split_Part_2}
    #Return 2C and 2F DTCs from DIAG Response
    ${DTC_Resp_2C}  ${DTC_Resp_2F}   DTCs Status 2C 2F    ${RES_Split_Part_2}
    Log    2C DTCs are ${DTC_Resp_2C}
    Log    2F DTCs are ${DTC_Resp_2F}
    # Set System Var for Resuming RCMinfo1 Message on CAN Bus
    Set System Variable    ${Msg_RCMInfo1_Canfd}     1

Test Disconnect DOIP
    [Documentation]  Verify DOIP is Disconnected
    Sleep    5
    Set System Variable    ${DOIP_DisConnect}    0
    Sleep    5
    Set System Variable    ${DOIP_DisConnect}    1
    Sleep    2
    Log    Doip Disconnection Status: ${DOIP_Connection_Status}
    Compare System Variable Value    ${DOIP_Connection_Status}    0    ${None}    10


Test Post Condition
    [Documentation]    Stopping Canoe Measurement
    Sleep    3
    Stop Measurement
    # Sleep     2
    # Quit Canoe
    #  Sleep     2


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

Compare System Var For Negative Cases
     [Arguments]    ${var_name}    ${expected_value}    ${TIMEOUT_For_Compare}
        ${found}=    Set Variable    True  # Initialize the found flag
        ${Counter}   Set Variable     0
        WHILE    ${Counter} <= ${TIMEOUT_For_Compare}
            Sleep    0.50
            ${Get_Actaul}=   Get System Variable Val    ${var_name}
            Log    Value Found for Signal ${var_name} is ${Get_Actaul}
            IF    ${Get_Actaul} == ${expected_value}
                Log    Value Found for Signal ${var_name} is ${Get_Actaul} and Expected Value is ${expected_value}
                ${found}=    Set Variable    False
                BREAK
            END
            ${Counter}   Evaluate    ${Counter}+1
        END
        IF    '${found}' == 'True'
             Log    PASS: Test Pass Siganl ${var_name} Value ${Get_Actaul} has not reached to expectd value ${expected_value}
        ELSE
              Log    Value Found for Signal ${var_name} is ${Get_Actaul} and Expected Value is ${expected_value}
              Should Be True    ${found}    Ooops there is Failure !!! Check the Log Section for Values....
        END