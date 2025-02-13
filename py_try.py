from py_canoe import CANoe, wait

canoe_inst = CANoe()

canoe_inst.open(canoe_cfg=r'D:\_rbs\ADAS_HIL_FD301_TOL1_1_0_RA6_V15.1.3\RBS_Ford_Dat3.cfg')
canoe_inst.start_measurement()
wait(2)
canoe_inst.start_measurement()
wait(5)
canoe_inst.set_system_variable_value('DS2824::IO_1_Switch',1)
wait(5)
#canoe_inst.execute_all_test_modules_in_test_env(demo_test_environment)
canoe_inst.execute_test_module('Test_Robo_Connect_Xcp')
#canoe_inst.set_system_variable_value('Obejct_Vehicle_Speed::Target_Veh_2',1.0)
wait(25)
canoe_inst.execute_test_module('Test_Robo_Disconnect_Xcp')
#canoe_inst.stop_measurement()