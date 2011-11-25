<?xml version="1.0" encoding="UTF-8"?>
<validateThis xsi:noNamespaceSchemaLocation="validateThis.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<contexts>
		<context name="delete" />
	</contexts>
	<objectProperties>
		<property name="productTypeName">
			<rule type="required" contexts="*" />
		</property>
		<property name="products">
			<rule type="collectionSize" context="delete">
				<param name="max" value="0" />
			</rule>
		</property>
		<property name="subProductTypes">
			<rule type="collectionSize" context="delete">
				<param name="max" value="0" />
			</rule>
		</property>
	</objectProperties>
</validateThis>