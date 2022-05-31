This repository contains scripts to read the query-SQL statements of a database and their name and build dependencies from query to table and table to query and from query to the parts of the SQL statements

1. SQLtoCSVforLua_Access.lua

The script is written for Access, but the part 3. and 4. can be used for the treatment of other databases with appropriate textfile with names of views and SQL statements

2.1 test.accdb

Test database for SQLtoCSVforLua_Access.lua

2.2 Modul_Formular_TreeView.txt

This text file contains a modul for building a TreeView in Access, editing and writing the output. This can be used in test.accdb for Formular2. The tree can have 12 levels.

3. SQLtoCSVforLua_SQL_List.lua

The script corresponds to the script written for Access part 3. and 4. . Here a textfile with names of views or queries and SQL statements is treated. Another convention as Name: query can be used.

4.  SQLtoCSVforLua_SQL_List.txt

Test data for the script SQLtoCSVforLua_SQL_List.lua.
