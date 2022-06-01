//Windows:
//Kompilieren: javac c:\tempjava\Tree.java
//mit LuaJ:
//"C:\Program Files\Java\jdk1.8.0_25\bin\javac.exe" -classpath luaj-jse-3.0.1.jar c:\Tree\LuaJ_Tree\Tree.java
//Jar-Archiv aktualisieren, nachdem luaj-jse-3.0.1.jar zu Tree.jar umbenannt wurde
//"C:\Program Files\Java\jdk1.8.0_25\bin\jar.exe" uvfM Tree.jar Tree.class Tree*.class MyTreeCellRenderer*.class GlobalClass.class
//Starten dann 
//cd c:\tempjava
//java Tree
//Tree_Start.bat
//color 2e
//cd c:\tempjava
//java -classpath ".;C:\tempjava\luaj-jse-3.0.1.jar" Tree
//Jar-Archiv starten:
//"C:\Program Files\Java\jdk1.8.0_25\bin\java.exe" -classpath Tree.jar Tree

//Linux und Mac:
//mit LuaJ: https://mvnrepository.com/artifact/org.luaj/luaj-jse/3.0.1
//in /home/pi/luaj-jse-3.0.1.jar gespeichert
//Kompilieren mit: javac -classpath luaj-jse-3.0.1.jar /home/pi/Tree/LuaJ_Tree/Tree.java
//Ausfuehren mit: 
//cd Tree
//cd LuaJ_Tree
//java -classpath ".:/home/pi/Tree/LuaJ_Tree/luaj-jse-3.0.1.jar" Tree
//in Lua mit Bash-Skript: os.execute('./Tree.sh &')
//mit Bash-Skript "/home/pi/Tree.sh": ./Tree.sh &
//Jar-Archiv (cd Tree cd LuaJ_Tree) nach Kopie der luaj-jse-3.0.1.jar und Umbenennen zu Tree.jar:
//jar uvfM Tree.jar Tree.class Tree*.class MyTreeCellRenderer*.class GlobalClass.class
//Starten des Trees mit Jar-Datei und Main-Methode:
//java -classpath Tree.jar Tree
//Starten von LuaJ:
//java -classpath Tree.jar lua


//Paketvoraussetzung: "/home/pi/Tree.sh"
//Paketvoraussetzung: "/home/pi/Tree/LuaJ_Tree/Tree.java"
//Paketvoraussetzung: "/home/pi/Tree/LuaJ_Tree/luaj-jse-3.0.1.jar"
//Paketvoraussetzung: "/home/pi/Tree/LuaJ_Tree/Tree_Baum.lua"
//Paketvoraussetzung: "/home/pi/Tree/LuaJ_Tree/Tree_Baumskript.lua"

//1. import section
import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.Color;
import java.awt.Component;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

//for GUI elements
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.JTextArea;
import javax.swing.JTree;
import javax.swing.ScrollPaneConstants;
import javax.swing.DefaultCellEditor;   //make tree editable

//for buttons
import java.awt.event.ActionEvent;   
import java.awt.event.ActionListener;
import javax.swing.JButton;

//for positions
import javax.swing.text.Position;

//for tree
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.TreePath;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeNode;                //for isNodeDescendant and isNodeAncestor
import javax.swing.tree.DefaultTreeCellRenderer; //for formats of tree nodes cells
import javax.swing.tree.TreeCellEditor; //Baum editierbar machen

//for enumerations, arrays and lists
import java.util.Enumeration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

//for Lua scripts and Lua files (-classpath luaj-jse-3.0.1.jar)
import org.luaj.vm2.Globals;
import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.Varargs;
import org.luaj.vm2.lib.jse.JsePlatform;

//for files with io library
import java.io.IOException;

//for files with new io library
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

//2. class Tree general declarations
public class Tree extends JPanel {
	JTree tree; //first tree at the left or center
	JTree tree1; //second tree at the right
	JTextField textField; //editing tree nodes
	JTextField textField1; //editing tree1 nodes
	JTextArea jtf;
	String text;
	String text1;
	
//3. main show the GUI
	public static void main(String[] a){
		JFrame f = new JFrame("Übersicht");
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		f.add(new Tree());
		f.setSize(1000,650);
		f.setVisible(true);
		f.setTitle(System.getProperty("user.dir") + " Documentation Tree " + System.getProperty("os.name"));
	}//public static void main(String[] a){
	
	public Tree(){
		setLayout(new BorderLayout());

		//4.1 use LuaJ
		Globals globals = JsePlatform.standardGlobals();
		//4.1.1 read the Lua table script for tree otherwise write new one with standard content
		try{String script = new String(Files.readAllBytes(Paths.get("Tree_Baum.lua")));
			LuaValue result = globals.load(script);
			LuaTable table = result.checkfunction().call().checktable();
			text = iterateOverLuaTableEntriesRecursively(table,"top",GlobalClass.top);
		} catch (IOException e) {
			String installText="";
			if (System.getProperty("os.name").contains("Linux") || System.getProperty("os.name").contains("Mac")) {
				installText = "Tree = {branchname='Verzeichnisbaum',\n{branchname='Baumdateien','" + System.getProperty("user.dir") + "/Tree_Baum.lua'},\n{branchname='Manuelle Zuordnungen',\n'Ordner oder Dateien eingeben'},\n}\nreturn Tree" ;
			} else if (System.getProperty("os.name").contains("Windows")) {
				installText = "Tree = {branchname='Verzeichnisbaum',\n{branchname='Baumdateien','" + System.getProperty("user.dir") + "\\Tree_Baum.lua'},\n{branchname='Manuelle Zuordnungen',\n'Ordner oder Dateien eingeben'},\n}\nreturn Tree" ;
				installText = installText.replace("\\","\\\\");
			}//if (System.getProperty("os.name").contains("Linux") || System.getProperty("os.name").contains("Mac")) {
			try{Files.write(Paths.get("Tree_Baum.lua"),installText.getBytes());
			} catch (Exception e_1) {
				e_1.getStackTrace();
			}//try{Files.write(Paths.get("Tree_Baum.lua"),installText.getBytes());
			e.printStackTrace();
		}//try{String script = new String(Files.readAllBytes(Paths.get("Tree_Baum.lua")));
		
		//4.1.2 read the Lua table script for tree1 otherwise write new one with standard content
		try{String script1 = new String(Files.readAllBytes(Paths.get("Tree_Baumskript.lua")));
			//Testen mit: System.out.println(script1);
			LuaValue result1 = globals.load(script1);
			LuaTable table1 = result1.checkfunction().call().checktable();
			text1 = iterateOverLuaTableEntriesRecursively(table1,"top1",GlobalClass.top1);
		} catch (IOException e) {
			String installText1="";
			if (System.getProperty("os.name").contains("Linux") || System.getProperty("os.name").contains("Mac")) {
				installText1 = "path_script='" + System.getProperty("user.dir") + "'\n\nAusgabeTabelle = {}\nfunction LesenRecursiv(TreeTabelle)\nAusgabeTabelle[TreeTabelle.branchname:lower()]=true\nfor k,v in ipairs(TreeTabelle) do\nif type(v)=='table' then\nLesenRecursiv(v)\nelse\nAusgabeTabelle[v:lower()]=true\nend --if type(v)=='table' then\nend --for k,v in ipairs(AusgabeTabelle) do\nend --function LesenRecursiv(Tree)\nLesenRecursiv(Tree)\n\n\nTree2={branchname='Ansicht des Ordners',\n{branchname='Baum',\n'" + System.getProperty("user.dir") + "/Tree_Baumskript.lua',\n},\n}\n\nVerzeichnisinhaltTabelle={branchname=path_script}\np=io.popen('ls ' .. path_script) \nfor Datei in p:lines() do \nif AusgabeTabelle[(path_script .. '/'.. Datei):lower()]==nil then\nVerzeichnisinhaltTabelle[#VerzeichnisinhaltTabelle+1]=path_script .. '/'.. Datei \nend --if AusgabeTabelle[(path_script .. '/'.. Datei):lower()]==nil then\nend --for Datei in p:lines() do \n\nTree2[#Tree2+1]={branchname='Verzeichnisinhalt',VerzeichnisinhaltTabelle}\n\nreturn Tree2";
			} else if (System.getProperty("os.name").contains("Windows")) {
				installText1 = "path_script='" + System.getProperty("user.dir") + "'\n\nAusgabeTabelle = {}\nfunction LesenRecursiv(TreeTabelle)\nAusgabeTabelle[TreeTabelle.branchname:lower()]=true\nfor k,v in ipairs(TreeTabelle) do\nif type(v)=='table' then\nLesenRecursiv(v)\nelse\nAusgabeTabelle[v:lower()]=true\nend --if type(v)=='table' then\nend --for k,v in ipairs(AusgabeTabelle) do\nend --function LesenRecursiv(Tree)\nLesenRecursiv(Tree)\n\n\nTree2={branchname='Ansicht des Ordners',\n{branchname='Baum',\n'" + System.getProperty("user.dir") + "\\Tree_Baumskript.lua',\n},\n}\n\nVerzeichnisinhaltTabelle={branchname=path_script}\np=io.popen('cmd /r dir \"' .. path_script .. '\" /b/o/s') \nfor Datei in p:lines() do \nif AusgabeTabelle[Datei:lower()]==nil then\nVerzeichnisinhaltTabelle[#VerzeichnisinhaltTabelle+1]=Datei \nend --if AusgabeTabelle[Datei:lower()]==nil then\nend --for Datei in p:lines() do \n\nTree2[#Tree2+1]={branchname='Verzeichnisinhalt',VerzeichnisinhaltTabelle}\n\nreturn Tree2";
				installText1 = installText1.replace("\\","\\\\");
			}//if (System.getProperty("os.name").contains("Linux") || System.getProperty("os.name").contains("Mac")) {
			try{Files.write(Paths.get("Tree_Baumskript.lua"),installText1.getBytes());
			} catch (Exception e_2) {
				e_2.getStackTrace();
			}//try{Files.write(Paths.get("Tree_Baumskript.lua"),installText.getBytes());
			e.printStackTrace();
		}//try
		
		
		//Tree aus LuaJ: 
		tree = new JTree(GlobalClass.top);
		tree1 = new JTree(GlobalClass.top1);
		int v = ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED;
		int h = ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED;
		
		//Durch den Baum tree beim Laden gehen und Herausschreiben Anfang
		String writeText_BeimLaden = "";
		int levelNode_BeimLaden = 0;
		int levelNodeAlt_BeimLaden = 0;
		Enumeration preorderWrite_BeimLaden = GlobalClass.top.preorderEnumeration();
		DefaultMutableTreeNode nodeWrite_BeimLaden = new DefaultMutableTreeNode();
		while (preorderWrite_BeimLaden.hasMoreElements()) {
			nodeWrite_BeimLaden = (DefaultMutableTreeNode) preorderWrite_BeimLaden.nextElement();
			//Klammer zu zwischendurch schreiben
			levelNodeAlt_BeimLaden = levelNode_BeimLaden;
			levelNode_BeimLaden    = nodeWrite_BeimLaden.getLevel();
			writeText_BeimLaden = writeText_BeimLaden + "\n--" + levelNodeAlt_BeimLaden + "->" + levelNode_BeimLaden;
			if (levelNode_BeimLaden < levelNodeAlt_BeimLaden) {
				for (int i = 1; i <= levelNodeAlt_BeimLaden - levelNode_BeimLaden; i = i +1) {
					writeText_BeimLaden = writeText_BeimLaden + "\n" + "},";	
				}
			}
			//Blatt oder Knoten schreiben
			if (levelNode_BeimLaden > 0 && nodeWrite_BeimLaden.isLeaf()) {//levelNode_BeimLaden > 0 weil Knoten top nicht genommen wird
				writeText_BeimLaden = writeText_BeimLaden + "\n[========[" + nodeWrite_BeimLaden.toString().replace("========","==== ====") + "]========],";
			} else if (levelNode_BeimLaden > 0) {//levelNode_BeimLaden > 0 weil Knoten top nicht genommen wird
				//nicht mehr noetig: 	if (levelNode_BeimLaden > 2) {
				//nicht mehr noetig: 		writeText_BeimLaden = writeText_BeimLaden + "\n{branchname=[========[" + nodeWrite_BeimLaden.toString().replace("========","==== ====") + "]========], state = 'COLLAPSED',";
				//nicht mehr noetig: 	} else {
					writeText_BeimLaden = writeText_BeimLaden + "\n{branchname=[========[" + nodeWrite_BeimLaden.toString().replace("========","==== ====") + "]========],";
				//nicht mehr noetig: 	}
			}
		}
		//Letzte Klammer zu schreiben
		for (int i = 2; i <= levelNode_BeimLaden-1; i = i + 1) {//int i = 2 weil Knoten top nicht genommen wird
			writeText_BeimLaden = writeText_BeimLaden + "\n" + "},";
		}
		writeText_BeimLaden = writeText_BeimLaden + "\n" + "}" + "return Tree";
		//Herausschreiben des Baumes als Textdatei
		try {//mit nio
			String contentsWrite_BeimLaden = "Tree = \n" + writeText_BeimLaden;
			Files.write(Paths.get("Tree_Baum_BeimLaden.lua"),contentsWrite_BeimLaden.getBytes());
		} catch (IOException e1) {
			System.out.println("Fehler");
			e1.printStackTrace();
		}
		//Durch den Baum tree gehen und Herausschreiben Ende

		
		//4.4.1 go through tree1 and collapse or expand
		Enumeration preorderExpansion = GlobalClass.top.preorderEnumeration(); 
		DefaultMutableTreeNode nodeExpansion = new DefaultMutableTreeNode();
		int levelNode=0;
		while (preorderExpansion.hasMoreElements()){
			nodeExpansion = (DefaultMutableTreeNode) preorderExpansion.nextElement();
			TreePath path = new TreePath(nodeExpansion.getPath());
			levelNode=nodeExpansion.getLevel();
			if (levelNode<2) {
				tree.expandPath(path);
			}//if (levelNode<2) {
		}//while (preorderExpansion.hasMoreElements()){

		//4.4.2 go through tree1 and collapse or expand
		Enumeration preorderExpansion1 = GlobalClass.top1.preorderEnumeration(); 
		DefaultMutableTreeNode nodeExpansion1 = new DefaultMutableTreeNode();
		int levelNode1=0;
		while (preorderExpansion1.hasMoreElements()){
			nodeExpansion1 = (DefaultMutableTreeNode) preorderExpansion1.nextElement();
			TreePath path1 = new TreePath(nodeExpansion1.getPath());
			levelNode1=nodeExpansion1.getLevel();
			if (levelNode1<2) {
				tree1.expandPath(path1);
			}//if (levelNode1<2) {
		}//while (preorderExpansion1.hasMoreElements()){
		
		
		
		JScrollPane jsp = new JScrollPane(tree,v,h);
		add(jsp,BorderLayout.CENTER);
		JScrollPane jsp1 = new JScrollPane(tree1,v,h);
		add(jsp1,BorderLayout.EAST);
		
		jtf = new JTextArea(10,84);//JTextField("",20);
		jtf.setText("");
		jtf.setFont(new Font("Times New Roman",Font.PLAIN,12));
		jtf.setLineWrap(true);
		jtf.setWrapStyleWord(true);
		JScrollPane scrollpane = new JScrollPane(jtf);
		add(scrollpane,BorderLayout.SOUTH);
		
		//Baum tree editierbar machen Anfang
		textField = new JTextField("",55);
		TreeCellEditor editor = new DefaultCellEditor(textField);
		tree.setEditable(true);
		tree.setCellEditor(editor);
		//Baum tree editierbar machen Ende
		//Baum tree1 editierbar machen Anfang
		textField1 = new JTextField("",55);
		TreeCellEditor editor1 = new DefaultCellEditor(textField1);
		tree1.setEditable(true);
		tree1.setCellEditor(editor1);
		//Baum tree1 editierbar machen Ende
		
		//Mouse für den Baum tree Anfang
		tree.addMouseListener(new MouseAdapter(){
			public void mouseClicked(MouseEvent me){
				doMouseClicked(me);
			}
		});
		//Mouse für den Baum tree Ende
		//Mouse für den Baum tree1 Anfang
		tree1.addMouseListener(new MouseAdapter(){
			public void mouseClicked(MouseEvent me){
				doMouseClicked1(me);
			}
		});
		//Mouse für den Baum tree1 Ende
		
		
		
		//4.8 buttons
		//4.8.1 button to mark and unmark
		JButton btn1 = new JButton("Markieren");
		btn1.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				System.out.println("");
				System.out.println("");
				System.out.println("");
				System.out.println("");
				String suchText = jtf.getText();
				if (e.getActionCommand().equals("Markieren")){
					System.out.println(suchText);
GlobalClass.nameListRed   = new ArrayList<>();
GlobalClass.nameListGreen = new ArrayList<>();
GlobalClass.nameListBlue  = new ArrayList<>();
GlobalClass.nameListRed1  = new ArrayList<>();
GlobalClass.nameListGreen1= new ArrayList<>();
GlobalClass.nameListBlue1 = new ArrayList<>();
					btn1.setText("Entmarkieren mit missing");
					
					//Markieren tree als Rot, Blau und Grün Anfang
					Enumeration preorder = GlobalClass.top.preorderEnumeration();
					int k = 0;
					DefaultMutableTreeNode node1 = new DefaultMutableTreeNode();
					while (preorder.hasMoreElements()){
						k = k + 1;
						DefaultMutableTreeNode node = (DefaultMutableTreeNode) preorder.nextElement();
						if (node.toString().contains(suchText)){
						node1 = node;
						System.out.println("");						
						System.out.println("Nr. " + k + " Text: " + node1.toString());
						Enumeration preorder1 = GlobalClass.top.preorderEnumeration();
						while (preorder1.hasMoreElements()) {
							DefaultMutableTreeNode node2 = (DefaultMutableTreeNode) preorder1.nextElement();
							if (node2.isNodeDescendant(node1)==true) {
								System.out.println("Rot: " + node2.toString());
GlobalClass.nameListRed.add(node2.toString());
							}
							if (node2.isNodeDescendant(node1)==true && node2.isNodeAncestor(node1)==true) {
								System.out.println("Blau: " + node2.toString());
GlobalClass.nameListBlue.add(node2.toString());
							}
							if (node2.isNodeAncestor(node1)==true) {
								System.out.println("Grün: " + node2.toString());
GlobalClass.nameListGreen.add(node2.toString());
							}
						}						
						}
					}
					tree.setCellRenderer(new MyTreeCellRenderer());
					//Markieren tree als Rot, Blau und Grün Ende
					
					//Markieren tree1 als Rot, Blau und Grün Anfang
					Enumeration preorder_tree1 = GlobalClass.top1.preorderEnumeration();
					int k1 = 0;
					DefaultMutableTreeNode node1_tree1 = new DefaultMutableTreeNode();
					while (preorder_tree1.hasMoreElements()){
						k1 = k1 + 1;
						DefaultMutableTreeNode node_tree1 = (DefaultMutableTreeNode) preorder_tree1.nextElement();
						if (node_tree1.toString().contains(suchText)){
						node1_tree1 = node_tree1;
						System.out.println("");						
						System.out.println("Nr. " + k + " Text: " + node1_tree1.toString());
						Enumeration preorder1_tree1 = GlobalClass.top1.preorderEnumeration();
						while (preorder1_tree1.hasMoreElements()) {
							DefaultMutableTreeNode node2_tree1 = (DefaultMutableTreeNode) preorder1_tree1.nextElement();
							if (node2_tree1.isNodeDescendant(node1_tree1)==true) {
								System.out.println("Rot: " + node2_tree1.toString());
GlobalClass.nameListRed1.add(node2_tree1.toString());
							}
							if (node2_tree1.isNodeDescendant(node1_tree1)==true && node2_tree1.isNodeAncestor(node1_tree1)==true) {
								System.out.println("Blau: " + node2_tree1.toString());
GlobalClass.nameListBlue1.add(node2_tree1.toString());
							}
							if (node2_tree1.isNodeAncestor(node1_tree1)==true) {
								System.out.println("Grün: " + node2_tree1.toString());
GlobalClass.nameListGreen1.add(node2_tree1.toString());
							}
						}						
						}
					}
					tree1.setCellRenderer(new MyTreeCellRenderer1());
					//Markieren tree1 als Rot, Blau und Grün Ende
					
				} else if (e.getActionCommand().equals("Entmarkieren mit missing")) {
					btn1.setText("Markieren");
					tree.setCellRenderer(new MyTreeCellRenderer_unmark());
					tree1.setCellRenderer(new MyTreeCellRenderer_unmark());
					if (jtf.getText().equals("missing")) {
						//search in tree whether file does not exist
						String missingFiles = "Fehlende Dateien: ";
						Enumeration preorder_tree = GlobalClass.top.preorderEnumeration();
						int k=0;
						while (preorder_tree.hasMoreElements()) {
							DefaultMutableTreeNode node_tree = (DefaultMutableTreeNode) preorder_tree.nextElement();
							if (System.getProperty("os.name").contains("Linux") || System.getProperty("os.name").contains("Mac")) {
								if (!node_tree.toString().contains("\n") &&
									!node_tree.toString().contains("(") &&
									!node_tree.toString().contains(";") &&
									!node_tree.toString().contains("//") &&
									 node_tree.toString().contains("/") &&
									(node_tree.toString().contains(".txt") ||
									 node_tree.toString().contains(".lua") ||
									 node_tree.toString().contains(".csv") ||
									 node_tree.toString().contains(".sas") 
									) && 
									!Files.exists(Paths.get(node_tree.toString()))
								) {
									System.out.println("missing: " + node_tree.toString());
									missingFiles = missingFiles + "\n" + node_tree.toString();
									jtf.setText(missingFiles);
								} //if (!node_tree.toString().contains("\n") &&
							} else if (System.getProperty("os.name").contains("Windows")) {

								if (!node_tree.toString().contains("\n") &&
									!node_tree.toString().contains("(") &&
									!node_tree.toString().contains(";") &&
									!node_tree.toString().contains("//") &&
									 node_tree.toString().contains(":\\") &&
									(node_tree.toString().contains(".txt") ||
									 node_tree.toString().contains(".lua") ||
									 node_tree.toString().contains(".csv") ||
									 node_tree.toString().contains(".sas") 
									) && 
									!Files.exists(Paths.get(node_tree.toString()))
								) {
									System.out.println("missing: " + node_tree.toString());
									missingFiles = missingFiles + "\n" + node_tree.toString();
									jtf.setText(missingFiles);
								} //if (!node_tree.toString().contains("\n") &&
							}//if (System.getProperty("os.name").contains("Linux") || System.getProperty("os.name").contains("Mac")) {
						}//while (preorder_tree.hasMoreElements()) {
					}//if (jtf.getText().equals("missing")) {
				} //if (e.getActionCommand().equals("Markieren")){
			}//public void actionPerformed(ActionEvent e){
		});//btn1.addActionListener(new ActionListener(){
		add(btn1,BorderLayout.NORTH);
		

		//4.8.2 button to build new node, to export and delete nodes in tree
		JButton btn2 = new JButton("Neu mit neu");
		btn2.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				if (e.getActionCommand().equals("Neu mit neu")){
					System.out.println("Neu mit neu");
					//Neuen Knoten definieren Anfang
					DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
					//neuer Knoten
					DefaultMutableTreeNode newNode = new DefaultMutableTreeNode("_");
					//Neuen Knoten definieren Ende
					//Bestimmen des Knotens, an den newNode gehängt werden soll Anfang
					String nodeKnotenText = tree.getLastSelectedPathComponent() + "";
					DefaultMutableTreeNode nodeKnoten = new DefaultMutableTreeNode();
					Enumeration preorderKnoten = GlobalClass.top.preorderEnumeration();
					while (preorderKnoten.hasMoreElements()) {
						DefaultMutableTreeNode nodeBestehendKnoten = (DefaultMutableTreeNode) preorderKnoten.nextElement();
						if (nodeBestehendKnoten.toString().equals(nodeKnotenText)) {
							nodeKnoten = nodeBestehendKnoten;
						}
					}
					//Bestimmen des Knotens, an den newNode gehängt werden soll Ende
					//Insert new node as last child of nodeKnoten or after defined position Anfang
					int iLage ;
					try {
						iLage = Integer.parseInt(jtf.getText());
					} catch (NumberFormatException nFE) {
						iLage = nodeKnoten.getChildCount();
					}
					if (iLage < nodeKnoten.getChildCount()) {
						model.insertNodeInto(newNode, nodeKnoten, iLage);
						model.reload(newNode);
					} else if (jtf.getText().equals("neu")) {
						model.insertNodeInto(newNode, nodeKnoten, nodeKnoten.getChildCount());
						model.reload(newNode);
					}
					//Insert new node as last child of nodeKnoten or after defined position Ende
					btn2.setText("Export");
					
				} else if (e.getActionCommand().equals("Export")) {
					System.out.println("Export");

					//Durch den Baum gehen und Herausschreiben Anfang
					String writeText = "";
					int levelNode = 0;
					int levelNodeAlt = 0;
					Enumeration preorderWrite = GlobalClass.top.preorderEnumeration();
					DefaultMutableTreeNode nodeWrite = new DefaultMutableTreeNode();
					while (preorderWrite.hasMoreElements()) {
						nodeWrite = (DefaultMutableTreeNode) preorderWrite.nextElement();
						//Klammer zu zwischendurch schreiben
						levelNodeAlt = levelNode;
						levelNode    = nodeWrite.getLevel();
						writeText = writeText + "\n--" + levelNodeAlt + "->" + levelNode;
						if (levelNode < levelNodeAlt) {
							for (int i = 1; i <= levelNodeAlt - levelNode; i = i +1) {
								writeText = writeText + "\n" + "},";						
							}
						}
						//Blatt oder Knoten schreiben
						if (levelNode > 0 && nodeWrite.isLeaf()) {//levelNode > 0 weil Knoten top nicht genommen wird
							writeText = writeText + "\n[========[" + nodeWrite.toString().replace("========","==== ====") + "]========],";
						} else if (levelNode > 0) {//levelNode > 0 weil Knoten top nicht genommen wird
							//nicht mehr noetig: if (levelNode > 2) {
							//nicht mehr noetig: 		writeText = writeText + "\n{branchname=[========[" + nodeWrite.toString().replace("========","==== ====") + "]========], state = 'COLLAPSED',";
							//nicht mehr noetig: } else {
							writeText = writeText + "\n{branchname=[========[" + nodeWrite.toString().replace("========","==== ====") + "]========],";
							//nicht mehr noetig: }

						}
					}
					//Letzte Klammer zu schreiben
					for (int i = 2; i <= levelNode-1; i = i + 1) {//int i = 2 weil Knoten top nicht genommen wird
						writeText = writeText + "\n" + "},";
					}
					writeText = writeText + "\n" + "}" + "return Tree";
					//Herausschreiben des Baumes als Textdatei
					try {//mit nio
						String contentsWrite = "Tree = \n" + writeText;
						Files.write(Paths.get("Tree_Baum.lua"),contentsWrite.getBytes()); //Tree_Baum_neu.lua durch Tree_Baum.lua ersetzt, damit Baum aktualisiert wird
					} catch (IOException e1) {
						System.out.println("Fehler");
						e1.printStackTrace();
					}
					//Durch den Baum gehen und Herausschreiben Ende

					btn2.setText("Entfernen mit ja");

				} else if (e.getActionCommand().equals("Entfernen mit ja")) {
					System.out.println("Entfernen mit ja");

					//Node Löschen Anfang
					DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
					TreePath[] paths = tree.getSelectionPaths();
					if (jtf.getText().equals("ja") && paths!=null) {
						for (TreePath path : paths) {
							DefaultMutableTreeNode nodeDelete = (DefaultMutableTreeNode) path.getLastPathComponent();
							if (nodeDelete.getParent() != null) {
								model.removeNodeFromParent(nodeDelete);
							}
						}
					}
					//Node Löschen Ende


					btn2.setText("Neu mit neu");
				}
			}
		});
		add(btn2,BorderLayout.WEST);

		
		
	}//public Tree(){
	
	//5. mouse click events
	//5.1 mouse click event to start nodes of tree and write content in text area
	void doMouseClicked(MouseEvent me){
		TreePath tp = tree.getPathForLocation(me.getX(),me.getY());
		if (tp != null) {jtf.setText(tp.toString());}
		else {jtf.setText("");}
		Runtime r = Runtime.getRuntime();
		Process p = null;
		String nodeText = tree.getLastSelectedPathComponent() + "";
		//start program text
		String programmText = "";
		if (System.getProperty("os.name").contains("Linux")) {
			if      (nodeText.contains(".txt")   && !nodeText.contains(")")){programmText = "geany";}
			else if (nodeText.contains(".lua")   && !nodeText.contains(")")){programmText = "geany";}
			else if (nodeText.contains(".csv")   && !nodeText.contains(")")){programmText = "geany";}
			else if (nodeText.contains(".java")  && !nodeText.contains(")")){programmText = "geany";}
			else if (nodeText.contains(".jpg")   && !nodeText.contains(")")){programmText = "gpicview";}
			else if (nodeText.contains("http")   && !nodeText.contains(")")){programmText = "chromium-browser";}
			else if (nodeText.contains("/home/") && !nodeText.contains(")")){programmText = "pcmanfm";}
		} else if (System.getProperty("os.name").contains("Mac")) {
			if (nodeText.contains("/")){programmText = "open";}
		} else if (System.getProperty("os.name").contains("Windows")) {
			if      (nodeText.contains(".txt")  && !nodeText.contains(")")){programmText = "explorer.exe";}
			else if (nodeText.contains(".lua")  && !nodeText.contains(")")){programmText = "notepad.exe";}
			else if (nodeText.contains(".csv")  && !nodeText.contains(")")){programmText = "explorer.exe";}
			else if (nodeText.contains(".java") && !nodeText.contains(")")){programmText = "explorer.exe";}
			else if (nodeText.contains(".jpg")  && !nodeText.contains(")")){programmText = "explorer.exe";}
			else if (nodeText.contains(":\\")   && !nodeText.contains("/*") && !nodeText.contains("--") && !nodeText.contains(")")){programmText = "explorer.exe";}
			else if (nodeText.contains("http")  && !nodeText.contains(")")){programmText = "explorer.exe";}
		}//if (System.getProperty("os.name").contains("Linux")) {
		//start program text end
		String cmd[] = {programmText,nodeText};
		try {p = r.exec(cmd);
			jtf.setText("Start von " + nodeText);
		} catch(Exception e) {
			jtf.setText("Kein Start von " + nodeText);
		} //try {p = r.exec(cmd);
	} //void doMouseClicked(MouseEvent me){
	
	
	void doMouseClicked1(MouseEvent me){
		TreePath tp1 = tree1.getPathForLocation(me.getX(),me.getY());
		if (tp1 != null) {jtf.setText(tp1.toString());}
		else {jtf.setText("");}
		Runtime r1 = Runtime.getRuntime();
		Process p1 = null;
		String nodeText1 = tree1.getLastSelectedPathComponent() + "";
		//Startprogrammtexte Anfang
		String programmText1 = "";
		if (System.getProperty("os.name").contains("Linux")) {
			if      (nodeText1.contains(".txt")   && !nodeText1.contains(")")){programmText1 = "geany";}
			else if (nodeText1.contains(".lua")   && !nodeText1.contains(")")){programmText1 = "geany";}
			else if (nodeText1.contains(".csv")   && !nodeText1.contains(")")){programmText1 = "geany";}
			else if (nodeText1.contains(".java")  && !nodeText1.contains(")")){programmText1 = "geany";}
			else if (nodeText1.contains(".jpg")   && !nodeText1.contains(")")){programmText1 = "gpicview";}
			else if (nodeText1.contains("http")   && !nodeText1.contains(")")){programmText1 = "chromium-browser";}
			else if (nodeText1.contains("/home/") && !nodeText1.contains(")")){programmText1 = "pcmanfm";}
		} else if (System.getProperty("os.name").contains("Mac")) {
			if (nodeText1.contains("/")){programmText1 = "open";}
		} else if (System.getProperty("os.name").contains("Windows")) {
			if      (nodeText1.contains(".txt")  && !nodeText1.contains(")")){programmText1 = "explorer.exe";}
			else if (nodeText1.contains(".lua")  && !nodeText1.contains(")")){programmText1 = "notepad.exe";}
			else if (nodeText1.contains(".csv")  && !nodeText1.contains(")")){programmText1 = "explorer.exe";}
			else if (nodeText1.contains(".java") && !nodeText1.contains(")")){programmText1 = "explorer.exe";}
			else if (nodeText1.contains(".jpg")  && !nodeText1.contains(")")){programmText1 = "explorer.exe";}
			else if (nodeText1.contains(":\\")   && !nodeText1.contains("/*") && !nodeText1.contains("--") && !nodeText1.contains(")")){programmText1 = "explorer.exe";}
			else if (nodeText1.contains("http")  && !nodeText1.contains(")")){programmText1 = "explorer.exe";}
		}//if (System.getProperty("os.name").contains("Linux")) {
		//Startprogrammtexte Ende
		//String cmd[] = {programmText,tree.getLastSelectedPathComponent() + ""};
		String cmd1[] = {programmText1,nodeText1};
		try {
			p1 = r1.exec(cmd1);
			jtf.setText("Start von " + nodeText1);
		} catch(Exception e) {
			jtf.setText("Kein Start von " + nodeText1);
		} 
	} //void doMouseClicked1(MouseEvent me){
	
	public static String iterateOverLuaTableEntriesRecursively(LuaTable table,String topText, DefaultMutableTreeNode GlobalClasstop){
		String branchname = table.get("branchname").toString();
		//Testen mit: 		System.out.println(branchname);
		DefaultMutableTreeNode branchnameNode = new DefaultMutableTreeNode(branchname);
		//Bestimmen des Knotens, an dem branchnameNode gehaengt werden soll Anfang
		DefaultMutableTreeNode topFund = new DefaultMutableTreeNode();
		Enumeration preorderFuerTop = GlobalClasstop.preorderEnumeration();
		//Node finden
		while (preorderFuerTop.hasMoreElements()){
			DefaultMutableTreeNode nodeBestehendFuerTop = (DefaultMutableTreeNode) preorderFuerTop.nextElement();
			if (nodeBestehendFuerTop.toString().equals(topText)){
				topFund = nodeBestehendFuerTop;
				//Testen mit: System.out.println("topFund: " + topFund.toString());
			}
		}
		//Bestimmen des Knotens, an dem branchnameNode gehaengt werden soll Ende
		topFund.add(branchnameNode);
		//Eintraege in Lua-Tabelle durchgehen Anfang
		LuaValue lastKey = LuaValue.NIL; //start with first item of table
		Varargs tableItem;
		while(!(tableItem = table.next(lastKey)).arg1().isnil()){
			//Node finden, an dem Eintraege gehaengt werden Anfang
			DefaultMutableTreeNode beliebigerNode = new DefaultMutableTreeNode(table.get(tableItem.arg1()).toString());
			DefaultMutableTreeNode nodeFund = new DefaultMutableTreeNode();
			Enumeration preorder = GlobalClasstop.preorderEnumeration();
			//Node finden
			while (preorder.hasMoreElements()) {
				DefaultMutableTreeNode nodeBestehend = (DefaultMutableTreeNode) preorder.nextElement();
				if (nodeBestehend.toString().equals(branchname.toString())) {
					nodeFund = nodeBestehend;
					//Testen mit: System.out.println("nodeFund: " + nodeFund.toString());
				}
			}
			//Node finden, an dem Eintraege gehaengt werden Ende
			//an verschiedene haengen, ausser Tabellen und Knoten selbst Anfang
			if (beliebigerNode.toString().contains("table: ")){
				//nichts machen
			} else if (nodeFund.toString().equals(beliebigerNode.toString())){
				//nichts machen
			} else {
				nodeFund.add(beliebigerNode);
			}
			//an verschiedene haengen, ausser Tabellen und Knoten selbst Ende
			//Bei einer Tabelle als Eintrag die Rekursion durchfuehren Anfang
			if (table.get(tableItem.arg1()).istable()){
				LuaTable checktable = table.get(tableItem.arg1()).checktable(); //Umwandlung von LuaValue in LuaTable mit .checktable()
				iterateOverLuaTableEntriesRecursively(checktable,branchname,GlobalClasstop); //"top"); einfache Version an top haengen, bessere Version an branchname haengen
			}
			//Bei einer Tabelle als Eintrag die Rekursion durchfuehren Ende
			
			//einen Eintrag weiter gehen
			lastKey = tableItem.arg1();
		}
		//Eintraege in Lua-Tabelle durchgehen Ende
		
		
	return "Baumdurchsuchen";
	} //public static String iterateOverLuaTableEntriesRecursively(LuaTable table,String topText, DefaultMutableTreeNode GlobalClasstop){
	
}//public class Tree extends JPanel {

class MyTreeCellRenderer extends DefaultTreeCellRenderer {
	@Override
	public Component getTreeCellRendererComponent (JTree tree, Object value, boolean sel, boolean exp, boolean leaf, int row, boolean hasFocus) {
		super.getTreeCellRendererComponent(tree,value,sel,exp,leaf,row,hasFocus);
		String node = (String) ((DefaultMutableTreeNode) value).getUserObject();
		if (GlobalClass.nameListBlue.contains(node.toString())) {
			setForeground(new Color(10,10,250));
		} else if (GlobalClass.nameListRed.contains(node.toString())) {
			setForeground(new Color(250,10,10));
		} else if (GlobalClass.nameListGreen.contains(node.toString())) {
			setForeground(new Color(10,250,10));
		}
	
		return this;
	}
}

class MyTreeCellRenderer1 extends DefaultTreeCellRenderer {
	@Override
	public Component getTreeCellRendererComponent (JTree tree, Object value, boolean sel, boolean exp, boolean leaf, int row, boolean hasFocus) {
		super.getTreeCellRendererComponent(tree,value,sel,exp,leaf,row,hasFocus);
		String node = (String) ((DefaultMutableTreeNode) value).getUserObject();
		if (GlobalClass.nameListBlue1.contains(node.toString())) {
			setForeground(new Color(10,10,250));
		} else if (GlobalClass.nameListRed1.contains(node.toString())) {
			setForeground(new Color(250,10,10));
		} else if (GlobalClass.nameListGreen1.contains(node.toString())) {
			setForeground(new Color(10,250,10));
		}
	
		return this;
	}
}

class MyTreeCellRenderer_unmark extends DefaultTreeCellRenderer {
	@Override
	public Component getTreeCellRendererComponent (JTree tree, Object value, boolean sel, boolean exp, boolean leaf, int row, boolean hasFocus) {
		super.getTreeCellRendererComponent(tree,value,sel,exp,leaf,row,hasFocus);
		setForeground(new Color(0,0,0));
		return this;
	}
}




//8. global variables used in global context
class GlobalClass {
	//top for tree and top1 for tree1
	public static DefaultMutableTreeNode top  = new DefaultMutableTreeNode("top");
	public static DefaultMutableTreeNode top1 = new DefaultMutableTreeNode("top1");
	//name lists for mark nodes
	public static List<String> nameListRed       = new ArrayList<>();
	public static List<String> nameListGreen     = new ArrayList<>();
	public static List<String> nameListBlue      = new ArrayList<>();
	public static List<String> nameListRed1      = new ArrayList<>();
	public static List<String> nameListGreen1    = new ArrayList<>();
	public static List<String> nameListBlue1     = new ArrayList<>();
}
