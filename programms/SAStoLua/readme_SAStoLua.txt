This repository contains scripts for documenting SAS programms

1. SAS_Analyser.lua

This programm collect data from a SAS programm and sub programms of it in a recursive manner to show in a tree the variables used.

2.1 SAS_Searcher.lua

This programm collect data from SAS programms and their sub programms in a recursive manner to show in a tab tree results of a search of standardized lines.

2.2 SAS_Searcher_more_includes.lua

This programm collect data from SAS programms and their sub programms in a recursive manner to show in a tab tree results of a search of standardized lines. The difference to SAS_Searcher.lua is that there can be more than one include file in one include statement.

3. SAS_Searcher_more_includes_context.lua

This programm collect data from SAS programms and their sub programms in a recursive manner. There can be more than one include file in one include statement. It shows dependencies of variables and macro variables to build a tree of dependent variables with side effects.


4. SAS_include_proc_Lua.sas

This SAS programm contains a Lua script. This Lua script collects the macro variables as needed for Lua replacement.

5. SAS_data_flows.lua

This programm collects data from a SAS programm to show the data flows, i.e. input and output tables
