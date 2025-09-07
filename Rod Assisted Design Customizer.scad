//Dowel Aided Design - Parametric Modular Dowel Rod/ Tube System
//by Mitch Cerroni - Mitch 3D (mitch3D.com)
//https://github.com/themitch22/Rod-Assisted-Design-OpenSCAD
//Original repository: https://www.printables.com/model/1402479/

//number of faces, optimize for rendering / 3D printing. 
$fn = 50; 

// Dowel Connector Parameters

// 1 = dowel connector, 2 = spacer/panel mount, 3 = cross connector, 4 = endcap
type = 1;

// Diameter in mm for dowel holes, keep in mind tolerance when printing. 1in ~ 26mm, 1/2in ~ 13mm, 3/8 ~10mm, 1/4in ~6.5mm
dowelDia = 26;

// Thickness of the walls in mm, bigger number is stronger but can cause interferences.
thickness = 6;

// Chamfer length in mm, this softens edges and looks nicer.
chamfer = 3;

// Total number of side legs. If legNum and horzAngle are more than 360 degrees it will evenly distribute leg count around center leg.
legNum = 3; 

// Horizontal angle (degrees) between side legs. If total is over 360, legs are evenly spaced instead.
horzAngle = 90;

// Vertical angle (degrees) for side legs, negative values disable flat features and lowers center leg.
vertAngle = 0; 

// If this list is populated, it will override the horzAngle and populate . If it one 360 degrees it'll be ignored. example [0, 30, 180, 270]
horzAngleList = [0, 90, 135];

// Legth in mm for the center leg, this is to compensate for the possible angles of side legs as you might want clearance to access screw holes, or have a shorter middle leg for some reason.
centerLegLength = 50;

// Length in mm, this length is additional to the leg total diameter.
lengthLeg = 50;

// If vertical angle is positive, a rib between legs and center to provide strength. 
// 0 = disabled. Rib will disable if larger than the centerLegLength or legLength (including legDia).
ribSize = 20;

// Adding internal leg stoppers to prevent dowels going too far and intersecting
// Only available for connector, not for spacer/panel mount or cross connector. 
// The geometry might have issues with certain angles.
// 0 = disabled, 1 = stoppers in leg(s) and center leg, 2 = stoppers in leg(s) only
stopperEnable = 1;

// If vertical angle is positive, it flattens bottom for printing or shelves. 1 = True
flatBottomEnable = 1;

// Amount in mm to flatten the bottom for easier printing and/or shelving depending on orientation. 
// If using cross connector, this can be adjusted to suit your printability needs.
// Keep this under thickness value.
flatBottomDepth = 3;

// If vertical angle is 0 (flat), it flattens top of legs for shelves. 1 = True.
flatTopEnable = 1;

// Amount in mm to flatted the top of each leg for shelving. Use depending on application. 
// If spacer/panel mount is selected, it will compensate height to be co-planar to connector tops. 
// Not every connector will have this flat side depending on orientation which may cause alignment issues.
// Keep this under thickness value.
flatTopDepth = 3;

// Arched top of dowel hole to reduce overhangs. 1 = True 
teardropEnable = 1;

// Screw parameters

// 1 = True, enables screw holes.
screwEnable = 1;

// Enable countersink for screws.
screwEnableCS = 1;
// Enable counterbore for screws.
screwEnableCB = 0;

// Diameter in mm for screw hole.
screwDia = 4;

// Angle in degrees on the leg where screw hole is placed. Top/Bottom holes = 0, Sides = 90. 
// You may have some intersecting geometry issues or may not be able to reach it the screws depending on the angle. 
screwAngle = 0;

// Offset in mm for screw hole from leg length inward, a higher value goes towards the center. 
screwOffset = 18; 

// Countersink and counterbore screw depth in mm for screw heads, thickness from dowel out. 
screwDepth = 0;

// Counterbore screw diameter in mm for screw heads.
screwCBDia = 6.5;

//Spacer/Panel Mount Parameters

// For spacer/panel mounts, the lenth of the tab. 0 or skadisTab enabled diables it.
tabLength = 26;

// For spacer/panel mount, it adds a Ikea Skadis capable hook. 0 = disabled, 1 = verticle, 2 = horizontal. 
// Fixed dimensions so may cause interference issues. 
skadisTab = 0;

// Cross connector and endcap

// If selected, the angle of the crossing connectors in degrees. Cross connector uses legLengt parameter. Uses flatBottomDepth if enabled and positive for easier printing. 0 or 90 just make a single leg, with double screws, might be useful as a splice joint. 
crossAngle = 30;

// If selected, the length of the endcap piece. Used as a foot or stopper.
endcapLength = 20;


// Function to total leg diameter.
function legDia() = dowelDia+thickness*2;

// Number clamping, legLength can't be smaller than leg diameter.
legLength = lengthLeg < legDia() ? legDia() : lengthLeg; 

// Verifying legNum and horzAngle aren't over 360 degrees, this helps optimization. 
// If over 360 degree it distributes legNum evenly around the center. 
legHorzAngle = legNum * horzAngle > 360 ? 360 / legNum : horzAngle;

stopperLeg = stopperEnable > 0 ? legDia()/2 : 0;
stopperCenter = stopperEnable >= 2 ? legDia() : 0;

echo(legLength);
echo(legHorzAngle);
horzAngleListNum = len(horzAngleList);
echo(horzAngleListNum);

// Creates leg with chamfer.
module leg(length){
    cylinder(h=chamfer,d1=(legDia()-chamfer*2),d2=(legDia()));
    translate([0, 0, chamfer])
        cylinder(h=(length-chamfer*2),d=(legDia()));
    translate([0, 0, (length-chamfer)])
        cylinder(h=chamfer,d1=(legDia()),d2=(legDia()-chamfer*2));
    };    

// creates the dowel hole features and screw holes which are subtracted later.
module dowelhole(length, offsetScrew, teardrop, stopper){

    if (stopper == 0) { // if stopper is 0 it disables the feature. 
            
            if(teardrop == 1){ // If enabled, add arch to reduce overhangs in dowel hole.
                hull(){
                    translate([0,dowelDia/3.5,0]) {
                        cylinder(h=length + chamfer * 2, d = dowelDia/2);
                    }    
                    cylinder(h=length + chamfer * 2, d = dowelDia); // Center dowel hole feature
                }    
            }
            
            else cylinder(h=length + chamfer * 2, d = dowelDia); // Center dowel hole feature
    }

    if (stopper > 0) { // stopper arg is for offset distance, this allows each leg to be different if needed.
        difference() {
            
            if(teardrop == 1){ // If enabled, add arch to reduce overhangs in dowel hole.
                hull(){
                    translate([0,dowelDia/3.5,0]) {
                        cylinder(h = length + chamfer * 2, d = dowelDia/2);
                    }    
                    cylinder(h=length + chamfer * 2, d = dowelDia); // Center dowel hole feature
                }    
            }
            
            else cylinder(h=length + chamfer * 2, d = dowelDia); // Center dowel hole feature
            
            if(teardrop == 1){ // If enabled, add arch to reduce overhangs in dowel hole.
                translate([0,0,0]) {
                    hull(){
                        translate([0,dowelDia/3.5,0]) {
                            cylinder(h = stopper + thickness, d = dowelDia/2);
                        }    
                        cylinder(h = stopper + thickness, d = dowelDia); // Center dowel hole feature
                    }
                }    
            }
            
            else translate([0,0,0]) {
                    cylinder(h = stopper + thickness, d = dowelDia); // Center dowel hole feature
            }
        }
    }    
    

    
    // Screw hole if enabled
    if(screwEnable == 1){
        translate([0,0,offsetScrew]) {
            rotate([90,0,screwAngle]){
                cylinder(h=legDia(), d = screwDia, center = true);
            }
        }
    }
    
    // Screw hole countersinks on top and bottom    

    translate([(legDia()+screwDepth/2)*sin(180-screwAngle)/2,(legDia()+screwDepth/2)*cos(180-screwAngle)/2,offsetScrew]) {
        rotate([0,90,90+screwAngle]){
            if(screwEnable == 1 && screwEnableCS == 1){
                cylinder(h=thickness-screwDepth, d1 = thickness*2+screwDia, d2 = screwDia);
            }
            if(screwEnable == 1 && screwEnableCB == 1){
                cylinder(h=thickness-screwDepth, d=screwCBDia);
            }
        }
    }    
    translate([-(legDia()+screwDepth/2)*sin(180-screwAngle)/2,-(legDia()+screwDepth/2)*cos(180-screwAngle)/2,offsetScrew]) {
        rotate([0,90,-90+screwAngle]){
            if(screwEnable == 1 && screwEnableCS == 1){
                cylinder(h=thickness-screwDepth, d1 = thickness*2+screwDia, d2 = screwDia);
            }
            if(screwEnable == 1 && screwEnableCB == 1){
                cylinder(h=thickness-screwDepth, d=screwCBDia);
            }
        }
    }

}

module chamfercube(length, width, height) {
    
    difference() {
        
        cube([length, width, height]);
        
        cubechamfer = chamfer * sqrt(2); // Allows chamfercube to align with leg chamfer, diagonal of a square
        
        translate([0,width/2,0]) {
            rotate([0,45,0]) {
                cube([cubechamfer, width, cubechamfer], center = true);
            }
        }
        
        translate([length,width/2,0]) {
            rotate([0,45,0]) {
                cube([cubechamfer, width, cubechamfer], center = true);
            }
        }
        
        translate([length,width/2,height]) {
            rotate([0,45,0]) {
                cube([cubechamfer, width, cubechamfer], center = true);
            }
        }
        
        translate([0,width/2,height]) {
            rotate([0,45,0]) {
                cube([cubechamfer, width, cubechamfer], center = true);
            }
        }
        
        translate([length/2,0,0]) {
            rotate([0,45,90]) {
                cube([cubechamfer, length, cubechamfer], center = true);
            }
        }
        
        translate([length/2,width,0]) {
            rotate([0,45,90]) {
                cube([cubechamfer, length, cubechamfer], center = true);
            }
        }
        translate([length/2,0,height]) {
            rotate([0,45,90]) {
                cube([cubechamfer, length, cubechamfer], center = true);
            }
        }
        
        translate([length/2,width,height]) {
            rotate([0,45,90]) {
                cube([cubechamfer, length, cubechamfer], center = true);
            }
        }
        
        translate([0,0,height/2]) {
            rotate([90,0,45]) {
                cube([cubechamfer, height, cubechamfer], center = true);
            }
        }
        
        translate([0,width,height/2]) {
            rotate([90,0,45]) {
                cube([cubechamfer, height, cubechamfer], center = true);
            }
        }
        
        translate([length,width,height/2]) {
            rotate([90,0,45]) {
                cube([cubechamfer, height, cubechamfer], center = true);
            }
        }
        
        translate([length,0,height/2]) {
            rotate([90,0,45]) {
                cube([cubechamfer, height, cubechamfer], center = true);
            }
        }
    }
}
    
module rib(sizeRib) {
    
    difference() {
        
        rotate([0,45,0]) {
            cube([sizeRib*2,thickness,sizeRib*2], center = true);
        }
        
        translate ([-sizeRib,0,0]) {
            cube([sizeRib*2,thickness+0.1,sizeRib*3], center = true);
        }
        
        translate ([0,0,-sizeRib]) {
            cube([sizeRib*3,thickness+0.1,sizeRib*2], center = true);
        }
    }
    
}

module connector(){
    union() {
    
        // Subtracting dowelholes union from leg connetor union.
        difference() {
        
            // Union of leg features.
            union() {
            
                // Downward angle moves center leg lower.
                if(vertAngle < 0){
                    translate([0,0,-centerLegLength-legDia()/2]){
                        leg(centerLegLength+legDia());
                    }
                }
                else
                    translate([0,0,-legDia()/2]){
                        leg(centerLegLength+legDia());
                    }
                
                if (horzAngleListNum <= 0) {    
                    for(legNum = [1:1:legNum]){ 
                        translate([0,0,0]){
                            rotate([90-vertAngle,0,legHorzAngle*(legNum+0.5)]){
                                leg(legLength+legDia()/2);
                            }
                        }
                    }
                }
                
                else {
                    for(legNum = [0:1:horzAngleListNum-1]){ 
                        translate([0,0,0]){
                            rotate([90-vertAngle,0,horzAngleList[legNum]]){
                                echo(horzAngleList[legNum]);
                                leg(legLength+legDia()/2);
                            }
                        }
                    }
                }
                
                
                
                
            }
        
            // Union of dowelhole features.
            union() {
                
                // Downward angle moves center dowelhole lower.
                if(vertAngle < 0){
                    translate([0,0,legDia()/2]){
                        rotate([180,0,0]){    
                        dowelhole(centerLegLength+legDia(), centerLegLength - screwOffset + legDia(), teardropEnable, stopperCenter);
                        }
                    }
                }
                
                // Upward angle scale center dowelhole to match angle.
                else 
                    translate([0,0,-legDia()/2]){          
                        dowelhole(centerLegLength+legDia(), centerLegLength - screwOffset + legDia(), teardropEnable, stopperCenter);
                    }
                    
                if (horzAngleListNum <= 0) {
                    for(legNum = [1:1:legNum]){ 
                        translate([0,0,0]){
                            rotate([90-vertAngle,0,legHorzAngle*(legNum+0.5)]){
                                dowelhole(legLength+legDia()/2+thickness, legLength - screwOffset  + legDia()/2, teardropEnable, stopperLeg);
                            }
                        }
                    }
                }

                else {
                    for(legNum = [0:1:horzAngleListNum-1]){ 
                        translate([0,0,0]){
                            rotate([90-vertAngle,0,horzAngleList[legNum]]){
                                dowelhole(legLength+legDia()/2+thickness, legLength - screwOffset  + legDia()/2, teardropEnable, stopperLeg);
                            }
                        }
                    }
                }
                
                // Flatten bottom if side legs, only for positive horz angle). Removes half of thickness, you could change this if you want.
                if(vertAngle >= 0 && flatBottomEnable == 1 && flatBottomDepth < thickness){
                    translate([0,0,-legDia()/2-0.01]){ //0.01 fixes a geometry render artifact.
                        cylinder(h=flatBottomDepth+0.01,d=(legLength*2+legDia()+thickness));
                    }
                }
            
                // Flatten tops of side legs if flat (0 degree horzAngle), 
                // useful if you want to rest a shelf on top. Removes half of thickness, you could
                // change this if you want.
                if(vertAngle == 0 && flatTopEnable == 1 && flatTopDepth < thickness){
                    translate([0,0,legDia()/2-flatTopDepth]){
                        difference() {
                            cylinder(h=thickness,d=(legLength+legDia())*2);
                            if (centerLegLength > 0) { //only flatten whole top when center leg is not wanted (for better shelf mounting)
                                cylinder(h=thickness,d=legDia());
                            }
                        }
                    }
                }
            }   
        }
        
        if (ribSize > 0 && vertAngle == 0 && ribSize < legLength - legDia()/2 && horzAngleListNum <= 0) {
            for(legNum = [1:1:legNum]){ 
                rotate([0,0,270+legHorzAngle*(legNum+0.5)]) {
                    translate([legDia()/2 - thickness/2, 0 ,legDia()/2 - (flatTopEnable == 1 ? flatTopDepth : 0)]) {   
                        rib(ribSize); // Rib feature
                    }
                }
            }
        }
        
        else if (ribSize > 0 && vertAngle == 0 && ribSize < legLength - legDia()/2 && horzAngleListNum > 0) {
            for(legNum = [0:1:horzAngleListNum-1]){ 
                rotate([0,0,270+horzAngleList[legNum]]) {
                    translate([legDia()/2 - thickness/2, 0 ,legDia()/2 - (flatTopEnable == 1 ? flatTopDepth : 0)]) {   
                        rib(ribSize); // Rib feature
                    }
                }
            }
        }
        
    }
   
}

module spacermount() {
    
    difference() {
        
        union() {
            
            difference() {
                
                translate([0,legLength/2,legDia()/2-(flatTopEnable == 1 ? flatTopDepth : 0)]) {
                    rotate([90,0,0]) {
                        leg(legLength);
                    }
                }
                
                translate([-legDia()/2,-legLength/2,-(flatTopEnable == 1 ? flatTopDepth : 0)]) {
                    cube([legDia(), legLength, (flatTopEnable == 1 ? flatTopDepth : 0)]);
                }
                
            }
            
            translate([-legDia()/2+0.0005,-legLength/2,0]) { // Added offset to fix render geometry error.
                chamfercube(legDia()-0.001,legLength,legDia()/2+chamfer-(flatTopEnable == 1 ? flatTopDepth : 0));
            }

            if (tabLength > 0 && skadisTab <= 0) {
                translate([-legDia()/2,-legLength/2,0]) {
                    chamfercube(legDia()+tabLength,legLength,thickness);
                }
            }
            
            if (tabLength > 0 && skadisTab == 1) {
                translate([0,-2.5,0]) {
                    chamfercube(legDia()/2+10.1,5,5);
                }
                translate([legDia()/2+5.1,-2.5,0]) {
                    chamfercube(5,5,13);
                }
                translate([legDia()/2-5,-2.5,0]) {
                    chamfercube(5,5,13);
                }
                
            }
            
            if (tabLength > 0 && skadisTab == 2) {
                translate([0,-2.5,0]) {
                    chamfercube(legDia()/2+10.1,5,5);
                }
                translate([legDia()/2+5.1,-2.5,0]) {
                    chamfercube(5,13,5);
                }
            }
            

        }
        
        union() {
            
            translate([0,legLength/2,legDia()/2-(flatTopEnable == 1 ? flatTopDepth : 0)]) {
                rotate([90,0,0]) {
                    dowelhole(legLength, screwOffset, teardropEnable, 0);
                }
            }
            
            // Screw hole if enabled
            if(tabLength > screwDia && screwEnable == 1 && skadisTab <= 0){
                translate([legDia()/2+tabLength/2,0,thickness/2]) {
                        cylinder(h=thickness, d = screwDia, center = true);
                }
            }

            if(tabLength > (thickness-screwDepth)*2+screwDia && screwEnable == 1 && screwEnableCS == 1 && skadisTab <= 0){
                translate([legDia()/2+tabLength/2,0,screwDepth]) {
                        cylinder(h=thickness-screwDepth, d1 = screwDia, d2 = (thickness-screwDepth)*2+screwDia);
                }
            }
            if(tabLength > screwCBDia && screwEnable == 1 && screwEnableCB == 1 && skadisTab <= 0){
                translate([legDia()/2+tabLength/2,0,screwDepth]) {
                    cylinder(h=thickness-screwDepth, d=screwCBDia);
                }
            }

        }
        
    }

}

module crossconnect() {

    difference() {

        union() {
            
            rotate([-crossAngle,0,0]){ 
                translate([0,0,-legLength/2]) {
                   leg(legLength);
                }
            }
            
            rotate([crossAngle,0,0]){
                translate([0,0,-legLength/2]) {
                    leg(legLength);
                }
            }
            
        }
        
        union() {
            
            
            rotate([-crossAngle,0,0]){ 
                translate([0,0,-legLength/2]) {
                    dowelhole(legLength, screwOffset, teardropEnable, 0);
                }
            }
            
            rotate([180-crossAngle,0,0]){ 
                translate([0,0,-legLength/2]) {
                    dowelhole(legLength, screwOffset, teardropEnable, 0);
                }
            }
            
            
            rotate([crossAngle,0,0]){
                translate([0,0,-legLength/2]) {
                    dowelhole(legLength, screwOffset, teardropEnable, 0);
                }
            }
            
            rotate([180+crossAngle,0,0]){
                translate([0,0,-legLength/2]) {
                    dowelhole(legLength, screwOffset, teardropEnable, 0);
                }
            }
            
        // Flatten bottom if side legs for easier printing).
        if(crossAngle >= 0 && flatBottomEnable == 1){
            translate([0,0,(-legLength/2*cos(crossAngle))-(legDia()/2*cos(90-crossAngle))]) {
                cylinder(h=flatBottomDepth,d=(legLength*2+legDia()+thickness));
                }
            }
            
        }
    }
}

module endcap() {
    
    difference() {
    
        leg(endcapLength);
    
        translate([0,0,thickness]) {
            dowelhole (endcapLength, screwOffset, teardropEnable, 0);
    
        }
    }

}

if(type == 1) connector();
if(type == 2) spacermount();
if(type == 3) crossconnect();
if(type == 4) endcap();
    
