################################################################################

sub do_check_logon {

	out_html ({}, qq {
	
		var p = new Ext.Panel ({
		
			frame : true,
			title : '$i18n->{login}',
			layout : 'form',
			defaultType : 'field',
			
			items : [
			
				{
					fieldLabel : '$i18n->{login}',
					name       : 'login'
				},
				{
					inputType  : 'password',
					fieldLabel : '$i18n->{password}',
					name       : 'password'
				}
			
			],
			
			bbar : [{
				type: 'button',
				text: '$i18n->{execute_logon}'
			}]
		
		});

		center.add (p);

	});

}