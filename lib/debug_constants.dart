
var kXmlTestString = '''
<ParameterServer>
	<Parameters>
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
			<A_Rectangle type="ofRectangle" name="A Rectangle">
				<value>370, 458, 0, 132, 120</value>
			</A_Rectangle>
			<Circle_X type="double" name="Circle X">
				<value>263.804</value>
				<min>0</min>
				<max>1000</max>
			</Circle_X>
			<Circle_Y type="double" name="Circle Y">
				<value>10</value>
				<min>0</min>
				<max>1000</max>
			</Circle_Y>
			<Circle_Radius type="double" name="Circle Radius">
				<value>96.1145</value>
				<min>0</min>
				<max>500</max>
			</Circle_Radius>
			<Circle_Color type="floatColor" name="Circle Color">
				<value>0.65098, 0.552941, 0.952941, 1</value>
			</Circle_Color>
		</Model_Example>
	</Parameters>
	<Methods>
		<foo uiName="Foo" />
		<revert uiName="Revert" />
		<save uiName="Save" />
		<set uiName="Set parameter" />
		<connect uiName="Connect" />
		<getModel uiName="Get model" />
	</Methods>
</ParameterServer>
''';

var kXmlTestString2 = '''
<ParameterServer>
	<Parameters>
		<Nervous_Structure type="group" name="Nervous Structure">
			<App_Settings type="group" name="App Settings">
				<Output_Width type="int" name="Output Width">
					<value>2560</value>
					<min>640</min>
					<max>6000</max>
				</Output_Width>
				<Output_Height type="int" name="Output Height">
					<value>1440</value>
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
					<value>3.297</value>
					<min>1</min>
					<max>20</max>
				</Line_Stroke_Weight>
				<Line_Color type="floatColor" name="Line Color">
					<value>1, 1, 1, 1</value>
				</Line_Color>
				<Line_Blur type="float" name="Line Blur">
					<value>0.495</value>
					<min>0</min>
					<max>10</max>
				</Line_Blur>
				<Curve_Resolution type="int" name="Curve Resolution">
					<value>10</value>
					<min>3</min>
					<max>30</max>
				</Curve_Resolution>
				<Background_Color type="floatColor" name="Background Color">
					<value>1e-06, 9.9999e-07, 9.9999e-07, 1</value>
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
				<Masks type="group" name="Masks">
					<MaskPath_0 type="ofPath" name="MaskPath_0">
						<value>&lt;ofPath&gt;
	&lt;points&gt;
		&lt;point type="0" position="128.106, 50.168, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="1369.68, 40.8141, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="867, 1003, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="40.6903, 961.805, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="7" position="0, 0, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
	&lt;/points&gt;
	&lt;fill color="255, 255, 0, 255" isFilled="0" /&gt;
	&lt;stroke color="255, 255, 0, 255" strokeWidth="2" /&gt;
&lt;/ofPath&gt;
</value>
					</MaskPath_0>
				</Masks>
				<Enable_Mask type="boolean" name="Enable Mask">
					<value>0</value>
				</Enable_Mask>
				<Mask_Feathering type="int" name="Mask Feathering">
					<value>4</value>
					<min>0</min>
					<max>20</max>
				</Mask_Feathering>
			</Mask_Settings>
			<Camera_Blocks type="group" name="Camera Blocks">
				<CameraBlocks type="group" name="CameraBlocks">
					<BlockPath_0 type="ofPath" name="BlockPath_0">
						<value>&lt;ofPath&gt;
	&lt;points&gt;
		&lt;point type="0" position="128, 263, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="3" position="635, 381, 0" cp1="390, 427, 0" cp2="381, 447, 0" /&gt;
		&lt;point type="1" position="443, 669.65, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="244, 472.21, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="7" position="0, 0, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
	&lt;/points&gt;
	&lt;fill color="220, 5, 5, 255" isFilled="0" /&gt;
	&lt;stroke color="220, 5, 5, 255" strokeWidth="2" /&gt;
&lt;/ofPath&gt;
</value>
					</BlockPath_0>
					<BlockPath_1 type="ofPath" name="BlockPath_1">
						<value>&lt;ofPath&gt;
	&lt;points&gt;
		&lt;point type="0" position="742.071, 442.798, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="1142.76, 196.853, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="1309.24, 383.619, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="1259.48, 661.479, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="903.483, 706.234, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="7" position="0, 0, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
	&lt;/points&gt;
	&lt;fill color="220, 5, 5, 255" isFilled="0" /&gt;
	&lt;stroke color="220, 5, 5, 255" strokeWidth="2" /&gt;
&lt;/ofPath&gt;
</value>
					</BlockPath_1>
				</CameraBlocks>
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
					<value>4.623</value>
					<min>0.01</min>
					<max>20</max>
				</Node_Mass>
				<Node_Coll__Shape_Radius type="float" name="Node Coll. Shape Radius">
					<value>8.801</value>
					<min>0.01</min>
					<max>200</max>
				</Node_Coll__Shape_Radius>
				<Force_Multiplier type="float" name="Force Multiplier">
					<value>54.945</value>
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
					<value>17.401</value>
					<min>1</min>
					<max>200</max>
				</BB_Force_Mult>
				<BB_Mass type="float" name="BB Mass">
					<value>0.262</value>
					<min>0.1</min>
					<max>5</max>
				</BB_Mass>
				<BB_Radius type="float" name="BB Radius">
					<value>83.214</value>
					<min>5</min>
					<max>200</max>
				</BB_Radius>
				<BB_Min_Speed type="float" name="BB Min Speed">
					<value>20</value>
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
					<min>0, 0</min>
					<max>1000, 1000</max>
				</delete_me>
			</Physics_Settings>
			<Multilines type="group" name="Multilines">
				<Multiline_0 type="group" name="Multiline_0">
					<Guidelines type="group" name="Guidelines">
						<Guideline_0 type="ofPath" name="Guideline_0">
							<value>&lt;ofPath&gt;
	&lt;points&gt;
		&lt;point type="0" position="0, 0, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="2560, 0, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
	&lt;/points&gt;
	&lt;fill color="255, 0, 255, 255" isFilled="0" /&gt;
	&lt;stroke color="255, 0, 255, 255" strokeWidth="2" /&gt;
&lt;/ofPath&gt;
</value>
						</Guideline_0>
						<Guideline_1 type="ofPath" name="Guideline_1">
							<value>&lt;ofPath&gt;
	&lt;points&gt;
		&lt;point type="0" position="0, 1440, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
		&lt;point type="1" position="2560, 1440, 0" cp1="0, 0, 0" cp2="0, 0, 0" /&gt;
	&lt;/points&gt;
	&lt;fill color="255, 0, 255, 255" isFilled="0" /&gt;
	&lt;stroke color="255, 0, 255, 255" strokeWidth="2" /&gt;
&lt;/ofPath&gt;
</value>
						</Guideline_1>
					</Guidelines>
					<Number_of_Lines type="int" name="Number of Lines">
						<value>200</value>
						<min>2</min>
						<max>600</max>
					</Number_of_Lines>
				</Multiline_0>
			</Multilines>
			<VideoProcessChains type="group" name="VideoProcessChains">
				<Stream_1 type="group" name="Stream_1">
					<Running type="boolean" name="Running">
						<value>1</value>
					</Running>
					<Mirror_Video type="boolean" name="Mirror Video">
						<value>1</value>
					</Mirror_Video>
					<Capture_Device type="int" name="Capture Device">
						<value>0</value>
						<min>0</min>
						<max>20</max>
					</Capture_Device>
					<Video_Width type="int" name="Video Width">
						<value>320</value>
						<min>1</min>
						<max>1920</max>
					</Video_Width>
					<Video_Height type="int" name="Video Height">
						<value>240</value>
						<min>1</min>
						<max>1080</max>
					</Video_Height>
					<Use_Player type="boolean" name="Use Player">
						<value>0</value>
					</Use_Player>
					<File type="string" name="File">
						<value></value>
					</File>
					<Use_ROI type="boolean" name="Use ROI">
						<value>0</value>
					</Use_ROI>
					<Video_Processes type="group" name="Video Processes">
						<Image_Adjustments type="group" name="Image Adjustments">
							<Process_Type_Name type="string" name="Process Type Name">
								<value>MTImageAdjustmentsVideoProcess</value>
							</Process_Type_Name>
							<Active type="boolean" name="Active">
								<value>1</value>
							</Active>
							<Auto_Levels type="boolean" name="Auto Levels">
								<value>0</value>
							</Auto_Levels>
							<Adaptive_Auto_Levels type="boolean" name="Adaptive Auto Levels">
								<value>0</value>
							</Adaptive_Auto_Levels>
							<Adaptive_Clip_Limit type="float" name="Adaptive Clip Limit">
								<value>10</value>
								<min>1</min>
								<max>30</max>
							</Adaptive_Clip_Limit>
							<Gamma type="float" name="Gamma">
								<value>1</value>
								<min>0</min>
								<max>2</max>
							</Gamma>
							<Brightness type="float" name="Brightness">
								<value>0</value>
								<min>-1</min>
								<max>1</max>
							</Brightness>
							<Contrast type="float" name="Contrast">
								<value>0</value>
								<min>-1</min>
								<max>1</max>
							</Contrast>
							<Denoise type="boolean" name="Denoise">
								<value>0</value>
							</Denoise>
						</Image_Adjustments>
						<Background_Substraction type="group" name="Background Substraction">
							<Process_Type_Name type="string" name="Process Type Name">
								<value>MTBackgroundSubstractionVideoProcess</value>
							</Process_Type_Name>
							<Active type="boolean" name="Active">
								<value>1</value>
							</Active>
							<Background_Threshold type="float" name="Background Threshold">
								<value>16</value>
								<min>1</min>
								<max>46</max>
							</Background_Threshold>
							<History_Length type="int" name="History Length">
								<value>500</value>
								<min>100</min>
								<max>2000</max>
							</History_Length>
							<Detect_Shadows type="boolean" name="Detect Shadows">
								<value>1</value>
							</Detect_Shadows>
							<Subtract_background_from_Stream type="boolean" name="Subtract background from Stream">
								<value>0</value>
							</Subtract_background_from_Stream>
						</Background_Substraction>
						<Optical_Flow type="group" name="Optical Flow">
							<Process_Type_Name type="string" name="Process Type Name">
								<value>MTOpticalFlowVideoProcess</value>
							</Process_Type_Name>
							<Active type="boolean" name="Active">
								<value>1</value>
							</Active>
							<Use_Farneback type="boolean" name="Use Farneback">
								<value>1</value>
							</Use_Farneback>
							<fbPyrScale type="float" name="fbPyrScale">
								<value>0.5</value>
								<min>0</min>
								<max>0.99</max>
							</fbPyrScale>
							<fbLevels type="int" name="fbLevels">
								<value>4</value>
								<min>1</min>
								<max>8</max>
							</fbLevels>
							<fbIterations type="int" name="fbIterations">
								<value>2</value>
								<min>1</min>
								<max>8</max>
							</fbIterations>
							<fbPolyN type="int" name="fbPolyN">
								<value>7</value>
								<min>5</min>
								<max>10</max>
							</fbPolyN>
							<fbPolySigma type="float" name="fbPolySigma">
								<value>1.5</value>
								<min>1.1</min>
								<max>2</max>
							</fbPolySigma>
							<fbUseGaussian type="boolean" name="fbUseGaussian">
								<value>0</value>
							</fbUseGaussian>
							<winSize type="int" name="winSize">
								<value>32</value>
								<min>4</min>
								<max>64</max>
							</winSize>
							<Use_Threshold_Filter type="boolean" name="Use Threshold Filter">
								<value>0</value>
							</Use_Threshold_Filter>
							<Threshold type="int" name="Threshold">
								<value>0</value>
								<min>0</min>
								<max>5000</max>
							</Threshold>
						</Optical_Flow>
						<Dynamic_Gate_Process type="group" name="Dynamic Gate Process">
							<Process_Type_Name type="string" name="Process Type Name">
								<value>DynamicGateProcess</value>
							</Process_Type_Name>
							<Active type="boolean" name="Active">
								<value>1</value>
							</Active>
							<Input_Smoothing type="float" name="Input Smoothing">
								<value>0.5</value>
								<min>0</min>
								<max>1</max>
							</Input_Smoothing>
							<Attack_Time type="float" name="Attack Time">
								<value>0</value>
								<min>0</min>
								<max>30</max>
							</Attack_Time>
							<Sustain_Time type="float" name="Sustain Time">
								<value>1</value>
								<min>0</min>
								<max>120</max>
							</Sustain_Time>
							<Release_Time type="float" name="Release Time">
								<value>10</value>
								<min>0</min>
								<max>300</max>
							</Release_Time>
							<Trigger_Level type="float" name="Trigger Level">
								<value>0</value>
								<min>0</min>
								<max>1</max>
							</Trigger_Level>
						</Dynamic_Gate_Process>
					</Video_Processes>
				</Stream_1>
			</VideoProcessChains>
		</Nervous_Structure>
	</Parameters>
	<Methods>
		<add_multiline uiName="Add Multiline" />
		<revert uiName="Revert" />
		<save uiName="Save" />
		<set uiName="Set parameter" />
		<connect uiName="Connect" />
		<getModel uiName="Get model" />
	</Methods>
</ParameterServer>

''';