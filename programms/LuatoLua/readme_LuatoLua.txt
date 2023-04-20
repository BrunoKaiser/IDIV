This repository contains scripts to write Lua tree again as Lua table.

1. Tree_LuatoLua_Windows.lua

This Lua script writes the Lua tree contained in this script as a file with a Lua tree in Windows.

2. Tree_LuatoLua_Linux.lua

This Lua script writes the Lua tree contained in this script as a file with a Lua tree in Linux.

3. Tree_console.lua

This script containns a Lua console with a tree output. In this tree Lua chunks and Lua sripts can be executed. The tree can be updated by executing branch nodes.

3.1 Tree_console_output.lua

This script contains the tree of the Tree_console.lua script. This is an example for LuaCOM with Office files.

4.1 input_command_output_tree.lua

This script is a calculation GUI for input data in a tree. The commands are organized as a tree and the output is also a tree.

This scripts contains three trees:
1. input tree with variables defined as variable=value or variabletable={} and leafs with values corresponding to their indices in the table
     Examples for these trees are: 
     input_command_output_tree_input.lua
     input_command_output_tree_internal_interest_rate_input.lua
2. command tree with complex commands as they are used in scripts
     Examples for these trees are: 
     input_command_output_tree_command.lua
     input_command_output_tree_internal_interest_rate_command.lua
3. output tree with the possibility of design the results driven by the commands
     Examples for these trees are: 
     input_command_output_tree_output.lua
     input_command_output_tree_internal_interest_rate_output.lua

Annotation: to use easily the input_command_output_tree_internal_interest_rate_.....lua files please copy input_command_output_tree.lua as input_command_output_tree_internal_interest_rate.lua.

4.2 input_command_output_tree_internal_interest_rate.lua

This script is the graphical interface for 
1. input_command_output_tree_internal_interest_rate_input.lua
2. input_command_output_tree_internal_interest_rate_command.lua
3. input_command_output_tree_internal_interest_rate_output.lua

5. Tree_calculator_with_interests.lua

This script is a GUI with the calculation of interests according to different methods in a tree.

6. reflexive_Tree_calculator_with_interests.lua

This script is a Lua to Lua script but also a reflexive one. Therefore here we see the need for a tree describing github. In a tree we can have this file stored only in one place but referenced in two categories.

This script is a GUI with the calculation of interests according to different methods in a tree.

This tree can be changed easily by GUI application functionalities.

7. input_command_output_tree_MDI_graphics.lua

This script is a calculation and graphics GUI for input data in a tree. The graphical outputs are plots in IUP Lua and matrices in IUP Lua. The commands are organized as a tree and the output is also a tree. The difference to input_command_output_tree.lua is an output designed as an multiple document interface (MDI), i.e. multiple windows output. This allows to build different windows with graphical output driven by the command tree.

This scripts contains three trees:
1. input tree with variables defined as variable=value or variabletable={} and leafs with values corresponding to their indices in the table
     An example for this tree is: 
     input_command_output_tree_MDI_graphics_input.lua
2. command tree with complex commands as they are used in scripts
     An example for this tree is: 
     input_command_output_tree_MDI_graphics_command.lua
3. output tree with the possibility of design the results driven by the commands
     An example for this tree is: 
     input_command_output_tree__MDI_graphics_output.lua

8. ansicht_documentation_tree_balance.lua

This script gives the possibility to analyse a balance of an enterprise. Balance indicators can be calculated. This script is only for analyses. WARNING: with complex programming instable results can be generated. NO WARRANTY for right results is given.

8.1 documentation_tree_balance_active.lua

This script is an example for the active side of the balance.

8.2 documentation_tree_balance_passive.lua

This script is an example for the passive side of the balance.

8.3 documentation_tree_balance_indicators.lua

This script is an example for the calculation of balance indicators.

8.4 tree_cost_distribution.lua

This script calculates the parts on each branch and distributes the value on the root node into the tree nodes


