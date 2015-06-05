#Tug of War Game Implementation

2 different implementations of Tug of War used on a DE1-SOC FPGA board.

* player v.s. player:	where 2 players can press key[3] and/or key[0] to move middle LEDR,
						when light ends up in one side of the FPGA, declares a winner in HEX.

* player v.s. AI:		where a player can press key to move middle LEDR against a computer.
						Computer difficulty can be adjusted by switches[9:0].

