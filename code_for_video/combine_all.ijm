base_path="C:\\Users\\Meng\\Desktop\\COMPACT\\bead_stack\\";
folder_base_name="zoom6_power20_z";
folder_start=1;
folder_step=1;
folder_end=9;
Height_start=120;
Height_step=120;
rot_ang_start=0;
rot_ang_step=1200;
rot_ang_end=34800;
N_stack=1;
for (folder_name=folder_start; folder_name<(folder_end+folder_step); folder_name+=folder_step) {
for (rot_ang=rot_ang_start; rot_ang<=rot_ang_end; rot_ang+=rot_ang_step) {
open(base_path+folder_base_name+d2s(folder_name,0)+"\\norm"+d2s(rot_ang,0)+".tif");
}
run("Concatenate...", "all_open title=S"+d2s(N_stack,0));
open(base_path+"test.tif");
selectWindow("S"+d2s(N_stack,0));
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S"+d2s(N_stack,0));
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Depth="+d2s(Height_start+(N_stack-1)*Height_step,0)+"µm", 0, 24);
     //makeText("Depth="+d2s(Height_start+(N_stack-1)*Height_step,0)+"µm", 0, 24);
  }
saveAs("Tiff", base_path+"Combined Stacks"+d2s(N_stack,0)+".tif");
close();
N_stack+=1;
}
for (i=1; i<=(N_stack-1); i++) {
open(base_path+"Combined Stacks"+d2s(i,0)+".tif");
}
run("Concatenate...", "all_open title=[Concatenated Stacks]");
run("AVI... ", "frame=200 save=["+base_path+"Concatenated Stacks.avi]");
saveAs("Tiff", base_path+"Concatenated Stacks.tif");
