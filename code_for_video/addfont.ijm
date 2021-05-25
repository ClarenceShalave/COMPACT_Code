for (i=1; i<=nSlices; i++) {
     setSlice(i);
     //setTool("text");
     setFont("SansSerif", 18, " antialiased");
     setColor("white");
     Overlay.drawString("Height=140µm", 0, 24, 0.0);
     Overlay.show();
  }

