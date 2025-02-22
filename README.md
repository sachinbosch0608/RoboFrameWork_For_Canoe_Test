# RoboFrameWork_For_Canoe_Test
This Repo is for Robo Framework which is Designed for Vector Canoe Based Testing


#Steps to Create .venv:

	1. python -m venv venv  
	2. This command is for activating venv
	   venv\Scripts\activate
	3. pip install -r requirements.txt
	4. venv\Scripts\deactivate, if work is done.

#Steps to Work with Robot Frame Work Test
    
     1. In General if venv is create Just actiavte the venv
        Using Point number 2 in Above description then choose
        Command for your liking mentioned below
     2. Command to Execute any Test in Robot Framework
        robot File_name.robot
     3. Command to Generate Test Report in specific Folder
        along with Test Execution
        robot -d  DIR-NAME  File_name.robot