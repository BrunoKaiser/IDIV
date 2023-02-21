# This PowerShell script shows an individual tree and a tree with folders and files

$RootFolder='C:\Temp'

$subnodeNodeTable = @{
    'Erklärung' = 'Unterknoten'
    'Beef' = 'Unterknoten'
    'Green Beans' = 'Unterknoten'
    'Carrots' = 'Orange'
    'Brussel Sprouts' = 'Ein neuer Knoten'
}
$subnodeNodeTable | ForEach-Object { $_ }


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$Form = New-Object System.Windows.Forms.Form

function Add-SubNode {
        param (
            [System.Windows.Forms.TreeNode]$parentNode, 
            [string]$childNodeText
        )
		$subnode      = New-Object System.Windows.Forms.TreeNode
		$subnode.Text = $childNodeText
		[void]$parentNode.Nodes.Add($subnode)
}

function Add-NodeToRoot {
        param (
            [System.Windows.Forms.TreeNode]$parentNode, 
            [string]$childNodeText
        )
		$subnode      = New-Object System.Windows.Forms.TreeNode
		$subnode.Text = $childNodeText
		[void]$parentNode.Nodes.Add($subnode)
		if ($childNodeText -eq "Ein neuer Knoten") { 
			Write-Output "The condition was true" 
			Add-NodeToRoot $subnode "https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-if?view=powershell-7.3"  
		}
		
		$subnodeNodeTable.GetEnumerator() | ForEach-Object { 
			if ($childNodeText -eq $_.Value) { 
				Add-SubNode $subnode $_.Key }
		}
}

$Form.Text = "Folders"
$Form.Size = New-Object System.Drawing.Size(690, 450)
$TreeView = New-Object System.Windows.Forms.TreeView
$TreeView.Location = New-Object System.Drawing.Point(48, 12)
$TreeView.Size = New-Object System.Drawing.Size(290, 322)
$Form.Controls.Add($TreeView)
$rootnode = New-Object System.Windows.Forms.TreeNode
$rootnode.Text ="https://stackoverflow.com/questions/59837832/powershell-list-all-folder-and-subfolders-in-treeview-gui-element"
$rootnode.Name = "Root"
[void]$TreeView.Nodes.Add($rootnode)
$rootnode.Expand()
Add-NodeToRoot $rootnode "Unterknoten"
Add-NodeToRoot $rootnode "https://blog.ironmansoftware.com/daily-powershell/powershell-out-tree-view/"
Add-NodeToRoot $rootnode "Ein neuer Knoten"
Add-NodeToRoot $rootnode "https://4sysops.com/archives/read-all-items-in-a-powershell-hash-table-with-a-loop/"
Add-NodeToRoot $rootnode "https://stackoverflow.com/questions/59883652/searching-between-treeview-nodes-powershell"
Add-NodeToRoot $rootnode "https://stackoverflow.com/questions/61680272/making-a-powershell-form-button-call-to-a-function"


# recursive helper function to add folder nodes to the treeview
function Add-Node {
	param (
		[System.Windows.Forms.TreeNode]$parentNode, 
		[System.IO.DirectoryInfo]$Folder
	)
	Write-Verbose "Adding node $($Folder.Name)"
	$subnode      = New-Object System.Windows.Forms.TreeNode
	$subnode.Text = $Folder.Name
	[void]$parentNode.Nodes.Add($subnode)
	Get-ChildItem -Path $Folder.FullName -Directory | ForEach-Object {
		Add-Node $subnode $_
	}
	Get-ChildItem -Path $Folder.FullName -File | ForEach-Object {
		Add-SubNode $subnode $_
	}
	
}

$TreeView2 = New-Object System.Windows.Forms.TreeView
$TreeView2.Location = New-Object System.Drawing.Point(348, 12)
$TreeView2.Size = New-Object System.Drawing.Size(290, 322)
$Form.Controls.Add($TreeView2)

$rootnode2 = New-Object System.Windows.Forms.TreeNode
# get the name of the rootfolder to use for the root node
$rootnode2.Text = $RootFolder
$rootnode2.Name = "Root"
[void]$TreeView2.Nodes.Add($rootnode2)
# expand just the root node
$rootnode2.Expand()

# get all subdirectories inside the root folder and 
# call the recursive function on each of them
Get-ChildItem -Path $RootFolder -Directory | ForEach-Object {
	Add-Node $rootnode2 $_
}
Get-ChildItem -Path $RootFolder -File | ForEach-Object {
	Add-SubNode $rootnode2 $_
}


function GetNodes-ShowParent($nodes){
     foreach ($n in $nodes) {
		if ($n.Text -Match $txt.Text){
			# test with: write-host $n.Text
			# test with: write-host $n.Parent
			write-host $n.FullPath
			$pathName=$n.Text
		}
        GetNodes-ShowParent($n.Nodes)
     }
}

function GetNodes($nodes){
     foreach ($n in $nodes) {
		if ($n.Text -Match $txt.Text){
			write-host $n.Text
		}
        GetNodes($n.Nodes)
     }
}




# https://stackoverflow.com/questions/61680272/making-a-powershell-form-button-call-to-a-function
$Button_Click = {
	# test with: write-host $rootnode.Text
	GetNodes($rootnode)
	GetNodes-ShowParent($rootnode2)
}
$btn = New-Object System.Windows.Forms.Button
$btn.Text = "Search"
$btn.Location = New-Object System.Drawing.Point(348, 335)
$btn.Size = New-Object System.Drawing.Size(290, 22)
$btn.Add_Click($Button_Click)
$Form.Controls.Add($btn)


$Button1_Click = {
	# test with: 
	write-host $treeview.SelectedNode
}
$btn1 = New-Object System.Windows.Forms.Button
$btn1.Text = "Starten"
$btn1.Location = New-Object System.Drawing.Point(348, 357)
$btn1.Size = New-Object System.Drawing.Size(290, 22)
$btn1.Add_Click($Button1_Click)
$Form.Controls.Add($btn1)


$txt = New-Object System.Windows.Forms.TextBox
$txt.Location = New-Object System.Drawing.Point(48, 335)
$txt.Size = New-Object System.Drawing.Size(290, 22)
$Form.Controls.Add($txt)

		
		
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
$Form.Dispose()

