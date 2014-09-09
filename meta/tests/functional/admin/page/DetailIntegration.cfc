component extends="PageObject" {
	
	variables.slatAction = "entity.detailintegration";
	
	public any function init(selenium, pageLoadTime) {
		variables.title = selenium.getTitle();
		
		return super.init(argumentCollection=arguments);
	}
	
}