
var kXmlTestString = '''
<Model_Example type="group" name="Model Example">
	<App_Settings type="group" name="App Settings">
		<Output_Width type="int" name="Output Width">
			<value>1920</value>
			<min>640</min>
			<max>6000</max>
		</Output_Width>
		<Output_Height type="int" name="Output Height">
			<value>1080</value>
			<min>480</min>
			<max>6000</max>
		</Output_Height>
		<Send_OSC type="boolean" name="Send OSC">
			<value>0</value>
		</Send_OSC>
	</App_Settings>
	<A_Path type="ofPath" name="A Path">
		<value>{ 0; 0, 0, 0; 0, 0, 0; 0, 0, 0; } { 3; 2550, 0, 0; 10, 20, 0; 300, 300, 0; } { 1; 2550, 1440, 0; 0, 0, 0; 0, 0, 0; } { 1; 0, 1440, 0; 0, 0, 0; 0, 0, 0; } { 7; 0, 0, 0; 0, 0, 0; 0, 0, 0; } </value>
	</A_Path>
	<A_Rectangle type="ofRectangle" name="A Rectangle">
		<value>123, 229, 0, 300, 300</value>
	</A_Rectangle>
	<Circle_X type="double" name="Circle X">
		<value>10</value>
		<min>0</min>
		<max>1000</max>
	</Circle_X>
	<Circle_Y type="double" name="Circle Y">
		<value>10</value>
		<min>0</min>
		<max>1000</max>
	</Circle_Y>
	<Circle_Radius type="double" name="Circle Radius">
		<value>50</value>
		<min>0</min>
		<max>500</max>
	</Circle_Radius>
	<Circle_Color type="floatColor" name="Circle Color">
		<value>1, 1, 1, 1</value>
	</Circle_Color>
</Model_Example>''';

var kXmlTestString2 = '''
<Nervous_Structure type="group" name="Nervous Structure">
	<App_Settings type="group" name="App Settings">
		<Output_Width type="int" name="Output Width">
			<value>1920</value>
			<min>640</min>
			<max>6000</max>
		</Output_Width>
		<Output_Height type="int" name="Output Height">
			<value>1080</value>
			<min>480</min>
			<max>6000</max>
		</Output_Height>
		<Send_OSC type="boolean" name="Send OSC">
			<value>0</value>
		</Send_OSC>
		<NanoVG_Rendering type="boolean" name="NanoVG Rendering">
			<value>0</value>
		</NanoVG_Rendering>
	</App_Settings>
	<Debug type="group" name="Debug">
		<Debug_Mode type="boolean" name="Debug Mode">
			<value>1</value>
		</Debug_Mode>
	</Debug>
	<Style_Settings type="group" name="Style Settings">
		<Line_Stroke_Weight type="float" name="Line Stroke Weight">
			<value>3</value>
			<min>1</min>
			<max>20</max>
		</Line_Stroke_Weight>
		<Line_Color type="floatColor" name="Line Color">
			<value>1, 1, 1, 1</value>
		</Line_Color>
		<Line_Blur type="float" name="Line Blur">
			<value>1</value>
			<min>0</min>
			<max>10</max>
		</Line_Blur>
		<Curve_Resolution type="int" name="Curve Resolution">
			<value>10</value>
			<min>3</min>
			<max>30</max>
		</Curve_Resolution>
		<Background_Color type="floatColor" name="Background Color">
			<value>0, 0, 0, 1</value>
		</Background_Color>
	</Style_Settings>
	<Display_Settings type="group" name="Display Settings">
		<Display_Count type="int" name="Display Count">
			<value>1</value>
			<min>1</min>
			<max>8</max>
		</Display_Count>
		<Soft_Edge_Amount type="float" name="Soft Edge Amount">
			<value>0</value>
			<min>0</min>
			<max>150</max>
		</Soft_Edge_Amount>
	</Display_Settings>
	<Mask_Settings type="group" name="Mask Settings">
		<Enable_Mask type="boolean" name="Enable Mask">
			<value>1</value>
		</Enable_Mask>
		<Mask_Feathering type="int" name="Mask Feathering">
			<value>4</value>
			<min>0</min>
			<max>20</max>
		</Mask_Feathering>
	</Mask_Settings>
	<Camera_Blocks type="group" name="Camera Blocks">
		<Use_Camera_Blocks type="boolean" name="Use Camera Blocks">
			<value>0</value>
		</Use_Camera_Blocks>
	</Camera_Blocks>
	<Physics_Settings type="group" name="Physics Settings">
		<Space_Damping type="float" name="Space Damping">
			<value>0.841</value>
			<min>0</min>
			<max>1</max>
		</Space_Damping>
		<Gravity_X type="float" name="Gravity X">
			<value>0</value>
			<min>-20</min>
			<max>20</max>
		</Gravity_X>
		<Gravity_Y type="float" name="Gravity Y">
			<value>0</value>
			<min>-20</min>
			<max>20</max>
		</Gravity_Y>
		<Max_Node_Speed type="float" name="Max Node Speed">
			<value>0</value>
			<min>0</min>
			<max>20</max>
		</Max_Node_Speed>
		<Node_Mass type="float" name="Node Mass">
			<value>3.305</value>
			<min>0.01</min>
			<max>20</max>
		</Node_Mass>
		<Node_Coll__Shape_Radius type="float" name="Node Coll. Shape Radius">
			<value>8.801</value>
			<min>0.01</min>
			<max>200</max>
		</Node_Coll__Shape_Radius>
		<Force_Multiplier type="float" name="Force Multiplier">
			<value>20.879</value>
			<min>0</min>
			<max>200</max>
		</Force_Multiplier>
		<Spring_Tension type="float" name="Spring Tension">
			<value>616.077</value>
			<min>1</min>
			<max>2000</max>
		</Spring_Tension>
		<Spring_Force_Clamp type="float" name="Spring Force Clamp">
			<value>1000</value>
			<min>1</min>
			<max>1000</max>
		</Spring_Force_Clamp>
		<Cross_Spring_Tension type="float" name="Cross Spring Tension">
			<value>494.505</value>
			<min>0</min>
			<max>2000</max>
		</Cross_Spring_Tension>
		<Edge_Spring_Tension_Multiplier type="float" name="Edge Spring Tension Multiplier">
			<value>0.5</value>
			<min>0.001</min>
			<max>2</max>
		</Edge_Spring_Tension_Multiplier>
		<Spring_Dampening type="float" name="Spring Dampening">
			<value>65.934</value>
			<min>0</min>
			<max>3000</max>
		</Spring_Dampening>
		<Segment_Divisions type="int" name="Segment Divisions">
			<value>15</value>
			<min>2</min>
			<max>40</max>
		</Segment_Divisions>
		<Space_Iterations type="int" name="Space Iterations">
			<value>2</value>
			<min>1</min>
			<max>15</max>
		</Space_Iterations>
		<Space_Timestep type="float" name="Space Timestep">
			<value>0.02</value>
			<min>0.01</min>
			<max>0.1</max>
		</Space_Timestep>
		<Barrier_Segment_Width type="float" name="Barrier Segment Width">
			<value>2</value>
			<min>1</min>
			<max>20</max>
		</Barrier_Segment_Width>
		<Force_Threshold type="float" name="Force Threshold">
			<value>0</value>
			<min>0</min>
			<max>10</max>
		</Force_Threshold>
		<Use_Particles type="boolean" name="Use Particles">
			<value>1</value>
		</Use_Particles>
		<BB_Min_Trigger_Force type="float" name="BB Min Trigger Force">
			<value>1.648</value>
			<min>0</min>
			<max>20</max>
		</BB_Min_Trigger_Force>
		<BB_Force_Mult type="float" name="BB Force Mult">
			<value>6.467</value>
			<min>1</min>
			<max>200</max>
		</BB_Force_Mult>
		<BB_Mass type="float" name="BB Mass">
			<value>0.1</value>
			<min>0.1</min>
			<max>5</max>
		</BB_Mass>
		<BB_Radius type="float" name="BB Radius">
			<value>80</value>
			<min>5</min>
			<max>200</max>
		</BB_Radius>
		<BB_Min_Speed type="float" name="BB Min Speed">
			<value>6.703</value>
			<min>0</min>
			<max>20</max>
		</BB_Min_Speed>
		<BB_Max_Speed type="float" name="BB Max Speed">
			<value>0</value>
			<min>0</min>
			<max>1000</max>
		</BB_Max_Speed>
		<Particle_Min_Age type="float" name="Particle Min Age">
			<value>1.841</value>
			<min>1</min>
			<max>10</max>
		</Particle_Min_Age>
		<delete_me type="vec2" name="delete me">
			<value>120, 400</value>
		</delete_me>
	</Physics_Settings>
	<VideoProcessChains type="group" name="VideoProcessChains" />
	<Multilines type="group" name="Multilines" />
</Nervous_Structure>
''';