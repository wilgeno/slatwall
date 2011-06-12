/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	property name="settingService" type="any";

	public any function savePaymentMethod(required any entity, struct data) {
		if( structKeyExists(arguments, "data") ) {
			// save paymentMethod-specific settings
			for(var item in arguments.data) {
				if(!isObject(arguments.data[item]) && listFirst(item,"_") == "paymentMethod") {
					var setting = getSettingService().getBySettingName(item);
					setting.setSettingName(item);
					setting.setSettingValue(arguments.data[item]);
					getSettingService().save(entity=setting);
				}
			}
		}
		return save(argumentcollection=arguments);
	}
	
	public boolean function processPaymentCreditCard(required any orderPayment, required string processType, numeric processAmount) {
		// Get the relavent info and objects for this order payment
		var paymentMethod = this.getPaymentMethod(arguments.orderPayment.getPaymentMethodID());
		var paymentProviderGateway = paymentMethod.getProviderGateway();
		var providerService = getSettingService().getByPaymentServicePackage(paymentProviderGateway);
		
		// Generate Process Request Bean
		var request = new Slatwall.com.utility.payment.CreditCardProcessRequestBean();
		
		// Move all of the info into the new request bean
		request.populatePaymentInfoWithOrderPayment(arguments.orderPayment);
		
		// Setup the actuall processing information
		if(!structKeyExists(argument, "processAmount")) {
			arguments.processAmount = arguments.orderPayment.getAmount();
		}
		request.setProcessType(arguments.processType);
		request.setProcessAmount(arguments.processAmount);
		request.setProcessCurrency("USD"); // TODO: This is a hack that should be fixed at some point
		
		// Get Response Bean from provider service
		var response = providerService.processPayment(request);
		
		// Update the Order Payment entity
		
		return response;
	}
}