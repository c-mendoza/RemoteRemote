import 'package:flutter/foundation.dart';

var kXmlTestString = '''
<Model_Example>
	<type>group</type>
	<children>
		<App_Settings>
			<type>group</type>
			<children>
				<Output_Width>
					<name>Output Width</name>
					<type>int</type>
					<value>1920</value>
					<min>640</min>
					<max>6000</max>
				</Output_Width>
				<Output_Height>
					<name>Output Height</name>
					<type>int</type>
					<value>1080</value>
					<min>480</min>
					<max>6000</max>
				</Output_Height>
				<Send_OSC>
					<name>Send OSC</name>
					<type>boolean</type>
					<value>0</value>
				</Send_OSC>
			</children>
		</App_Settings>
		<A_Path>
			<name>A Path</name>
			<type>unknown</type>
			<value>{ 0; 0, 0, 0; 0, 0, 0; 0, 0, 0; } { 1; 2550, 0, 0; 0, 0, 0; 0, 0, 0; } { 1; 2550, 1440, 0; 0, 0, 0; 0, 0, 0; } { 1; 0, 1440, 0; 0, 0, 0; 0, 0, 0; } { 7; 0, 0, 0; 0, 0, 0; 0, 0, 0; } </value>
		</A_Path>
	</children>
</Model_Example>''';