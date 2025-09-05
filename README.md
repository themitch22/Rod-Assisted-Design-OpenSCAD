Customizable modular connector system for dowel rods, pipes, and tubes!

This OpenSCAD model was created to construct anything from readily-available and affordable materials such as wooden dowels, PVC pipe, electrical conduit, drinking straws, etc. 

I spent a lot of time developing this OpenSCAD model, if you found this useful and would like to support me, I am accepting tips Ko-Fi tips: https://ko-fi.com/mitch3d

There are 4 types of pieces that can be created:
Connector

The connector can be customized to have a central leg, you add the number of connecting legs you need, adjust the vertical and horizontal angles, and select the diameter, thickness, rib, and screw options. There are added parameters to flatten the top and bottom of the legs to make printing easier, and have a flat side to lay shelving or panels on, and teardrops are optional to further reduce overhangs to make printing easy. Included is a option to add stoppers inside the legs to prevent the rods from slipping through the center. From my testing, the flat and positive angles can all be printed without support. 

Spacer/Panel Mount:
This piece can either be used as a spacer which you can glue to a shelf or panel, or add your own connection type using a boolean geometry. The tab option you can leave blank or enable screws which adds a single centered screw which you can mount to a plywood shelf or ziptie to foamcore board. There is also a skadis option which will add a Ikea Skadis compatible hook either vertically or horizontally. This could be used to make shelves for Skadis walls, or create tape roll holders using dowels. 

Cross Connector:
For potential structure cross bracing, there is a cross connector option. Select an angle and leg length, adjust the screw parameters, This might be useful to create a side or top reinforcement to prevent sheer forces on a structure. 

End Cap/Foot:
The rough edges of a dowel or pipe might be sharp so there is an end cap option. The end cap can also be a foot if you are making shelving to prevent damage to flooring. You could customize this further to add adjustable feet or merge with other models.
Customizing with OpenSCAD

Download the latest version of OpenSCAD 

Install for your system and open the .scad file provided. By default the Customizer panel should be shown next to the preview panel. When you enter a parameter and press enter or tab, it will automatically update the preview. 

    Select the type of connector you need. The default is 1 - connector. 
    Find out your dowel or tube OD, you should get an average diameter with calipers for a tight fit but not too tight. Screws will hold the rods in place, but any play in the connection will cause stress. Add about 0.1-0.2mm of tolerance for extrusion or printer inconsistency, layer squish, or material shrinkage.
     You will need to figure out the number of legs needed and their horizontal or vertical angle. Most features only work with a 0 degree flat vertical angle, but the horizontal angle can be adjusted to suit your needs. If the horizontal angle and number of legs exceed 360 degrees, it will evenly adjust horizontal angle to fit the number of legs around the center leg. 
    Adjust the leg length, center leg length, thickness, rid reinforcement, and chamfer to desired proportions. 
    Decide if you want screws and enable them, and pick either countersink or counterbore so the screw doesn't stick out (unless desired). Then the other parameters including screw angle, which you should adjust to prevent accessibility and geometry issues with interference.
    When you are ready, press Render (F6) first. Then you can Save to STL.

Considerations

Use at your own risk!

3D printed parts, dowels, or tubing are widely variable, you should test your structures first before relying on them to hold any loads. 

Do not trust this to hold anything or anyone you care about. While I'd love to see this be used to make furniture, it should be heavily reinforced with the length of the rod in direct compression to the ground, not in direction of tensile or sheer stresses. Remember to have the sheer strength perpendicular to the layers not parallel along layers. 

PLA while rigid, can creep over time, PETG, ABS, ASA, and CF reinforced filaments are more likely to hold up over time. The material used in the pictures is ASA.
