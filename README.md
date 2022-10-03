This project contains files that read in numerical values from a 16 character button pad. The code was
intended to interface with the Nexys4 DDR board by Xilinx. I designed the code to work similar to 2 nested statemachines

The .vhd Files correspond to the multiple source files that are linked as modules
The .xdc file is the constraint file used to allow axcess to the reset button and the LED's on the Nexys 4

The second picture shows the flag varible state machine logic, and the first pictures shows the two state machines for
storing and checking the users input.

![Statemachine 1](https://user-images.githubusercontent.com/95510080/144690329-31049d88-5961-4dd2-8f97-ec3133fb3234.jpg)
![Statemachine 2](https://user-images.githubusercontent.com/95510080/144690331-49d5ee0a-95df-4647-a521-ef5b3727a0b4.jpg)

