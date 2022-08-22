This repository contains scripts to be able to build SQL statements used in a data base

1. tree_SQL_for_tables_and_views_print.lua

This script print out the SQL statements corresponding to the tables and vies described in the Lua tree. The convention is:

1.a tables are defined with the node "Build tables"
1.a.a the nodes under this node are the names of the tables
1.a.a.a the branches of these nodes are the names of the fields of the tables
1.a.a.a.a the first leafs of these branches are the firmat definition
1.a.a.a.b beginning from the second leaf of these branches are the initialisation data of the table to be inserted

1.b vies are defined with the node "Views"
1.b.a the nodes under this node are the names of the views
1.b.a the branches of the nodes are the tables from which data are selected. They can contain parts of statements to build the joins ofcthe tables
1.b.a.a the leafs of these branches are the fields selected from the tables
