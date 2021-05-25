open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\S1.tif");
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\test.tif");
selectWindow("S1.tif");
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S1.tif");
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Height=0µm", 0, 24);
     //makeText("Height=0µm", 0, 24);
  }
saveAs("Tiff", "C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\Combined Stacks1.tif");
close();
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\S2.tif");
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\test.tif");
selectWindow("S2.tif");
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S2.tif");
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Height=140µm", 0, 24);
     //makeText("Height=140µm", 0, 24);
  }
saveAs("Tiff", "C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\Combined Stacks2.tif");
close();
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\S3.tif");
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\test.tif");
selectWindow("S3.tif");
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S3.tif");
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Height=280µm", 0, 24);
     //makeText("Height=280µm", 0, 24);
  }
saveAs("Tiff", "C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\Combined Stacks3.tif");
close();
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\S4.tif");
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\test.tif");
selectWindow("S4.tif");
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S4.tif");
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Height=420µm", 0, 24);
     //makeText("Height=420µm", 0, 24);
  }
saveAs("Tiff", "C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\Combined Stacks4.tif");
close();
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\S5.tif");
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\test.tif");
selectWindow("S5.tif");
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S5.tif");
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Height=560µm", 0, 24);
     //makeText("Height=560µm", 0, 24);
  }
saveAs("Tiff", "C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\Combined Stacks5.tif");
close();
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\S6.tif");
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\test.tif");
selectWindow("S6.tif");
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S6.tif");
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Height=700µm", 0, 24);
     //makeText("Height=700µm", 0, 24);
  }
saveAs("Tiff", "C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\Combined Stacks6.tif");
close();
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\S7.tif");
open("C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\test.tif");
selectWindow("S7.tif");
run("RGB Color");
run("Combine...", "stack1=test.tif stack2=S7.tif");
for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setForegroundColor(255, 255, 255);
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     drawString("Height=840µm", 0, 24);
     //makeText("Height=840µm", 0, 24);
  }
saveAs("Tiff", "C:\\Users\\labadmin\\Desktop\\compact_data_processing\\bead_probe3\\Combined Stacks7.tif");
close();
