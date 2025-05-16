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
${Binary_Logic_0}               0

${Counter}                      0

# DIAG Related Variables
${Positive_Res}                 OK! Positive response
${Initiate_DOIP_Connection}     DIAG_Tester_uP::DOIP::Connect
${DOIP_DisConnect}              DIAG_Tester_uP::DOIP::Disconnect
${DOIP_Connection_Status}       DIAG_Tester_uP::DOIP::Connect_Status
${Send_Command_Data_uP}         DIAG_Tester_uP::sysDataToTransmit_String
${Recieve_DIAG_RES}             DIAG_Tester_uP::sysDataReceived_String
${Diag_Positive_Response}       DIAG_Tester_uP::sysDataToTransmit_Status
${DID_SW_TAG}                   22f188

# DOOR Loc Test Case Variables

${Some_IP_Init}                SOME_IP_UI_T::Init    # SomeIP initilization

# Reset Var Set
${Ignition_Switch}             SOME_IP_UI_T::Ignition_Switch
${SRS_Deployment}              SOME_IP_UI_T::SRS_Deployment
${Door_Lock_SW}                SOME_IP_UI_T::Door_Lock_SW
${Driver_door_SW}              SOME_IP_UI_T::Driver_door_SW
${Passenger_door_SW}           SOME_IP_UI_T::Passenger_door_SW
${Keyless_Lock_Unlock}         SOME_IP_UI_T::Keyless_Lock_Unlock
${Speed_value}                 SOME_IP_UI_T::Speed_value
${Driver_door_output}          SOME_IP_UI_T::Driver_door_output
${Passenger_door_output}       SOME_IP_UI_T::Passenger_door_output




*** Test Cases ***

Test Open Canoe Configuration
    [Documentation]    Verifies that the CANoe configuration is loaded correctly.
    Open Canoe Instance    ${CONFIG_PATH}
    Should Exist    ${CONFIG_PATH}    # Ensure the configuration file exists
    Log    Test Passed: Opened CANoe configuration from ${CONFIG_PATH}
	Start Measurement
	Sleep     5 
	Start Measurement

Test Initilize SomeIP Check
    [Documentation]  Verify that SomeIP has been initilize 
    
    ${found}=    Set Variable    False  # Initialize the found flag
    #Get Default Value Before Initialization for SomeIP

    ${Def_Someip_Val}=      Get System Variable Val    ${Some_IP_Init}
    Log   ${Some_IP_Init} Value is ${Def_Someip_Val}

    IF    '${Def_Someip_Val}' == '${Binary_Logic_0}'
        Set System Variable    ${Some_IP_Init}   1
    ELSE
        Log   ${Some_IP_Init} is Not Initialize to Value ${Def_Someip_Val}
        Set System Variable    ${Some_IP_Init}   0
        ${found}=    Set Variable    True   # to Check Failure
        Log    oops there is Failure....Please check the Log Above..!!!!!
    END
    Sleep    25

Test Reset to default state
    [Documentation]  Verify all reset to Default Values

    # Setting all the Variable to default Values.
    Log    Setting all the below Variables to Default Values.
    Set System Variable    ${Ignition_Switch}    0
    Set System Variable    ${SRS_Deployment}    0
    Set System Variable    ${Door_Lock_SW}     0
    Set System Variable    ${Driver_door_SW}    0
    Set System Variable    ${Passenger_door_SW}    0
    Set System Variable    ${Keyless_Lock_Unlock}    0
    Set System Variable    ${Speed_value}      0
    Set System Variable    ${Driver_door_output}    2
    Set System Variable    ${Passenger_door_output}    2
    
    Log    Check all the below Variables for Default Values
    
    Compare System Variable Value    ${Ignition_Switch}    0    ${None}    2
    Compare System Variable Value    ${SRS_Deployment}   0    ${None}    2
    Compare System Variable Value    ${Door_Lock_SW}    0    ${None}    2
    Compare System Variable Value    ${Driver_door_SW}    0    ${None}    2
    Compare System Variable Value    ${Passenger_door_SW}    0    ${None}    2
    Compare System Variable Value    ${Keyless_Lock_Unlock}   0    ${None}    2
    Compare System Variable Value    ${Speed_value}   0    ${None}    2
    Compare System Variable Value    ${Driver_door_output}   2    ${None}    2
    Compare System Variable Value    ${Passenger_door_output}  2    ${None}    2

    Sleep    15

Test Precondition check
    [Documentation]  Verify Precondition Check 

    # Set Necessary System Variables
    Log    Keyless_Lock_Unlock to Lock
    Set System Variable    ${Keyless_Lock_Unlock}    1
    Log    Keyless_Lock_Unlock to No action
    Set System Variable    ${Keyless_Lock_Unlock}    0
    Log    Ignition_Switch to On
    Set System Variable    ${Ignition_Switch}    1
    Log    SRS_Deployment to Not activated
    Set System Variable    ${SRS_Deployment}    0
    Log    Door_Lock_SW to No action
    Set System Variable    ${Door_Lock_SW}    0
    Log    Passenger_door_SW to Close
    Set System Variable    ${Passenger_door_SW}    0
    Log    Speed_value to 21kmph
    Set System Variable    ${Speed_value}    21
    Sleep    5

Test Check Sub Test Case 1 Checking Door Output
    [Documentation]  Verify "SRS_Deployment = not deployed,Door_Lock_SW = Lock,Keyless_Lock_Unlock = Lock,Speed_value = 21 kmph"

     # Set System Variables
     Log    SRS_Deployment to Not deployed
     Set System Variable    ${SRS_Deployment}    0
     Log    Door_Lock_SW to Lock
     Set System Variable    ${Door_Lock_SW}    1
     Log    Keyless_Lock_Unlock to Lock
     Set System Variable    ${Keyless_Lock_Unlock}    1
     Log    Speed_value to 21kmph
     Set System Variable    ${Speed_value}    21
     Sleep    15
     # Evaluating actual Ouptut Values Based on the Input values mentioend above
     Compare System Variable Two Values in AND Condition    ${Driver_door_output}    1   ${Passenger_door_output}    1   10

Test Check Sub Test Case 2 Checking Door Output
    [Documentation]  Verify "SRS_Deployment = not deployed,Door_Lock_SW = Lock,Keyless_Lock_Unlock = Lock,Speed_value = 21 kmph"

     # Set System Variables
     Log    SRS_Deployment to deployed
     Set System Variable    ${SRS_Deployment}    1
     Log    Door_Lock_SW to Lock
     Set System Variable    ${Door_Lock_SW}    1
     Log    Keyless_Lock_Unlock to Lock
     Set System Variable    ${Keyless_Lock_Unlock}    1
     Log    Speed_value to 21kmph
     Set System Variable    ${Speed_value}    21
     Sleep    15
     # Evaluating actual Ouptut Values Based on the Input values mentioend above
     Compare System Variable Two Values in AND Condition    ${Driver_door_output}    0   ${Passenger_door_output}    0   10


Test Post Condition
    [Documentation]    Stopping Canoe Measurement
    Sleep    5
    Stop Measurement
    Sleep    5
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