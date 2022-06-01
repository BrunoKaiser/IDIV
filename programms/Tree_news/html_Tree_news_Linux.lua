--This script converts a text file with titles into a tree for news of the days and omits the known news that are known from the convertion done before.

--1. search for the version before
os.execute("ls /mnt/sdcard/Tree/Tree_news/html_tree*.html >/mnt/sdcard/Tree/Tree_news/dir_Tree_news.txt")
dayBefore="00000000"
for line in io.lines("/mnt/sdcard/Tree/Tree_news/dir_Tree_news.txt") do
local dayNumber=line:match("%d+")
if dayNumber and dayNumber~=os.date("%Y%m%d") and dayNumber>dayBefore then dayBefore=dayNumber end
end --for line in io.lines("/mnt/sdcard/Tree/Tree_news/dir_Tree_news.txt") do

--1.1 read html file from convertion before
beforeText={}
for line in io.lines("/mnt/sdcard/Tree/Tree_news/html_tree_" .. dayBefore .. ".html") do
if line:match("<ul><li>.-: .-</li></ul>") then
--print(line:match("<ul><li>.-: (.-)</li></ul>"))
beforeText[line:match("<ul><li>.-: (.-)</li></ul>")]=true
end
end --for line in io.lines("/mnt/sdcard/Tree/Tree_news/html_tree_" .. dayBefore .. ".html") do

--2. build new tree with titles
outputfile_news=io.open("/mnt/sdcard/Tree/Tree_news/html_tree_" .. os.date("%Y%m%d") .. ".html","w")
inputText={}
dateBranch=""
for line in io.lines("/mnt/sdcard/Tree/a.txt") do
if line:match(", %d%d.%d%d.%d%d%d%d.|.%d%d:%d%d.*") then
dateBranchold=dateBranch
lineDate,lineTime,lineTitle=line:match(", (%d%d.%d%d.%d%d%d%d).|.(%d%d:%d%d)(.*)")
dateBranch=lineDate
if dateBranch~=dateBranchold then
inputText[#inputText+1]={branchname=lineDate}
--outputfile_news:write("</li></ul><ul><li> " .. tostring(dateBranch) .. "<br>\n")
end --if dateBranch~=dateBranchold then
if beforeText[lineTitle]==nil then
inputText[#inputText][#inputText[#inputText]+1]= "<ul><li>" ..
                        lineTime .. ": " ..
                        lineTitle .. "</li></ul><br><br>"
end --if line:match("<ul><li>.-: .-</li></ul>") then
end --if line:match(", %d%d.%d%d.%d%d%d%d.|.%d%d:%d%d.*") then
end --for line in io.lines("/mnt/sdcard/Tree/a.txt") do

--3. write html file with tree in right order
for i0=#inputText,1,-1 do
outputfile_news:write("\n\n</li></ul><br><ul><li> " .. 
                tostring(inputText[i0].branchname) .. 
                "<br><br>\n\n")
for i=#inputText[i0],1,-1 do
outputfile_news:write(inputText[i0][i] .. "\n")
end --for i=#inputText[i0],1,-1 do
end --for i0=#inputText,1,-1 do
outputfile_news:close()




