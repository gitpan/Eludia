use ExtUtils::MakeMaker;

WriteMakefile (

    'NAME'		=> 'Eludia',
    'VERSION'	        => "10.04.01.aa790a7",
    'PREREQ_PM'		=> {
	'DBI'			=> '1.21',
	'Number::Format'	=> '1.45',
	'Date::Calc'		=> '',
	'JSON'			=> '1.43',
    },

    (5.010000 >= 5.005 ?    
	(
		ABSTRACT   => 'A RAD platform for WEB GUIs with rich DHTML widget set.', 
		AUTHOR     => 'D. Ovsyanko') : ()
	)
    ); 
