package Eludia::Presentation::Skins::TurboMilk;

use Data::Dumper;
use Storable ('freeze');

no warnings;

BEGIN {

	require Eludia::Presentation::Skins::Generic;
	delete $INC {"Eludia/Presentation/Skins/Generic.pm"};

	our $replacement = {
		error    => 'JS',
		redirect => 'JS',
	};

}

################################################################################

sub msie_less_7 {

	$r -> headers_in -> {'User-Agent'} =~ /MSIE (\d)/ or return 0;
	
	return $1 < 7;

}

################################################################################

sub options {

	return {
		core_unblock_navigation => $preconf -> {core_unblock_navigation},
	};
	
}

################################################################################

sub register_hotkey {

	my ($_SKIN, $hashref) = @_;

	$hashref -> {label} =~ s{\&(.)}{<u>$1</u>} or return undef;
	
	return undef if $_REQUEST {__edit};

	my $c = $1;
		
	if ($c eq '<') {
		return 37;
	}
	elsif ($c eq '>') {
		return 39;
	}
	elsif (lc $c eq '�') {
		return 186;
	}
	elsif (lc $c eq '�') {
		return 222;
	}
	else {
		$c =~ y{����������������������������������������������������������������}{qwertyuiop[]asdfghjkl;'zxcvbnm,.qwertyuiop[]asdfghjkl;'zxcvbnm,.};
		return (ord ($c) - 32);
	}

}

################################################################################

sub static_path {

	my ($package, $file) = @_;
	my $path = __FILE__;

	$path    =~ s{\.pm}{/$file};

	return $path;

};

################################################################################

sub draw_hr {

	my ($_SKIN, $options) = @_;
		
	return <<EOH;
EOH
	
}

################################################################################

sub draw_gantt_bars {

	my ($_SKIN, $options) = @_;
	
	my $top = 5;
	my $html = '';
	
	$options -> {plan} -> {color} ||= 'blue';
	$options -> {fact} -> {color} ||= 'red';
	
	foreach my $key ('plan', 'fact') {
	
		my $bar = $options -> {$key};
	
		my @pf = split /-/, $bar -> {from};
		my $dpf = $pf [2] / 30;

		my @pt = split /-/, $bar -> {to};
		my $dpt = $pf [2] / 30;

		$html .= <<EOH;
			<td style="
				border:solid black 1px;
				height:7px;
				z-index:0;
				position:absolute;
				top:  expression(this.previousSibling.offsetTop + $top);
				left: expression(getElementById('gantt_$pf[0]_$pf[1]').offsetLeft + $dpf * getElementById('gantt_$pf[0]_$pf[1]').offsetWidth);
				width:expression(getElementById('gantt_$pt[0]_$pt[1]').offsetLeft + $dpt * getElementById('gantt_$pt[0]_$pt[1]').offsetWidth - getElementById('gantt_$pf[0]_$pf[1]').offsetLeft - $dpf * getElementById('gantt_$pf[0]_$pf[1]').offsetWidth);
				background-color:$bar->{color}
			" title="$bar->{title}"><img src='/0.gif' width=1 height=1></td>
EOH

		$top = 6;

	}
	
	return $html;

}

################################################################################

sub draw_calendar {
	
	my $month_names = $_JSON -> encode ($i18n -> {months});
	
	qq {
		
		<script>var __month_names = $month_names;</script>
	
		<span id='clock_d'></span>&nbsp;&nbsp;&nbsp;<span id='clock_h'></span><span id='clock_s' style='width:5px'></span><span id='clock_m'></span>
		
	}

}

################################################################################

sub draw_auth_toolbar {

	my ($_SKIN, $options) = @_;

	my $logout_url = $conf -> {exit_url} || create_url (type => '_logout', id => '');
	my $logo_url = $conf -> {logo_url};

	my ($header, $header_height, $subset_div, $subset_div, $subset_cell);
	
	my $header_prefix = 'out';
	
	if ($_USER -> {id}) {
	
		if ($_USER -> {f} && $_USER -> {i}) {
	
			$$options {user_label} =~ s/$$i18n{User}: ${\($$_USER{label} || $$i18n{not_logged_in})}//;
		
			$$options {user_label} = '<nobr><b>' . $_USER -> {f} . ' ' . substr ($_USER -> {i}, 0, 1) . '. ' . substr ($_USER -> {o}, 0, 1) . '.</b></nobr><br>' . $options -> {user_label}
			
		}

		if (@{$_SKIN -> {subset} -> {items}} > 1) {				
		
#			my $href = create_url (type => '', id => '');
			$_REQUEST {__uri_root} || create_url ();
			my $href = $_REQUEST {__uri_root};
		
			$subset_div = <<EOH;
				<div id="Menu">
					<table border="0" cellpadding="0" cellspacing="0">
EOH
		
			for (my $i = 0; $i < @{$_SKIN -> {subset} -> {items}}; $i++) {
			
				my $item = $_SKIN -> {subset} -> {items} -> [$i];

				if ($item -> {name} eq $_SKIN -> {subset} -> {name}) {
				
					$subset_cell = <<EOH;
						<td width="5" align="center"><img src="$_REQUEST{__static_url}/vline.gif?$_REQUEST{__static_salt}" width="2px" height="28px"></td>
						<td><img src="$_REQUEST{__static_url}/0.gif" border="0" hspace="0" width=5 height=1></td>
						<td><div id="admin" onClick="subsets_are_visible = 1 - subsets_are_visible; document.getElementById ('_body_iframe').contentWindow.subsets_are_visible = subsets_are_visible"><a href="#">$$item{label}</a></div></td>
EOH
				
				}
#				else {
				
					my $class = $i == @{$_SKIN -> {subset} -> {items}} - 1 ? 'mm0' : 'mm';

					$subset_div .= <<EOH;
						<tr @{[$item -> {name} eq $_SKIN -> {subset} -> {name} ? 'style="display: none"' : '']} id="_subset_tr_$$item{name}"><td class="$class"><a id="_subset_a_$$item{name}" onClick="subset_on_change('$$item{name}', '$href&__subset=$$item{name}')" href="#">$$item{label}</a></td></tr>
EOH
#				}
			
			}
			
			$subset_div .= <<EOH;
				<tr><td><img src="$_REQUEST{__static_url}/menu_bottom.gif?$_REQUEST{__static_salt}" border="0"></td></tr>
			</table>
		</div>
EOH
		
		}

		$header_height = 48;
		$header_prefix = 'in';
		
		my $calendar = draw_calendar ();

		$header = <<EOU;

			$subset_cell

			<td>&nbsp;</td>

			<td width="1" align="center"><img src="$_REQUEST{__static_url}/vline.gif?$_REQUEST{__static_salt}" width="2" height="28" hspace=10></td>
			<td align="left" class="txt1" nowrap>$calendar</td>

			<td width="1" align="center"><img src="$_REQUEST{__static_url}/vline.gif?$_REQUEST{__static_salt}" width="2" height="28" hspace=10></td>
			<td align="left" class="txt1">$$options{user_label}</td>

			<td width="1" align="center"><img src="$_REQUEST{__static_url}/vline.gif?$_REQUEST{__static_salt}" width="2px" height="28" hspace=10></td>
			<td width="50" align="right" nowrap><nobr><a class="button" href="$logout_url">&nbsp;$i18n->{Exit}&nbsp;<img src="$_REQUEST{__static_url}/i_exit.gif?$_REQUEST{__static_salt}" width="14px" height="10px" border="0"></a></nobr></td>
EOU
	} elsif ($$conf{logon_hint}) {
		$header_height = 90;

		$header = <<EOH;
			<td><table border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td><img src="$_REQUEST{__static_url}/hint_l.gif?$_REQUEST{__static_salt}" width="6" height="61" border=0></td>
					<td background="$_REQUEST{__static_url}/hint_bg.gif?$_REQUEST{__static_salt}" style='padding-left: 10px; padding-right: 10px;'><img src="$_REQUEST{__static_url}/exclam.gif?$_REQUEST{__static_salt}" width="30" height="34" border=0></td>
					<td background="$_REQUEST{__static_url}/hint_bg.gif?$_REQUEST{__static_salt}" style='padding: 2px;' class="txt1"><img src="$_REQUEST{__static_url}/hint_title.gif?$_REQUEST{__static_salt}" width="144" height="16" border=0><br>$$conf{logon_hint}</td>
					<td><img src="$_REQUEST{__static_url}/hint_r.gif?$_REQUEST{__static_salt}" width="6" height="61" border=0></td>
				</tr>
			</table></td>

EOH
	} else {
		$header_height = 90;
	}
	return <<EOH;
		<table id="logo_table" cellSpacing=0 cellPadding=0 width="100%" border=0 bgcolor="#e5e5e5" background="$_REQUEST{__static_site}/i/bg_logo_$header_prefix.gif" style="background-repeat: repeat-x">
			<tr>
			<td width="20"><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=20 height=$header_height border=0></td>
			<td width=1><table border=0 valign="middle" border=0><tr>
				<td valign="top" width=1><a href="$logo_url"><img src="$_REQUEST{__static_site}/i/logo_$header_prefix.gif" border="0"></a></td>
				<td width=1><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=10 height=1 border=0></td>
				<td width=1 valign="bottom" style='padding-bottom: 5px;'><img src="$_REQUEST{__static_url}/gsep.gif?$_REQUEST{__static_salt}" width="4" height="21"></td>
				<td align="left" valign="middle" class='header_0' width=1><nobr>&nbsp;$$conf{page_title}</nobr></td>
			</tr></table></td>

			$header
			<td width="20px" align="right">&nbsp;</td></tr>
		 </table>
		$subset_div
		$$options{top_banner}
EOH


}

################################################################################

sub draw_window_title {

	my ($_SKIN, $options) = @_;
	
	if ($_REQUEST {select}) {
	
		$_REQUEST {__script} .= <<EOJ;
			top.document.title = '$$options{label}';
EOJ
		return '';
		
	} else {
	 
		return <<EOH
			<table cellspacing=0 cellpadding=0 width="100%"><tr><td bgcolor="#edf1f5" class="header_3"><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 height=29 align=absmiddle>&nbsp;&nbsp;&nbsp;$$options{label}</td></tr><tr><td bgcolor="#e4e9ee"><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 height=1></td></tr></table>
EOH

	}

}

################################################################################
# FORMS & INPUTS
################################################################################

sub _draw_bottom {

	my ($_SKIN, $options) = @_;
	
	unless ($options -> {menu}) {
		return <<EOH;
			<table cellspacing=0 cellpadding=0 width="100%">
				<tr>
					<td class=bgr6><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
			</table>
EOH
	}
	
	my $html = '';
	my $items = $options -> {menu};
		
	foreach my $item (@$items) {
		if ($item -> {is_active}) {
			$html .= <<EOH;
				<td width=5><img src="$_REQUEST{__static_url}/tab_l_1.gif?$_REQUEST{__static_salt}" width=5 height=22 border=0></td>
				<td bgcolor="#ffffff"><a id="$item" href="$$item{href}" class="tab-1"><nobr>&nbsp;$$item{label}&nbsp;</nobr></a></td>
				<td width=5><img src="$_REQUEST{__static_url}/tab_r_1.gif?$_REQUEST{__static_salt}" width=5 height=22 border=0></td>
				<td width=4><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=4 height=22 border=0></td>
EOH
		} else {
			$html .= <<EOH;
				<td width=5><img src="$_REQUEST{__static_url}/tab_l_0.gif?$_REQUEST{__static_salt}" width=5 height=22 border=0></td>
				<td background="$_REQUEST{__static_url}/tab_bg_0.gif?$_REQUEST{__static_salt}"><a id="$item" href="$$item{href}" class="tab-0"><nobr>&nbsp;$$item{label}&nbsp;</nobr></a></td>
				<td width=5><img src="$_REQUEST{__static_url}/tab_r_0.gif?$_REQUEST{__static_salt}" width=5 height=22 border=0></td>
				<td width=4><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=4 height=22 border=0></td>
EOH
		}

	}
			
	return <<EOH;
		<table border=0 cellspacing=0 cellpadding=0 width=100%>
			<tr>
				<td background="$_REQUEST{__static_url}/tab_bg.gif?$_REQUEST{__static_salt}" width=10><img height="33" src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=10 border=0></td>
				<td background="$_REQUEST{__static_url}/tab_bg.gif?$_REQUEST{__static_salt}" valign="bottom" align="right"><table border=0 cellspacing=0 cellpadding=0>
					<tr>$html</tr></table>
				</td>
			</tr>
			<tr>
				<td bgcolor="#ffffff" colspan=2><img height="8" src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
			</tr>
		</table>
EOH

}

################################################################################

sub _draw_input_datetime {

	return '' if $_REQUEST {__only_field};

	my ($_SKIN, $options) = @_;
		
	$options -> {id} ||= '' . $options;
	
	$options -> {onClose}    ||= 'null';
	$options -> {onKeyDown}  ||= 'null';
	$options -> {onKeyPress} ||= 'if (window.event.keyCode != 27) is_dirty=true';
	
	my $attributes = dump_attributes ($options -> {attributes});
			
	my $shows_time = $options -> {no_time} ? 'false' : 'true';
		
	my $html = <<EOH;
		<nobr>
		<input 
			type="text" 
			name="$$options{name}" 
			$attributes 
			autocomplete="off" 
			onFocus="scrollable_table_is_blocked = true; q_is_focused = true; this.select()" 
			onBlur="scrollable_table_is_blocked = false; q_is_focused = false" 
			onKeyPress="$$options{onKeyPress}" 
			onKeyDown="$$options{onKeyDown}"
		>
		<img id="calendar_trigger_$$options{id}" src="$_REQUEST{__static_url}/i_calendar.gif" align=absmiddle>
		</nobr>		
		<script type="text/javascript">
			
			i18n_calendar (Calendar);
			
			Calendar.setup (
				{
					inputField : "input$$options{name}",
					ifFormat   : "$$options{format}",
					showsTime  : $shows_time,
					button     : "calendar_trigger_$$options{id}",
					onClose    : $$options{onClose}
				}
			);
			
		</script>

EOH

	return $html;
	
}

################################################################################

sub draw_form {

	my ($_SKIN, $options) = @_;
		
	if ($_REQUEST {__only_field}) {
		return '';	
	}
			
	my $html = $options -> {hr};
	
	
	$html .= $options -> {path};

	$html .= _draw_bottom (@_);
	
	$html .=  <<EOH;
		<table cellspacing=0 width="100%" style="border-style:solid; border-top-width: 1px; border-left-width: 1px; border-bottom-width: 0px; border-right-width: 0px; border-color: #d6d3ce;">
			<form 
				name="$$options{name}"
				target="$$options{target}"
				method="$$options{method}"
				enctype="$$options{enctype}"
				action="$_REQUEST{__uri}"
			>
			<input type=hidden name="__suggest" value="">
EOH

	$html .= dump_hiddens (
	
		map {[$_ -> {name} => $_ -> {value}]}
		
			@{$options -> {keep_params}}

	);
	
	foreach my $row (@{$options -> {rows}}) {
		my $tr_id = $row -> [0] -> {tr_id};
		$html .= qq{<tr id="$tr_id">};
		foreach (@$row) { $html .= $_ -> {html} };
		$html .= qq{</tr>};
	}

	$html .=  '</form></table>';
	
	$html .= $options -> {bottom_toolbar};
	
	return $html;	

}


################################################################################

sub draw_path {

	my ($_SKIN, $options, $list) = @_;
	
	$options -> {style} ||= $options -> {nowrap} ? qq{style="background:url('$_REQUEST{__static_url}/bgr_grey.gif?$_REQUEST{__static_salt}');background-repeat:repeat-x;"} : '';
		
	my $path = <<EOH;
		<table cellspacing=0 cellpadding=0 width="100%" border=0>
			<tr>
				<td>
					<table cellspacing=0 cellpadding=0 width="100%" border=0>
						<tr>
							<td class="toolbar" $$options{style}>
								<img height=29 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0>
							</td>
							<td class="toolbar" $$options{style} $$options{nowrap}>&nbsp;
EOH

	my $icon = $options -> {status} ? "status_$options->{status}->{icon}.gif" : 'i_folder.gif';

	$path .= qq{<img src="$_REQUEST{__static_url}/${icon}?$_REQUEST{__static_salt}" border=0 hspace=3 vspace=1 align=absmiddle>&nbsp;};

	for (my $i = 0; $i < @$list; $i ++) {
	
		if ($i > 0) {
			$path .= '&nbsp;/&nbsp;';
			if ($options -> {multiline}) {
				$path .= '<br>';
				for (my $j = 0; $j < $i + 2; $j++) { $path .= '&nbsp;&nbsp;' }
			}
		}
		
		my $item = $list -> [$i];		
		
		$path .= qq{<a class=path ${\($$item{href} ? "href='$$item{href}'" : '')} TABINDEX=-1>$$item{label}</a>};
	
	}
	
	$path .= <<EOH;
&nbsp;</td>
						</tr>
						<tr>
							<td bgcolor="#e4e9ee" colspan=2><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
EOH

	return $path;

}

################################################################################

sub draw_form_field {

	my ($_SKIN, $field, $data) = @_;
	
	if ($field -> {type} eq 'banner') {
		my $colspan     = 'colspan=' . ($field -> {colspan} + 1);
		return qq{<td class='form-$$field{state}-banner' $colspan nowrap align=center>$$field{html}</td>};
	}
	elsif ($field -> {type} eq 'article') {
		my $colspan     = 'colspan=' . ($field -> {colspan} + 1);
		return qq{<td $colspan class='form-article'>$$field{html}</td>};
	}
	elsif ($field -> {type} eq 'hidden') {
		return $field -> {html};
	}
				
	my $colspan       = $field -> {colspan}       ? 'colspan=' . $field -> {colspan}       : '';
	my $colspan_label = $field -> {colspan_label} ? 'colspan=' . $field -> {colspan_label} : '';
	my $label_width   = $field -> {label_width}   ? 'width='   . $field -> {label_width}   : '';	
	my $cell_width    = $field -> {cell_width}    ? 'width='   . $field -> {cell_width}    : '';
	my $label_title   = $field -> {label_title}   ? 'title="'  . $field -> {label_title} . '"' : '';
	
	my $label_cell;
	$label_cell = qq {<td class='form-$$field{state}-label' nowrap $colspan_label align=right $label_width $label_title>\n$$field{label}</td>}
		unless ($field -> {label_off});

	my $inputs = 'inputs';
	if ($field -> {fake} == -1) {
	    $inputs = 'deleted';
	}

	return <<EOH;
		$label_cell
		<td class='form-$$field{state}-$inputs' $colspan $cell_width>\n$$field{html}</td>
EOH

}

################################################################################

sub draw_form_field_banner {
	my ($_SKIN, $field, $data) = @_;
	return $field -> {label};
}

################################################################################

sub draw_form_field_button {
	my ($_SKIN, $options, $data) = @_;
	return qq {<input type="button" name="_$$options{name}" value="$$options{value}" onClick="$$options{onclick}" tabindex=$tabindex>};
}

################################################################################

sub draw_form_field_string {

	my ($_SKIN, $options) = @_;
	
	my $attributes = $options -> {attributes};
	
	$attributes -> {onKeyPress} .= ';if (window.event.keyCode != 27) is_dirty=true;';
	$attributes -> {onKeyDown}  .= ';tabOnEnter();';
	$attributes -> {onFocus}    .= ';scrollable_table_is_blocked = true; q_is_focused = true;';
	$attributes -> {onBlur}     .= ';scrollable_table_is_blocked = false; q_is_focused = false;';
	$attributes -> {type}        = 'text';

	return dump_tag ('input', $attributes);

}

################################################################################

sub draw_form_field_suggest {

	my ($_SKIN, $options, $data) = @_;

	$_REQUEST {__script} .= qq{; 	

		function off_suggest_$options->{name} () {
			var s = document.getElementById ('_$options->{name}__suggest'); 
			s.style.display = 'none';
		}; 
		
	};
	
	$options -> {attributes} -> {onKeyPress} .= ';if (window.event.keyCode != 27) is_dirty=true;';
	$options -> {attributes} -> {onKeyDown}  .= ';tabOnEnter();';
	$options -> {attributes} -> {onFocus}    .= ';scrollable_table_is_blocked = true; q_is_focused = true;';
	$options -> {attributes} -> {onBlur}     .= qq{;scrollable_table_is_blocked = false; q_is_focused = false; getElementById('_$options->{name}__label').value = this.value; _suggest_timer_$options->{name} = setTimeout (off_suggest_$options->{name}, 100);};
	$options -> {attributes} -> {onChange}   .= "$$options{after};";

	$options -> {attributes} -> {onKeyDown}  .= <<EOH;
	
		var s = getElementById('_$options->{name}__suggest');

		if (window.event.keyCode == 40 && s.style.display == 'block') {
			s.focus ();
		}
   
EOH
	
	
	$options -> {attributes} -> {onKeyUp} .= <<EOH;
		if (suggest_clicked) {
			suggest_clicked = 0;
		}
		else {
			var f = this.form;
			f.elements ['_$options->{name}__label'].value = '';
			f.elements ['_$options->{name}__id'].value = '';
			var s = f.elements ['__suggest'];
			document.getElementById ('_$options->{name}__suggest').style.display = 'none';
			if (this.value.length > 0) {
				s.value = '$options->{name}';
				document.getElementById ('_$options->{name}__label').value = this.value;
				f.submit ();
				s.value = '';
			}
		}
EOH

	my $id = '' . $options;
	
	$options -> {attributes} -> {id}           = $id;
	$options -> {attributes} -> {autocomplete} = 'off';
	$options -> {attributes} -> {type}         = 'text';

	return qq {
		<script>
			var _suggest_timer_$options->{name} = null;
		</script>
		<select 
			id="_$options->{name}__suggest" 
			name="_$options->{name}__suggest" 
			size="$options->{lines}"
			style="
				display : none;
				position: absolute;
				border  : solid black 1px;
				z-index : 100;
			"
			onFocus="
				if (_suggest_timer_$options->{name}) {
					clearTimeout (_suggest_timer_$options->{name});
					_suggest_timer_$options->{name} = null;
				}
			"
			onBlur="this.style.display='none'; $$options{after}"
			onDblClick="set_suggest_result (this, '$id'); $$options{after}"
			onKeyPress="set_suggest_result (this, '$id'); $$options{after}; suggest_clicked = 1"
		>
		</select>
		
	}
	
	. dump_tag (input => $options -> {attributes})

	. dump_tag (input => {
		type  => 'hidden',
		id    => "${id}__label",
		name  => "_$options->{name}__label",
		value => $options -> {attributes} -> {value},
	})

	. dump_tag (input => {
		type  => 'hidden',
		id    => "${id}__id",
		name  => "_$options->{name}__id",
		value => $options -> {value__id},
	});

}

################################################################################

sub draw_form_field_datetime {

	my ($_SKIN, $options, $data) = @_;
		
	$options -> {name} = '_' . $options -> {name};
	$options -> {onKeyDown} ="tabOnEnter()";

	return $_SKIN -> _draw_input_datetime ($options);
	
}

################################################################################

sub draw_form_field_file {

	my ($_SKIN, $options, $data) = @_;	
		
	my $attributes = dump_attributes ($options -> {attributes});

	return <<EOH;
		<input 
			type="file"
			name="_$$options{name}"
			size=$$options{size}
			$attributes
			onFocus="scrollable_table_is_blocked = true; q_is_focused = true"
			onBlur="scrollable_table_is_blocked = false; q_is_focused = false"
			onChange="is_dirty=true; $$options{onChange}"
			onKeyDown="if (event.keyCode != 9) return false;"
			tabindex=-1
		>
EOH

}

################################################################################

sub draw_form_field_files {

	my ($_SKIN, $options, $data) = @_;	
		
	my $attributes = dump_attributes ($options -> {attributes});
	
	my $tail = qq {
		type="file"
		size=$$options{size}
		$attributes
		onFocus="scrollable_table_is_blocked = true; q_is_focused = true"
		onBlur="scrollable_table_is_blocked = false; q_is_focused = false"
		onChange="is_dirty=true; $$options{onChange}"
		tabindex=-1
	};
	
	$tail =~ y{'}{"}; #"'
	$tail =~ s{[\n\r\t]+}{ }gsm;
	
	$_REQUEST {__script} .= <<EOH;
	
		var file_field_$options->{name}_cnt = 1;
		
		function file_field_add_$options->{name} () {
		
			document.body.style.cursor = 'default';

			var d = document.getElementById ('file_field_$options->{name}');

			file_field_$options->{name}_cnt ++;

			d.insertAdjacentHTML ('beforeEnd', '<br><input name="_$$options{name}_' + file_field_$options->{name}_cnt  + '" $tail>');
		
		}
	
EOH

	return <<EOH;
	
		<input 
			type="hidden"
			name="__$$options{name}_file_field"
			value="$options->{field}"
		>
		
		<span id="file_field_$options->{name}"><input name="_$$options{name}_1" $tail>&nbsp;<a href="javaScript:file_field_add_$options->{name}();void(0);"><img height=18 src="$_REQUEST{__static_url}/tree_nolines_plus.gif?$_REQUEST{__static_salt}" width=18 border=0 align=absmiddle></a></span>

EOH

}

################################################################################

sub draw_form_field_hidden {

	my ($_SKIN, $options, $data) = @_;
	
	return dump_tag (input => {
		type  => 'hidden', 
		name  => '_' . $options -> {name},
		value => $options -> {value},
	});
	
}

################################################################################

sub draw_form_field_hgroup {

	my ($_SKIN, $options, $data) = @_;
	my $html = '';
	
	$html .= '<nobr>'
		if ($options -> {nobr});
		 
	foreach my $item (@{$options -> {items}}) {
		next if $item -> {off};
		$html .= $item -> {label} if $item -> {label};
		$html .= $item -> {html};
		$html .= '&nbsp;';
	}

	$html .= '</nobr>'
		if ($options -> {nobr});

	return $html;
	
}

################################################################################

sub draw_form_field_text {

	my ($_SKIN, $options, $data) = @_;

	my $attributes = dump_attributes ($options -> {attributes});
	
	my $url = '_skins/TurboMilk/jquery.textarearesizer.compressed';

	unless (grep {$_ eq $url} @{$_REQUEST {__include_js}}) {

		push @{$_REQUEST{__include_js}}, $url;
		
		$_REQUEST {__head_links} .= <<EOH;
		<style>
			div.grippie {
				background:#EEEEEE url($_REQUEST{__static_url}/grippie.png) no-repeat scroll center 2px;
				border-color:#DDDDDD;
				border-style:solid;
				border-width:0pt 1px 1px;
				cursor:s-resize;
				height:9px;
				overflow:hidden;
			}
			.resizable-textarea textarea {
				display:block;
				margin-bottom:0pt;
				width:95%;
				height: 20%;
			}
		</style>
EOH

		if ($_REQUEST {__only_form}) {

			$_REQUEST {__on_load} .= <<EOJS;
					parent.setTimeout ('reset_textarearesizer(\\'_$$options{name}\\')', 10);
EOJS
		} else {
		
			$_REQUEST {__script} .= <<'EOJS';
				function reset_textarearesizer (name) {
					$("textarea[name='" + name + "']").parent().parent().after($("textarea[name='" + name + "']")).remove().siblings('.grippie').remove(); 
					$("textarea:not(.processed)").TextAreaResizer();
				}
EOJS

			$_REQUEST {__on_load} .= <<'EOJS';
				$('textarea:not(.processed)').TextAreaResizer();
EOJS
		}
		
	}

	return <<EOH;
		<textarea 
			$attributes 
			onFocus="scrollable_table_is_blocked = true; q_is_focused = true" 
			onBlur="scrollable_table_is_blocked = false; q_is_focused = false" 
			rows=$$options{rows}
			cols=$$options{cols}
			name="_$$options{name}" 
			onchange="is_dirty=true;"
		>$$options{value}</textarea>
EOH

}

################################################################################

sub draw_form_field_password {
	my ($_SKIN, $options, $data) = @_;
	my $attributes = dump_attributes ($options -> {attributes});
	return qq {<input type="password" name="_$$options{name}" size="$$options{size}" onKeyPress="if (window.event.keyCode != 27) is_dirty=true" $attributes onKeyDown="tabOnEnter()" onFocus="scrollable_table_is_blocked = true; q_is_focused = true" onBlur="scrollable_table_is_blocked = false; q_is_focused = false">};
}

################################################################################

sub draw_form_field_static {
		
	my ($_SKIN, $options, $data) = @_;

	my $html = '';

	if ($options -> {href}) {
		my $state = $_REQUEST {__read_only} ? 'passive' : 'active';
		$options -> {a_class} ||= "form-$state-inputs";
		$options -> {a_class} =~ s{(passive|active)}{deleted} if ($data -> {fake} == -1);
		$html = qq{<a href="$$options{href}" target="$$options{target}" class="$$options{a_class}">};
	}
	
	if (ref $options -> {value} eq ARRAY) {
	
		$options -> {separator} ||= '<br>';

		for (my $i = 0; $i < @{$options -> {value}}; $i++) {

			if ($i) {
				$html =~ s{\s*$}{};
				$html =~ s{\s*$}{$options->{separator}};
			}

			$html .= $options -> {value} -> [$i] -> {label};

		}
		
	}
	else {
		$html .= $options -> {value};
		$html .= '&nbsp;' if $options -> {value} eq '';
	}
	
	
	if ($options -> {href}) {
		$html .= '</a>';
	}
		
	$html .= dump_hiddens ([$options -> {hidden_name} => $options ->{hidden_value}]) if $options -> {add_hidden};

	return "<span id='input_$$options{name}'>$html</span>";
	
}

################################################################################

sub draw_form_field_checkbox {

	my ($_SKIN, $options, $data) = @_;
	
	my $attributes = dump_attributes ($options -> {attributes});
	
	return qq {<input class=cbx type="checkbox" name="_$$options{name}" $attributes $checked value=1 onChange="is_dirty=true" onKeyDown="tabOnEnter()">};
	
}

################################################################################

sub draw_form_field_radio {

	my ($_SKIN, $options, $data) = @_;
				
	my $html = "<table border=0 cellspacing=2 cellpadding=0 width=100% id='input_$$options{name}'>";
	
	my $n = 0;
	
	foreach my $value (@{$options -> {values}}) {
	
		delete $value -> {attributes} -> {name};
		delete $value -> {attributes} -> {value};
		delete $value -> {attributes} -> {id};
		delete $value -> {attributes} -> {onclick};
	
		my $attributes = dump_attributes ($value -> {attributes});
		
		(!$n and $options -> {no_br}) or $html .= qq {\n<tr><td class="form-inner" valign=top width=1%>};
		$html .= qq {\n<nobr><input class=cbx $attributes id="$value" onFocus="scrollable_table_is_blocked = true; q_is_focused = true" onBlur="scrollable_table_is_blocked = false; q_is_focused = false" type="radio" name="_$$options{name}" value="$$value{id}" onClick="is_dirty=true;$$value{onclick};" onKeyDown="tabOnEnter()">&nbsp;$$value{label}</nobr>};
							
		$value -> {html} or next;
		
		$html .= qq{\n\t\t<td class="form-inner"><div style="display:expression(getElementById('$value').checked ? 'block' : 'none')">$$value{html}</div>};
		
		$n ++;
				
	}
	
	$html .= '</table>';
		
	return $html;
	
}

################################################################################

sub draw_form_field_select {

	my ($_SKIN, $options, $data) = @_;
	
	$options -> {attributes} ||= {};
	$options -> {attributes} -> {style} ||= 'visibility:expression(select_visibility())' if msie_less_7;
	my $attributes = dump_attributes ($options -> {attributes});
	
	if (defined $options -> {other}) {

		$options -> {other} -> {width}  ||= $conf -> {core_modal_dialog_width} || 'screen.availWidth - (screen.availWidth <= 800 ? 50 : 100)';
		$options -> {other} -> {height} ||= $conf -> {core_modal_dialog_height} || 'screen.availHeight - (screen.availHeight <= 600 ? 50 : 100)';

		$options -> {no_confirm} ||= $conf -> {core_no_confirm_other};

		if ($options -> {no_confirm}) {

			$options -> {onChange} .= <<EOJS;

				if (this.options[this.selectedIndex].value == -1) {

					var dialog_width = $options->{other}->{width};
					var dialog_height = $options->{other}->{height};
					
					try {

						var result = window.showModalDialog ('$ENV{SCRIPT_URI}/i/_skins/TurboMilk/dialog.html?@{[rand ()]}', {href: '$options->{other}->{href}&select=$options->{name}&salt=' + Math.random()}, 'status:no;resizable:yes;help:no;dialogWidth:' + dialog_width + 'px;dialogHeight:' + dialog_height + 'px');
					
						focus ();
						
						if (result.result == 'ok') {
						
							setSelectOption (this, result.id, result.label);
							
						} else {
						
							this.selectedIndex = 0;
						
						} 					

					} catch (e) {
					
						this.selectedIndex = 0;
						
					}
					
					
				}
EOJS
		} else {

			$options -> {onChange} .= <<EOJS;
	
				if (this.options[this.selectedIndex].value == -1) {

					if (window.confirm ('$$i18n{confirm_open_vocabulary}')) {

						var dialog_width = $options->{other}->{width};
						var dialog_height = $options->{other}->{height};

						try {
	
							var result = window.showModalDialog ('$ENV{SCRIPT_URI}/i/_skins/TurboMilk/dialog.html?@{[rand ()]}', {href: '$options->{other}->{href}&select=$options->{name}'}, 'status:no;resizable:yes;help:no;dialogWidth:' + dialog_width + 'px;dialogHeight:' + dialog_height + 'px');
						
							focus ();
							
							if (result.result == 'ok') {
							
								setSelectOption (this, result.id, result.label);
								
							} else {
							
								this.selectedIndex = 0;
							
							} 					
	
						} catch (e) {
						
							this.selectedIndex = 0;
							
						}
					}
				}
EOJS
		}
	}

	my $html = <<EOH;
		<select 
			name="_$$options{name}"
			id="_$$options{name}_select"
			$attributes
			onKeyDown="tabOnEnter()"
			onChange="is_dirty=true; $$options{onChange}" 
			onKeyPress="typeAhead(0)" 
		>
EOH
		
	if (defined $options -> {empty}) {
		$html .= qq {<option value="0" $selected>$$options{empty}</option>\n};
	}
		
	if (defined $options -> {other} && $options -> {other} -> {on_top}) {
		$html .= qq {<option value=-1>${$$options{other}}{label}</option>};
	}

	foreach my $value (@{$options -> {values}}) {
		$html .= qq {<option value="$$value{id}" $$value{selected}>$$value{label}</option>\n}; 
	}
	
	if (defined $options -> {other} && !$options -> {other} -> {on_top}) {
		$html .= qq {<option value=-1>${$$options{other}}{label}</option>};
	}

	$html .= '</select>';

#	if (defined $options -> {other}) {
#		$html .= <<EOH;
#			<div id="_$$options{name}_div" style="{position:absolute; display:none; width:expression(getElementById('_$$options{name}_select').offsetParent.offsetWidth - 10)}">
#				<iframe name="_$$options{name}_iframe" id="_$$options{name}_iframe" width=100% height=${$$options{other}}{height} src="$_REQUEST{__static_url}/0.html" application="yes">
#				</iframe>
#			</div>
#EOH
#	}

	return $html;
	
}

################################################################################

sub draw_form_field_string_voc {

	my ($_SKIN, $options, $data) = @_;
	
	$options -> {attributes} ||= {};

	$options -> {attributes} -> {onKeyPress} .= qq[;if (window.event.keyCode != 27) {is_dirty=true;document.getElementById('${options}_id').value = 0; }];
	$options -> {attributes} -> {onKeyDown}  .= qq[;if (window.event.keyCode == 8 || window.event.keyCode == 46) {is_dirty=true;document.getElementById('${options}_id').value = 0;}; tabOnEnter();];
	$options -> {attributes} -> {onFocus}    .= ';scrollable_table_is_blocked = true; q_is_focused = true;';
	$options -> {attributes} -> {onBlur}     .= ';scrollable_table_is_blocked = false; q_is_focused = false;';
	$options -> {attributes} -> {onChange}   .= 'is_dirty=true;' . ( $options->{onChange} ? $options->{onChange} . ' try { window.event.cancelBubble = false } catch (e) {} try { window.event.returnValue = true } catch (e) {}': '');

	my $attributes = dump_attributes ($options -> {attributes});

	if (defined $options -> {other}) {

		$options -> {other} -> {width}  ||= $conf -> {core_modal_dialog_width} || 'screen.availWidth - (screen.availWidth <= 800 ? 50 : 100)';
		$options -> {other} -> {height} ||= $conf -> {core_modal_dialog_height} || 'screen.availHeight - (screen.availHeight <= 600 ? 50 : 100)';

		$options -> {other} -> {onChange} .= <<EOJS;

			var dialog_width = $options->{other}->{width};
			var dialog_height = $options->{other}->{height};

			var q = encode1251(document.getElementById('${options}_label').value);

			var result = window.showModalDialog ('$ENV{SCRIPT_URI}/i/_skins/TurboMilk/dialog.html?@{[rand ()]}', {href: '$options->{other}->{href}&$options->{other}->{param}=' + q + '&select=$options->{name}&$options->{other}->{cgi_tail}'}, 'status:no;resizable:yes;help:no;dialogWidth:' + dialog_width + 'px;dialogHeight:' + dialog_height + 'px');
			
			focus ();
			
			if (result.result == 'ok') {
				document.getElementById('${options}_label').value=result.label;
				document.getElementById('${options}_id').value=result.id;
$options->{onChange}
			} else {
				this.selectedIndex = 0;
			}
EOJS
	}


	my $html = qq[<span style="white-space: nowrap" id="_$options->{name}_span"><input type="text" $attributes id="${options}_label" >]

		. ($options -> {other} ? qq [ <input type="button" value="..." onclick="$options->{other}->{onChange}">] : '')
		
		. dump_tag (input => {
		
			type  => "hidden", 
			name  => "_$options->{name}", 
			value => "$options->{id}",
			id    => "${options}_id",
			
		})
		
		. '</span>';		

	return $html;
	
}

################################################################################

sub draw_form_field_tree {

	my ($_SKIN, $options, $data) = @_;
	
	my @nodes = ();
	
	our %idx = ();
	our %lch = ();
	
	foreach my $value (@{$options -> {values}}) {
	
		my $node = $value -> {__node};
		push @nodes, $node;
		
		$idx {$node -> {id}} = $node;
		$lch {$node -> {pid}} = $node if $node -> {pid};
	}
	
	while (my ($k, $v) = each %lch) {
		$idx {$k} -> {_hc} = 1;
		$v -> {_ls} = 1;
	}
	
	my $name = $options -> {name} || 'd';
	$options->{height} ||= 200;
	
	my $nodes = $_JSON -> encode (\@nodes);

	return <<EOH;
<table 
	width=100% 
	height="$options->{height}" 
	celspacing=0 
	cellpadding=0 
	class='dtree'
>	
	<tr>
		<td valign=top height="$options->{height}">
		<script type="text/javascript">
			var $name = new dTree ('$name');
			$name._url_base = '';
			var c = $name.config;
			c.iconPath = '$_REQUEST{__static_url}/tree_';
			c.useStatusText = false;
			c.useSelection = false;
			$name.icon.node = 'folderopen.gif';
			$name.aNodes = $nodes;
			document.write($name);
			for (var n = 0; n < $name.checkedNodes.length; n++) {
				$name.openTo ($name.checkedNodes [n], true, true);
			}
			
		</script>
</td></tr></table>
EOH
	

}

################################################################################

sub draw_form_field_checkboxes {

	my ($_SKIN, $options, $data) = @_;
	
	my $html = '';
	
	my $tabindex = $_REQUEST {__tabindex} + 1;
	
	my $v = $data -> {$options -> {name}};
	
	if (ref $v eq ARRAY) {
	
		my $n = 0;
		
		$html .= '<table border=0 cellpadding=0 cellspacing=0><tr>';
	
		foreach my $value (@{$options -> {values}}) {
				
			my $checked = 0 + (grep {$_ eq $value -> {id}} @$v) ? 'checked' : '';

			my $id = 'div_' . $value;
			my $subhtml = '';
			my $subattr = '';
			
			my $display = $checked || $options -> {expand_all} ? '' : 'style={display:none}';

			if ($value -> {html}) {
				$subhtml .= $value -> {inline} ? qq{&nbsp;<span id="$id" $display>} : qq{&nbsp;</td><td class="form-inner" id="$id" $display>};
				$subhtml .= $value -> {html};
				$subhtml .= $value -> {inline} ? qq{</span>} : '';
				$subattr = qq{onClick="setVisible('$id', checked)"} unless $options -> {expand_all};
			}
			elsif ($value -> {items} && @{$value -> {items}} > 0) {

				foreach my $subvalue (@{$value -> {items}}) {
									
					my $subchecked = 0 + (grep {$_ eq $subvalue -> {id}} @$v) ? 'checked' : '';
					
					$tabindex++;
					
					$subhtml .= $subvalue -> {no_checkbox} ? qq{&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$$subvalue{label} <br>} : qq {&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input class=cbx type="checkbox" name="_$$options{name}_$$subvalue{id}" value="1" $subchecked onChange="is_dirty=true" tabindex=$tabindex>&nbsp;$$subvalue{label} <br>};
				
				}

				
				$subhtml = <<EOH;
					<div id="$id" $display>
						$subhtml
					</div>
EOH
			
				$subattr = qq{onClick="setVisible('$id', checked)"} unless $options -> {expand_all};
			
			}
		
			$tabindex ++;
			$n ++;

			$html .= qq {<td class="form-inner"><input $subattr class=cbx type="checkbox" name="_$$options{name}_$$value{id}" value="1" $checked onChange="is_dirty=true" tabindex=$tabindex>&nbsp;$$value{label} $subhtml</td>};
			$html .= '</tr><tr>' unless $n % $options -> {cols};
			
		}
		
		$html =~ s{\<tr\>$}{};		
		$html .= '</table>';
	
	}
	else {
	
		foreach my $value (@{$options -> {values}}) {
			my $checked = $v eq $value -> {id} ? 'checked' : '';
			$tabindex++;
			$html .= qq {<input class=cbx type="checkbox" name="_$$options{name}" value="$$value{id}" $checked onChange="is_dirty=true" tabindex=$tabindex>&nbsp;$$value{label} <br>};
		}
		
	}
		
	if ($options -> {height}) {
		$html = <<EOH;
			<div class="checkboxes" style="height:$$options{height}px;" id="input_$$options{name}">
				$html
			</div>
EOH
	}
	else {
		$html = <<EOH;
			<span id="input_$$options{name}">
				$html
			</span>
EOH
	}
	
	$_REQUEST {__tabindex} = $tabindex;
	
	return $html;
	
}

################################################################################

sub draw_form_field_image {

	my ($_SKIN, $options, $data) = @_;
	
	return <<EOH;
		<input type="hidden" name="_$$options{name}" value="$$options{id_image}">
		<img src="$$options{src}" id="$$options{name}_preview" width = "$$options{width}" height = "$$options{height}">&nbsp;
		<input type="button" value="$$i18n{Select}" onClick="nope('$$options{new_image_url}', 'selectImage' , '');">
EOH

}

################################################################################

sub draw_form_field_iframe {
	
	my ($_SKIN, $options, $data) = @_;

	return <<EOH;
		<iframe name="$$options{name}" src="$$options{href}" width="$$options{width}" height="$$options{height}" application="yes"></iframe>
EOH

}

################################################################################

sub draw_form_field_color {
	
	my ($_SKIN, $options, $data) = @_;
	
	my $html = <<EOH;
		<table 
			align="absmiddle" 
			cellspacing=0
			cellpadding=0
			style="height:20px;width:40px;border:solid black 1px;background:#$$options{value}"
EOH
	
	if (!$_REQUEST {__read_only}) {
	
		$html .= <<EOH;
			onClick="
				var color = showModalDialog('$_REQUEST{__static_url}/colors.html?$_REQUEST{__static_salt}', window, 'dialogWidth:600px;dialogHeight:400px;help:no;scroll:no;status:no');
				getElementById('td_color_$$options{name}').style.background = color;
				getElementById('input_color_$$options{name}').value = color.substr (1);
			"
EOH
	
	}
	
	$html .= <<EOH;
		>
			<tr height=20>
				<td id="td_color_$$options{name}" >
					<input id="input_color_$$options{name}" type="hidden" name="_$$options{name}" value="$$options{value}">
				</td>
			</tr>
		</table>
EOH

	return $html;

}

################################################################################

sub draw_form_field_htmleditor {
	
	my ($_SKIN, $options, $data) = @_;
	
	return '' if $options -> {off};
	
	push @{$_REQUEST{__include_js}}, 'rte/fckeditor';
	
	return <<EOH;
		<SCRIPT language="javascript">
			<!--
				var oFCKeditor_$$options{name};
				oFCKeditor_$$options{name} = new FCKeditor('_$$options{name}', '$$options{width}', '$$options{height}', '$$options{toolbar}');
				oFCKeditor_$$options{name}.Value = '$$options{value}';
				oFCKeditor_$$options{name}.Create ();
			//-->
		</SCRIPT>
EOH

}

################################################################################
# TOOLBARS
################################################################################

################################################################################

sub draw_toolbar {

	my ($_SKIN, $options) = @_;
	
	if ($_REQUEST {select}) {

		my $button = {		
			icon    => 'cancel',
			id      => 'cancel',
			label   => $i18n -> {close},
			href    => "javaScript:window.close();",
		};
		
		$button -> {html} = $_SKIN -> draw_toolbar_button ($button);

		unshift @{$options -> {buttons}}, $button;

	}

	my $html = <<EOH;
		<table bgcolor="b9c5d7" cellspacing=0 cellpadding=0 width="100%" border=0>
			<form action=$_REQUEST{__uri} name=$options->{form_name} target="$$options{target}">
EOH
	
	
	my %keep_params = map {$_ => 1} @{$options -> {keep_params}};
	
	$keep_params {$_} = 1 foreach qw (sid __last_query_string __last_scrollable_table_row __last_last_query_string);
	
	$html .= dump_hiddens (map {[$_ => $_REQUEST {$_}]} (keys %keep_params));

	$html .= <<EOH;
				<tr>
					<td bgcolor="#6f7681" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#949eac" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#adb8c9" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td class="bgr0" width=30><img height=30 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=20 border=0></td>
EOH

	foreach (@{$options -> {buttons}}) {	$html .= $_ -> {html};	}

	$html .= <<EOH;
					<td class="bgr0" width=100%><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#c5d2df" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#8c9ab1" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
			</form>
		</table>
EOH

	return $html;

}

################################################################################

sub draw_toolbar_break {

	my ($_SKIN, $options) = @_;

	my $html = <<EOH;
					<td class="bgr0" width=100%><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#c5d2df" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#8c9ab1" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
EOH
	
	if ($options -> {break_table}) {		
		$html .= '</table><table bgcolor="b9c5d7" cellspacing=0 cellpadding=0 width="100%" border=0>';		
	}

	$html .= <<EOH;
				<tr>
					<td bgcolor="#6f7681" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#949eac" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td bgcolor="#adb8c9" colspan=20><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				</tr>
				<tr>
					<td class="bgr0" width=30><img height=30 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=20 border=0></td>
EOH

	return $html;

}

################################################################################

sub _icon_path {

	-r $r -> document_root . "/i/_skins/TurboMilk/i_$_[0].gif" ?
	"$_REQUEST{__static_url}/i_$_[0].gif?$_REQUEST{__static_salt}" :
	"$_REQUEST{__static_site}/i/buttons/$_[0].gif"			

}

################################################################################

sub draw_toolbar_button {

	my ($_SKIN, $options) = @_;
	my $html = <<EOH;
		<td class="bgr0">
		<table cellspacing=0 cellpadding=0 border=0 valign="middle">
		<tr>
			<td class="bgr0" width=6><img src="$_REQUEST{__static_url}/btn2_l.gif?$_REQUEST{__static_salt}" width="6" height="21" border="0"></td>
			<td class="bgr0" style="background-repeat:repeat-x" background="$_REQUEST{__static_url}/btn2_bg.gif?$_REQUEST{__static_salt}" valign="middle" align="center" nowrap><nobr>&nbsp;<a TABINDEX=-1 class=button href="$$options{href}" $$options{onclick} id="$$options{id}" target="$$options{target}">
EOH

	if ($options -> {icon}) {
		my $img_path = _icon_path ($options -> {icon});
		$html .= qq {<img src="$img_path" alt="$label" border=0 hspace=0 align=absmiddle>&nbsp;};
	}
	
	$html .= <<EOH;
			</a>
			</nobr></td>
			<td class="bgr0" style="background-repeat:repeat-x" background="$_REQUEST{__static_url}/btn2_bg.gif?$_REQUEST{__static_salt}" valign="middle" align="center" nowrap><nobr>&nbsp;<a TABINDEX=-1 class=button href="$$options{href}" $$options{onclick} id="$$options{id}" target="$$options{target}">
				$options->{label}
				</a>
			</nobr></td>
			<td width=6><img src="$_REQUEST{__static_url}/btn2_r.gif?$_REQUEST{__static_salt}" width="6" height="21" border="0"></td>
		</tr>
		</table>
		</td>

EOH

	$html .= "<td class='toolbar'>&nbsp;&nbsp;&nbsp;</td>";

	return $html;
	
}

################################################################################

sub draw_toolbar_input_tree {

	my ($_SKIN, $options) = @_;
	
	my $id = "toolbar_input_tree_$options->{name}";
	
	my @nodes = ();
	
	our %idx = ();
	our %lch = ();
	
	foreach my $value (@{$options -> {values}}) {
	
		my $node = $value -> {__node};
		push @nodes, $node;
		
		$idx {$node -> {id}} = $node;
		$lch {$node -> {pid}} = $node if $node -> {pid};
	}
	
	while (my ($k, $v) = each %lch) {
		$idx {$k} -> {_hc} = 1;
		$v -> {_ls} = 1;
	}
	
	my $name = $options -> {name};
	
	$options -> {height} ||= 400;
	$options -> {width}  ||= 600;
	
	my $nodes = $_JSON -> encode (\@nodes);

	return qq {
		
		<td class="toolbar" nowrap>

		<div
			id="${id}_div"
			onClick="if (event.srcElement.tagName != 'INPUT') \$('#${id}_select_1').get(0).form.submit()"
			style="
				background-color:white;
				position:absolute;
				display:none;
				z-index:100;
				width:$options->{width}px;
				height:$options->{height}px;
				left:500;
				border:solid black 1px;
				overflow-y:scroll;
			"
		>
			<table width=100% height=100% celspacing=0 cellpadding=0 border=0 class='dtree'>	
				<tr>
					<td valign=top class='form-active-inputs'>
						<script>
							var $name = new dTree ('$name');
							$name._url_base = '';
							var c = $name.config;
							c.iconPath = '$_REQUEST{__static_url}/tree_';
							c.useStatusText = false;
							c.useSelection = false;
							$name.icon.node = 'folderopen.gif';
							$name.aNodes = $nodes;
							$name.checkbox_name_prefix = '';
							document.write ($name);
							for (var n = 0; n < $name.checkedNodes.length; n++) {
								$name.openTo ($name.checkedNodes [n], true, true);
							}							
						</script>
					</td>
				</tr>
			</table>
		</div>

		
				<select id="${id}_select_1"
				
					onDblClick="
						
						var select_1 = \$('#${id}_select_1');
						var select_2 = \$('#${id}_select_2');

						select_1.hide ();
						select_2.show ();
						blockEvent ();
						
					"
														
					onMouseDown="

						var select_1 = \$('#${id}_select_1');
						var select_2 = \$('#${id}_select_2');
						var div      = \$('#${id}_div');
						
						if (div.is (':hidden')) {
						
							var css      = select_1.offset (\$(document.body));
							css.top     += 20;
			
							div.css  (css);
							div.show ();
													
							select_1.hide ();
							select_2.show ();

						}
						else {
						
							select_1.get (0).form.submit ()
						
						}

					"

				>
					<option>$options->{label}</option>
				</select>
				<select id="${id}_select_2" style="display:none"
																				
					onDblClick="
						
						var select_1 = \$('#${id}_select_1');
						var select_2 = \$('#${id}_select_2');

						select_2.hide ();
						select_1.show ();
						blockEvent ();
						
					"

					onMouseDown="

						var select_1 = \$('#${id}_select_1');
						var select_2 = \$('#${id}_select_2');
						var div      = \$('#${id}_div');
						
						var css      = select_2.offset (\$(document.body));
						css.top     += 20;
		
						if (div.is (':hidden')) {

							div.css (css);
							div.toggle();
													
							select_2.hide ();
							select_1.show ();
							
						}
						else {
						
							select_2.get (0).form.submit ()
						
						}
																	
					"

				>
					<option>$options->{label}</option>
				</select>
							
		</td>
		<td class="toolbar">&nbsp;&nbsp;&nbsp;</td>
	
	};

}

################################################################################

sub draw_toolbar_input_select {

	my ($_SKIN, $options) = @_;

	my $html = '<td class="toolbar" nowrap>';
		
	if ($options -> {label} && $options -> {show_label}) {
		$html .= $options -> {label};
		$html .= ': ';
	}

	$options -> {name} = '_' . $options -> {name}
		if defined $options -> {other};

	my $name = $$options{name};

	my $read_only = $options -> {read_only} ? 'disabled' : ''; 

	if (defined $options -> {other}) {

		$options -> {other} -> {width}  ||= $conf -> {core_modal_dialog_width} || 'screen.availWidth - (screen.availWidth <= 800 ? 50 : 100)';
		$options -> {other} -> {height} ||= $conf -> {core_modal_dialog_height} || 'screen.availHeight - (screen.availHeight <= 600 ? 50 : 100)';

		$options -> {no_confirm} ||= $conf -> {core_no_confirm_other};

		if ($options -> {no_confirm}) {

			$options -> {onChange} .= <<EOJS;

				if (this.options[this.selectedIndex].value == -1) {

					var dialog_width = $options->{other}->{width};
					var dialog_height = $options->{other}->{height};

					try {

						var result = window.showModalDialog ('$ENV{SCRIPT_URI}/i/_skins/TurboMilk/dialog.html?@{[rand ()]}', {href: '$options->{other}->{href}&select=$name'}, 'status:no;resizable:yes;help:no;dialogWidth:' + dialog_width + 'px;dialogHeight:' + dialog_height + 'px');
						
						focus ();
						
						if (result.result == 'ok') {
							setSelectOption (this, result.id, result.label);
							submit ();
						} else {
							this.selectedIndex = 0;
						}
					} catch (e) {
							this.selectedIndex = 0;
					}
					
				} else {
  				submit ();
        }
EOJS
		} else {

			$options -> {onChange} .= <<EOJS;
	
				if (this.options[this.selectedIndex].value == -1) {

					if (window.confirm ('$$i18n{confirm_open_vocabulary}')) {

						try {

							var dialog_width = $options->{other}->{width};
							var dialog_height = $options->{other}->{height};

							var result = window.showModalDialog ('$ENV{SCRIPT_URI}/i/_skins/TurboMilk/dialog.html?@{[rand ()]}', {href: '$options->{other}->{href}&select=$name'}, 'status:no;resizable:yes;help:no;dialogWidth:' + dialog_width + 'px;dialogHeight:' + dialog_height + 'px');
							
							focus ();
							
							if (result.result == 'ok') {
								setSelectOption (this, result.id, result.label);
	  						submit ();
							} else {
								this.selectedIndex = 0;
							}
						} catch (e) {
							this.selectedIndex = 0;
						}
					
					} else {

						this.selectedIndex = 0;

					}
				} else {
  				submit ();
        }
EOJS
		}
	}

	$options -> {attributes} ||= {};
	
	$options -> {attributes} -> {style} ||= 'visibility:expression(select_visibility())' if msie_less_7;
	
	$options -> {attributes} -> {onChange} = $options -> {onChange};
	
	$options -> {attributes} -> {onKeyPress} = 'typeAhead(1)';

	my $attributes = dump_attributes ($options -> {attributes});
	
	$html .= <<EOH;
		<select name="$name" id="${name}_select" $read_only $attributes>
EOH

	foreach my $value (@{$options -> {values}}) {
	
		my $attributes = dump_attributes ($value -> {attributes});
			
		$html .= qq {<option value="$$value{id}" $$value{selected} $attributes>$$value{label}</option>};
	
	}

	$html .= '</select></td><td class="toolbar">&nbsp;&nbsp;&nbsp;</td>';

	return $html;
	
}

################################################################################

sub draw_toolbar_input_checkbox {

	my ($_SKIN, $options) = @_;
	
	my $html = '<td class="toolbar" nowrap>';
		
	if ($options -> {label}) {
		$html .= $options -> {label};
		$html .= ': ';
	}

	$html .= qq {<input class=cbx type=checkbox value=1 $$options{checked} name="$$options{name}" onClick="$$options{onClick}">};

	$html .= "<td class='toolbar'>&nbsp;&nbsp;&nbsp;</td>";
	
	return $html;

}

################################################################################

sub draw_toolbar_input_submit {

	my ($_SKIN, $options) = @_;

	my $html = '<td class="toolbar" nowrap>';
		
	if ($options -> {label}) {
		$html .= $options -> {label};
		$html .= ': ';
	}

	$html .= qq {<input type=submit name="$$options{name}" value="$$options{label}">};

	$html .= "<td class='toolbar'>&nbsp;&nbsp;&nbsp;</td>";
	
	return $html;

}

################################################################################

sub draw_toolbar_input_text {

	my ($_SKIN, $options) = @_;
	
	my $html = '<td nowrap class="toolbar" valign="middle">';
		
	if ($options -> {label}) {
		$html .= $options -> {label};
		$html .= ': ';
	}


	$options -> {attributes} ||= {};
	$options -> {attributes} -> {style} ||= 'visibility:expression(select_visibility())' if msie_less_7;
	
	$options -> {onKeyPress} ||= "if (window.event.keyCode == 13) {form.submit()}";

	my $attributes = dump_attributes ($options -> {attributes});

	$html .= <<EOH;
		<input 
			onKeyPress="$$options{onKeyPress}; blockEvent ();" 
			type=text 
			size=$$options{size} 
			name=$$options{name} 
			value="$$options{value}" 
			onFocus="scrollable_table_is_blocked = true; q_is_focused = true" 
			onBlur="scrollable_table_is_blocked = false; q_is_focused = false"
			$attributes
			class='form-active-inputs'
			id="$options->{id}"
		>
EOH

	$html .= "</td><td class='toolbar'>&nbsp;&nbsp;&nbsp;</td>";

	return $html;

}

################################################################################

sub draw_toolbar_input_datetime {

	my ($_SKIN, $options) = @_;

	$options -> {onClose}    = "function (cal) { cal.hide (); $$options{onClose}; cal.params.inputField.form.submit () }";	
	$options -> {onKeyPress} = "if (window.event.keyCode == 13) {this.form.submit()}";

	my $html = '<td class="toolbar" nowrap>';
		
	if ($options -> {label}) {
		$html .= $options -> {label};
		$html .= ': ';
	}

	$html .= $_SKIN -> _draw_input_datetime ($options);

	$html .= "<td class='toolbar'>&nbsp;&nbsp;&nbsp;</td>";

	return $html;

}

################################################################################

sub draw_toolbar_pager {

	my ($_SKIN, $options) = @_;
		
	my $html = '<td class="bgr0"><table cellspacing=2 cellpadding=0><tr>';
	
	if ($options -> {total}) {

		if ($options -> {rewind_url}) {
			$html .= qq {<td nowrap valign="middle"><a TABINDEX=-1 href="$$options{rewind_url}" class=lnk0 onFocus="blur()"><img src="$_REQUEST{__static_url}/pager_f.gif?$_REQUEST{__static_salt}" width="16" height="17" border="0"></a></td>};
		}

		if ($options -> {back_url}) {
			$html .= qq {<td nowrap valign="middle"><a TABINDEX=-1 href="$$options{back_url}" class=lnk0 id="_pager_prev" onFocus="blur()"><img src="$_REQUEST{__static_url}/pager_p.gif?$_REQUEST{__static_salt}" width="16" height="17" border="0"></a></td>};
		}
		
		$html .= '<td nowrap class="toolbar" valign="middle">&nbsp;' . ($options -> {start} + 1);
		$html .= ' - ';
		$html .= ($options -> {start} + $options -> {cnt});
		$html .= qq |$$i18n{toolbar_pager_of}<a TABINDEX=-1 class=lnk0 href="$$options{infty_url}">$$options{infty_label}</a>|;
		$html .= '&nbsp;</td>';

		if ($options -> {next_url}) {
			$html .= qq {<td  nowrap valign="middle"><a TABINDEX=-1 href="$$options{next_url}" class=lnk0 id="_pager_next" onFocus="blur()"><img src="$_REQUEST{__static_url}/pager_n.gif?$_REQUEST{__static_salt}" width="16" height="17" border="0"></a></td>};
		}

		if ($options -> {last_url}) {
			$html .= qq {<td nowrap valign="middle"><a TABINDEX=-1 href="$$options{last_url}" class=lnk0 onFocus="blur()"><img src="$_REQUEST{__static_url}/pager_l.gif?$_REQUEST{__static_salt}" width="16" height="17" border="0"></a></td>};
		}

	}
	else {	
		$html .= '<td nowrap class="toolbar">' . $i18n -> {toolbar_pager_empty_list} . '</td>';	
	}
	
	$html .= "</tr></table></td><td class='toolbar'>&nbsp;&nbsp;&nbsp;</td>";

	return $html;

}

################################################################################

sub draw_centered_toolbar_button {

	my ($_SKIN, $options) = @_;

	my $img_path = "$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}";

	if ($options -> {icon}) {
		$img_path = _icon_path ($options -> {icon});
	}
	
	my $nbsp = $options -> {label} ? '&nbsp;' : '';

	return <<EOH;
		<td nowrap background="$_REQUEST{__static_url}/cnt_tbr_bg.gif?$_REQUEST{__static_salt}">
			<table cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td width=6><img src="$_REQUEST{__static_url}/btn_l.gif?$_REQUEST{__static_salt}" width="6" height="25" border="0"></td>
					<td width=30 background="$_REQUEST{__static_url}/btn_bg.gif?$_REQUEST{__static_salt}" valign="middle" align="center" nowrap><a class="button" $$options{onclick} href="$$options{href}" id="$$options{id}" target="$$options{target}"><img src="$img_path" alt="$$options{label}" border=0 hspace=0 vspace=1 align=absmiddle>${nbsp}</a></td>
					<td background="$_REQUEST{__static_url}/btn_bg.gif?$_REQUEST{__static_salt}" valign="absmiddle" align="center" nowrap><a class="button" $$options{onclick} href="$$options{href}" id="$$options{id}" target="$$options{target}">$$options{label}</a>${nbsp}${nbsp}</td>
					<td width=6><img src="$_REQUEST{__static_url}/btn_r.gif?$_REQUEST{__static_salt}" width="6" height="25" border="0"></td>
				</tr>
			</table>
		</td>
		<td background="$_REQUEST{__static_url}/cnt_tbr_bg.gif?$_REQUEST{__static_salt}"><img height=40 hspace=0 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=10 border=0></td>


EOH


}

################################################################################

sub draw_centered_toolbar {

	my ($_SKIN, $options, $list) = @_;

	our $__last_centered_toolbar_id = 'toolbar_' . int $list;
	
	my $colspan = 3 * (1 + $options -> {cnt}) + 1;

	my $html = <<EOH;
		<table cellspacing=0 cellpadding=0 width="100%" border=0 id="$__last_centered_toolbar_id">
			<tr>
				<td>
					<table cellspacing=0 cellpadding=0 width="100%" border=0>
						<tr>
							<td colspan=$colspan><img height=3 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
						</tr>
						<tr>
							<td width="45%">
								<table cellspacing=0 cellpadding=0 width="100%" border=0>
									<tr>
										<td background="$_REQUEST{__static_url}/cnt_tbr_bg.gif?$_REQUEST{__static_salt}"><img height=40 hspace=0 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
									</tr>
								</table>
							</td>
EOH

	foreach (@$list) {
		$html .= $_ -> {html};
	}

	$html .= <<EOH;
									<td width="45%">
										<table cellspacing=0 cellpadding=0 width="100%" border=0>
											<tr>
												<td background="$_REQUEST{__static_url}/cnt_tbr_bg.gif?$_REQUEST{__static_salt}"><img height=40 hspace=0 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
											</tr>
										</table>
									</td>
								</tr>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	
EOH
	
	return $html;

}

################################################################################

sub draw_dump_button {

	return {
		label  => 'Dump',
		name   => '_dump',
		href   => "javascript:_dumper_href('&__dump=1', '_blank');",
		side   => 'right_items',
		no_off => 1,

	};
}

################################################################################
# MENUS
################################################################################

################################################################################

sub draw_menu {

	my ($_SKIN, $_options) = @_;
		
	my @types = (@{$_options -> {left_items}}, BREAK, @{$_options -> {right_items}});
	
	my $colspan = 1 + @types;

	my $html = <<EOH;

	<div style="position:relative" id="main_menu">

		<table width="100%" class=bgr8 cellspacing=0 cellpadding=0 border=0>
			<tr>
				<td background="$_REQUEST{__static_url}/menu_bg.gif?$_REQUEST{__static_salt}" width=1><img height=26 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>
				<td background="$_REQUEST{__static_url}/menu_bg_s.gif?$_REQUEST{__static_salt}" width=0><img height=26 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=0 border=0></td>
EOH

	my $core_unblock_navigation = $preconf -> {core_unblock_navigation} || 0;

	foreach my $type (@types) {

		next if ($type -> {name} eq '_logout');
		
		if ($type -> {name} eq '_xls') {
		
			$type -> {href}   = "javaScript:_dumper_href ('&xls=1', 'invisible')";
		
		}

		$_REQUEST {__menu_links} .= "<a id='main_menu_$$type{name}' target='$$type{target}' href='$$type{href}' onclick='return !check_edit_mode (this);'>-</a>";
		
		$type -> {target} = '_body_iframe' if $type -> {target} eq '_self';

		if ($type eq BREAK) {
			$html .= qq{<td background="$_REQUEST{__static_url}/menu_bg.gif?$_REQUEST{__static_salt}" width=100%><img height=1 src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=1 border=0></td>};
			next;
		}
		
		my $a_options = {		
			class    => "main-menu",
			id       => "main_menu_$$type{name}",
			target   => $type -> {target},
			tabindex => -1,						
		};
		
		if ($type -> {no_page}) {
		
			$a_options -> {name}     = '' . $type;
			
		}
		else {

			$a_options -> {href}     = $type -> {href};
			$a_options -> {onClick} .= "setCursor (window, 'wait');" if $type -> {href} !~ /^javaScript/i && $type -> {target} eq '_body_iframe';

		}
		
		$a_options -> {onClick} .= " return !check_edit_mode (this);" if $type -> {name} ne '_dump';
		
		my $label = dump_tag (a => $a_options, "&nbsp;$type->{label}&nbsp;");
		
		$html .= qq {<td onmouseover="if (!edit_mode || $core_unblock_navigation) {$$type{onhover}; subsets_are_visible = 0; document.getElementById ('_body_iframe').contentWindow.subsets_are_visible = 0}" onmouseout="$$type{onmouseout}" class="main-menu" nowrap>&nbsp;$label</td>};
			
	}

	$html .= <<EOH;
		</table>
EOH

	foreach my $type (@types) {
		$html .= $type -> {vert_menu};
	}

	$html .= <<EOH;
	</div>
EOH

	return $html;
	
}

################################################################################

sub draw_vert_menu {

	my ($_SKIN, $name, $types, $level, $is_main) = @_;
		
	my $html = <<EOH;
		<div id="vert_menu_$name" style="display:none; position:absolute; z-index:100">
			<table id="vert_menu_table_$name" width=1 bgcolor=#454a7c cellspacing=0 cellpadding=0 border=0 border=1>
EOH


	foreach my $type (@$types) {
	
		if ($type eq BREAK) {

			$html .= <<EOH;
				<tr height=2>

					<td bgcolor=#5d6496 width=1><img height=2 src=$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt} width=1 border=0></td>
					<td bgcolor=#5d6496 width=1><img height=2 src=$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt} width=1 border=0></td>

					<td>
						<table width=90% border=0 cellspacing=0 cellpadding=0 align=center minheight=2>
							<tr height=1><td bgcolor="#888888"><img height=1 src=$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt} width=1 border=0></td></tr>
							<tr height=1><td bgcolor="#ffffff"><img height=1 src=$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt} width=1 border=0></td></tr>
						</table>
					</td>
				</tr>
EOH
		}
		else {
		
			$type -> {onclick} =~ s{'_self'\)$}{'_body_iframe'\)} unless ($_REQUEST {__tree});
		
			my $td = $type -> {items} ? <<EOH : qq{<td nowrap onclick="$$type{onclick}" onmouseover="$$type{onhover}" onmouseout="$$type{onmouseout}" class="vert-menu">&nbsp;&nbsp;$$type{label}&nbsp;&nbsp;</td>};
				<td nowrap onclick="$$type{onclick}" class="vert-menu" onmouseover="$$type{onhover}" onmouseout="$$type{onmouseout}">
						<table width="100%" cellspacing=0 cellpadding=0 border=0><tr>
							<td align="left" nowrap style="font-family: Tahoma, 'MS Sans Serif'; font-weight: normal; font-size: 8pt; color: #ffffff;">&nbsp;&nbsp;$$type{label}&nbsp;&nbsp;</td>
							<td align="right" style="font-family: Marlett; font-weight: normal; font-size: 8pt; color: #ffffff;">8</td>
						</tr></table>
				</td>
EOH
			$html .= <<EOH;
					<tr>
						<td width=1 bgcolor=#5d6496><img height=1 src=$_REQUEST{__static_url}/0.gif width=1 border=0></td>
						<td width=1 bgcolor=#5d6496><img height=1 src=$_REQUEST{__static_url}/0.gif width=1 border=0></td>
					$td
				</tr>
EOH
		
		}
	
	}

	$html .= <<EOH;
			</table>
EOH

	foreach my $type (@$types) {
		$html .= $type -> {vert_menu};
	}

	$html .= <<EOH;
		</div>
EOH
	return $html;

}

################################################################################
# TABLES
################################################################################

################################################################################

sub js_set_select_option {

	my ($_SKIN, $name, $item, $fallback_href) = @_;

	return ($fallback_href || $i) unless $_REQUEST {select};
	
	$item -> {question} ||= "$i18n->{confirm_close_vocabulary} \"$item->{label}\"?" unless $conf -> {core_no_confirm_other};

	my $a = $_JSON -> encode ($item);
	
	return $_SO_VARIABLES -> {$a}
		if $_SO_VARIABLES -> {$a};

	my $var = "so_" . substr ('' . $item, 7, 7);
	$var =~ s/\)$//;
	
	my $i = 0;
	while (index ($_REQUEST {__script}, "var $var") != -1) {
		$var .= $i ++;
	}

	$_REQUEST {__script} .= " var $var = $a; ";

	$_SO_VARIABLES -> {$a} = "javaScript:invoke_setSelectOption ($var)";
	
	return $_SO_VARIABLES -> {$a};

}

################################################################################

sub draw_text_cell {

	my ($_SKIN, $data, $options) = @_;
	
	if (defined $data -> {level}) {
	
		$data -> {attributes} -> {style} = 'padding-left:' . ($data -> {level} * 15 + 3);
	
	}
	
	$data -> {attributes} -> {title} = HTML::Entities::decode_entities ($data -> {attributes} -> {title}) if $data -> {attributes} -> {title} =~ /\&/;
	
	my $html = dump_tag ('td', $data -> {attributes});
	
	if ($data -> {off} || $data -> {label} !~ s/^\s*(.+?)\s*$/$1/gsm) {

		return $html . '&nbsp;</td>';
	
	}
	
	$data -> {label} =~ s{\n}{<br>}gsm if $data -> {no_nobr};

	$html .= qq {<img src='$_REQUEST{__static_url}/status_$data->{status}->{icon}.gif' border=0 alt='$data->{status}->{label}' align=absmiddle hspace=5>} if $data -> {status};

	$html .= '<nobr>' unless $data -> {no_nobr};

	if ($data -> {href}) {
		
		$html .= $data -> {href} eq $options -> {href} ? '<span>' : qq {<a id="$$data{a_id}" class=$$data{a_class} $$data{onclick} target="$$data{target}" href="$$data{href}" onFocus="blur()">};
		
	}

	$html .= '<b>'      if $data -> {bold}   || $options -> {bold};
	$html .= '<i>'      if $data -> {italic} || $options -> {italic};
	$html .= '<strike>' if $data -> {strike} || $options -> {strike};

	$html .= $data -> {label};

	if ($data -> {href}) {

		$html .= $data -> {href} eq $options -> {href} ? '</span>' : '</a>';
		
	}
		
	$html .= '</nobr>' unless $data -> {no_nobr};

	$html .= dump_hiddens ([$data -> {hidden_name} => $data -> {hidden_value}]) if $data -> {add_hidden};
			
	$html .= '</td>';

	return $html;

}

################################################################################

sub draw_radio_cell {

	my ($_SKIN, $data, $options) = @_;

	my $attributes = dump_attributes ($data -> {attributes});

	return qq {<td $$options{data} $attributes><input class=cbx type=radio name=$$data{name} $$data{checked} value='$$data{value}'></td>};

}

################################################################################

sub draw_datetime_cell {

	my ($_SKIN, $data, $options) = @_;
		
	my $attributes = dump_attributes ($data -> {attributes});

	local $options -> {name} = $data -> {name};

	return "<td $$options{data} $attributes>" . $_SKIN -> _draw_input_datetime ($options) . "</td>";
	
}

################################################################################

sub draw_checkbox_cell {

	my ($_SKIN, $data, $options) = @_;

	my $attributes = dump_attributes ($data -> {attributes});
	
	my $label = $data -> {label} ? '&nbsp;' . $data -> {label} : '';

	return qq {<td $$options{data} $attributes><input class=cbx type=checkbox name=$$data{name} $$data{checked} value='$$data{value}'>$label</td>};

}

################################################################################

sub draw_select_cell {

	my ($_SKIN, $data, $options) = @_;

	my $attributes = dump_attributes ($data -> {attributes});

	my $multiple = $data -> {rows} > 1 ? "multiple size=$$data{rows}" : '';
	
	$data -> {onChange} ||= $options -> {onChange};
	
	my $html = qq {<td $attributes><select 
		name="$$data{name}" 
		onChange="is_dirty=true; $$data{onChange}" 
		onkeypress='typeAhead();' 
		$multiple
	};
	
	if (($options -> {__fixed_cols} > 0) && msie_less_7) {

		$html .= qq {style= "visibility:expression(cell_select_visibility(this, $options->{__fixed_cols}))"};

	}

	$html .= '>';

	$html .= qq {<option value="0">$$data{empty}</option>\n} if defined $data -> {empty};

	foreach my $value (@{$data -> {values}}) {
		$html .= qq {<option value="$$value{id}" $$value{selected}>$$value{label}</option>\n};
	}
	
	$html .= qq {</select></td>};
	
	return $html;

}


################################################################################

sub draw_string_voc_cell {

	my ($_SKIN, $data, $options) = @_;

	my $attributes = dump_attributes ($data -> {attributes});

	if (defined $data -> {other}) {
		
		$data -> {other} -> {width}  ||= $conf -> {core_modal_dialog_width} || 'screen.availWidth - (screen.availWidth <= 800 ? 50 : 100)';
		$data -> {other} -> {height} ||= $conf -> {core_modal_dialog_height} || 'screen.availHeight - (screen.availHeight <= 600 ? 50 : 100)';
	
		$data -> {other} -> {onChange} .= <<EOJS;			
			var dialog_width = $data->{other}->{width};
			var dialog_height = $data->{other}->{height};
			
			var q = encode1251(document.getElementById('$$data{name}_label').value);
			
			var result = window.showModalDialog ('$ENV{SCRIPT_URI}/i/_skins/TurboMilk/dialog.html?@{[rand ()]}', {href: '$data->{other}->{href}&$data->{other}->{param}=' + q + '&select=$data->{name}'}, 'status:no;resizable:yes;help:no;dialogWidth:' + dialog_width + 'px;dialogHeight:' + dialog_height + 'px');
			
			focus ();
			
			if (result.result == 'ok') {						
				document.getElementById('$$data{name}_label').value = result.label;
				document.getElementById('$$data{name}_id').value = result.id;
			}
EOJS
	}
		
	my $html = qq {<td $attributes><nobr><span style="white-space: nowrap"><input onFocus="q_is_focused = true; left_right_blocked = true;" onBlur="q_is_focused = false; left_right_blocked = false;" type="text" value="$$data{label}" name="$$data{name}_label" id="$$data{name}_label" maxlength="$$data{max_len}" size="$$data{size}"> }
		. ($data -> {other} ? qq [<input type="button" value="$data->{other}->{button}" onclick="$data->{other}->{onChange}">] : '')
		. dump_tag (input => {
		
			type  => "hidden", 
			name  => "_$data->{name}", 
			value => "$data->{id}",
			id    => "$data->{name}_id",
			
		})
		. '</span></nobr></td>';		

	return $html;
 
}

################################################################################

sub draw_input_cell {

	my ($_SKIN, $data, $options) = @_;

	my $autocomplete;
	my $attr_input = {
		onBlur => 'q_is_focused = false; left_right_blocked = false;',
		onKeyDown => 'tabOnEnter();'
	};
	
	if ($data -> {autocomplete}) {
		my $id = '' . $data -> {autocomplete};
		$_REQUEST {__script} .= qq{;
			function off_suggest$data->{name} () {
				var s = document.getElementById ('$data->{name}__suggest');
				s.style.display = 'none';
				try {tableSlider.cell_on ();} catch(e) {};
			};
		};

		$attr_input -> {autocomplete} = 'off';
		$attr_input -> {onBlur}     .= qq{; _suggest_timer$data->{name} = setTimeout (off_suggest$data->{name}, 100);};
		$attr_input -> {onChange}   .= "$data->{autocomplete}{after};";
		$attr_input -> {onKeyDown}  .= <<EOH;
			var s = getElementById('$data->{name}__suggest');

			if (window.event.keyCode == 40 && s.style.display == 'block') {
				s.focus ();
			}
EOH
		$attr_input -> {onKeyUp} .= <<EOH;
			if (suggest_clicked) {
				suggest_clicked = 0;
			}
			else {
				var f = this.form;
				var s = f.elements ['__suggest'];
				document.getElementById ('$data->{name}__suggest').style.display = 'none';
				if (this.value.length > 0) {
					s.value = '$data->{name}';
					f.submit ();
					s.value = '';
				}
			}
EOH
		$data -> {autocomplete} -> {after} .= ';try {tableSlider.cell_on ();} catch(e) {};';
		$data -> {autocomplete} -> {lines} ||= 10;

		$autocomplete = qq {
			<script>
				var _suggest_timer$data->{name} = null;
			</script>
			<select 
				id="$data->{name}__suggest" 
				name="$data->{name}__suggest" 
				size="$data->{autocomplete}{lines}"
				style="
					display : none;
					position: absolute;
					border  : solid black 1px;
					z-index : 100;
				"
				onFocus="
					if (_suggest_timer$data->{name}) {
						clearTimeout (_suggest_timer$data->{name});
						_suggest_timer$data->{name} = null;
					}
				"
				onBlur="this.style.display='none'; $data->{autocomplete}{after}"
				onDblClick="set_suggest_result (this, '$$data{name}'); $data->{autocomplete}{after}"
				onKeyPress="set_suggest_result (this, '$$data{name}'); $data->{autocomplete}{after}; suggest_clicked = 1"
			>
			</select>
		};
	}

	my $attributes = dump_attributes ($data -> {attributes});
	$attr_input = dump_attributes ($attr_input);
	
	$data -> {label} =~ s{\"}{\&quot;}gsm;

	my $tabindex = 'tabindex=' . (++ $_REQUEST {__tabindex});

	return qq {<td $$data{title} $attributes><nobr><input onFocus="q_is_focused = true; left_right_blocked = true;" $attr_input name="$$data{name}" value="$$data{label}" maxlength="$$data{max_len}" size="$$data{size}" $tabindex>$autocomplete</nobr></td>};

}

################################################################################

sub draw_row_button {

	my ($_SKIN, $options) = @_;

	if ($options -> {off} || $_REQUEST {lpt}) {	
		return $conf -> {core_hide_row_buttons} == 2 ? '' : '<td class=bgr0 valign=top nowrap width="1%">&nbsp;</td>';
	}
	
	if ($conf -> {core_show_icons} || $_REQUEST {__core_show_icons}) {

		my $label = $options -> {label};
		my $img_path = _icon_path ($options -> {icon});

		$options -> {label} = qq|&nbsp;<img src="$img_path" alt="$$options{label}" border=0 hspace=0 vspace=0 align=absmiddle>&nbsp;|;
		$options -> {label} .= "&nbsp;$label" if $options -> {force_label} || $conf -> {core_hide_row_buttons} > -1;
		
	}
	else {
		$options -> {label} = "\&nbsp;[$$options{label}]\&nbsp;";
	}
	
	my $vert_line = {label => $options -> {label}, href => $options -> {href}, target => $options -> {target}};
	$vert_line -> {label} =~ s{[\[\]]}{}g;
	push @{$_SKIN -> {__current_row} -> {__types}}, $vert_line;
		
	if ($conf -> {core_hide_row_buttons} == 2) {
		return '';
	}
	elsif ($conf -> {core_hide_row_buttons} == 1) {
		return $_SKIN -> draw_text_cell ({label => '&nbsp;'});
	}
	else {
		return qq {<td $$options{title} class="row-button" valign=top nowrap width="1%"><a TABINDEX=-1 class="row-button" href="$$options{href}" target="$$options{target}">$$options{label}</a></td>};
	}

}

####################################################################

sub draw_table_header {
	
	my ($_SKIN, $data_rows, $html_rows) = @_;
	my $html = '<thead>';
	foreach (@$html_rows) {$html .= $_};
	$html .= '</thead>';
	
}

####################################################################

sub draw_table_header_row {
	
	my ($_SKIN, $data_cells, $html_cells) = @_;
	
	my $html = '<tr>';
	foreach (@$html_cells) {$html .= $_};
	$html .= '</tr>';
	
	return $html;
	
}

####################################################################

sub draw_table_header_cell {
	
	my ($_SKIN, $cell) = @_;
	
	return '' if $cell -> {hidden} || $cell -> {off} || (!$cell -> {label} && $conf -> {core_hide_row_buttons} == 2);

	$cell -> {label} .= "\&nbsp;\&nbsp;<a class=row-cell-header-a href=\"$$cell{href_asc}\"><b>\&uarr;</b></a>"  if $cell -> {href_asc};
	$cell -> {label} .= "\&nbsp;\&nbsp;<a class=row-cell-header-a href=\"$$cell{href_desc}\"><b>\&darr;</b></a>" if $cell -> {href_desc};

	if (($cell -> {order} || $cell -> {href} =~ /\border=/) && !$conf -> {core_no_order_arrows}) {
		$cell -> {label} = "<nobr><img src='$_REQUEST{__static_url}/order.gif' border=0 hspace=1 vspace=0 align=absmiddle>" . $cell -> {label} . "</nobr>";
	}	
	else {
		$cell -> {label} = '&nbsp;' . $cell -> {label};
	}

	if ($cell -> {href}) {
		$cell -> {label} = "<a class=row-cell-header-a href=\"$$cell{href}\"><b>" . $cell -> {label} . "</b></a>";
	}	

	my $attributes = dump_attributes ($cell -> {attributes});
	
	my $z_index = $cell -> {no_scroll} ? 'style="z-index:110"' : 'style="z-index:100"';

	return "<th $attributes $$cell{title} $z_index>$$cell{label}\&nbsp;</th>";

}

####################################################################

sub draw_table {

	my ($_SKIN, $tr_callback, $list, $options) = @_;
	
	$options -> {id} ||= '' . $options;
	$options -> {id} =~ s{[\(\)]}{}g;
	
	$_REQUEST {__script} .= "; scrollable_table_ids.push ('$options->{id}');";

	$options -> {height}     ||= 10000;
	$options -> {min_height} ||= 200;
	
	$$options{toolbar} =~ s{^\s+}{}sm;
	$$options{toolbar} =~ s{\s+$}{}sm;

	my $html = '';
	
	my %hidden = ();
	
	$hidden {$_} = $_REQUEST {$_} foreach (
		'__tree', 
		'__last_scrollable_table_row',
		grep {/^[^_]/ or /^__get_ids_/} keys %_REQUEST
	);
	
	$hidden {$_} = $options -> {$_} foreach (
		'type', 
		'action',
	);

	$hidden {__last_query_string} = $_REQUEST{__last_last_query_string};
	
	while (my ($k, $v) = each %hidden) {
	
		$html .= "\n" . dump_tag (input => {
			
			type  => 'hidden',
			name  => $k,
			value => $v,
			
		}) if defined $v;
	
	}

	$html .= qq {<td class=bgr8>};
	
	$html .= $options -> {container} ?
		$options -> {container} :
			$options -> {no_scroll} ?
			qq {<div class="table-container-x" onScroll="tableSlider.cell_on()">} :
			qq {<div class="table-container" onScroll="tableSlider.cell_on()" style="height: expression(actual_table_height(this,$$options{min_height},$$options{height},'$__last_centered_toolbar_id'));">};

	$html .= qq {<table cellspacing=1 cellpadding=0 width="100%" id="$options->{id}">\n};

	$html .= $options -> {header} if $options -> {header};

	$html .= qq {<tbody>\n};

	if ($options -> {dotdot}) {
		$html .= $options -> {dotdot};
	}

	my $menus = '';

	foreach our $i (@$list) {
		
		foreach my $tr (@{$i -> {__trs}}) {
		
			my $has_href = $i -> {__href} && ($_REQUEST {__read_only} || !$_REQUEST {id} || $options -> {read_only});
			
			$html .= "<tr id='$$i{__tr_id}'";
			
			if (@{$i -> {__types}} && $conf -> {core_hide_row_buttons} > -1 && !$_REQUEST {lpt}) {
				$menus .= $i -> {__menu};
				$html  .= qq{ oncontextmenu="open_popup_menu('$i'); blockEvent ();"};
			}

			$html .= '>';
			$html .= qq {<a target="$$i{__target}" href="$$i{__href}">} if $has_href;
			$html .= $tr;
			$html .= qq {</a>} if $has_href;
			$html .= '</tr>';
			
		}
		
	}

	$html .= <<EOH;
			</tbody></table></div>$$options{toolbar}</td></form></tr></table>
		$menus
		
EOH

	$__last_centered_toolbar_id = '';
	
	my $enctype = $html =~ /\btype\=[\'\"]?file\b/ ? 
		'enctype="multipart/form-data"' : '';

	return <<EOH . $html;
	
		$$options{title}
		$$options{path}
		$$options{top_toolbar}

		<table cellspacing=0 cellpadding=0 width="100%">
			<tr>
				<form name=$$options{name} action=$_REQUEST{__uri} method=post target=invisible $enctype>
				<input type=hidden name="__suggest" value="">
EOH

}

################################################################################

sub draw_one_cell_table {

	my ($_SKIN, $options, $body) = @_;
	
	return <<EOH			
		<table cellspacing=0 cellpadding=0 width="100%">
				<form name=form action=$_REQUEST{__uri} method=post enctype=multipart/form-data target=invisible>
					<tr><td class=bgr8>$body</td></tr>
				</form>
		</table>
EOH

}

################################################################################

sub start_page {
}

################################################################################

sub draw_page_just_to_reload_menu {

	my ($_SKIN, $page) = @_;
	
	my $a = $_JSON -> encode ([$page -> {menu}]);

	my $md5 = Digest::MD5::md5_hex (freeze ($page -> {menu_data}));
	
	qq {
		var wm = ancestor_window_with_child ('main_menu');
		var a = $a;
		wm.child.outerHTML = $a [0];
		wm.window.menu_md5 = '$md5';
	}; 

}

################################################################################

sub draw_page {

	my ($_SKIN, $page) = @_;

	$_REQUEST {__only_menu} and return $_SKIN -> draw_page_just_to_reload_menu ($page);
								
	my $parameters = ref ${$_PACKAGE . 'apr'} eq 'Apache2::Request' ? ${$_PACKAGE . 'apr'} -> param : ${$_PACKAGE . 'apr'} -> parms;

	my $body = $page -> {body};
	
	my $body_options = {
		bgcolor      => 'white',
		leftMargin   => 0,
		topMargin    => 0,
		bottomMargin => 0,
		rightMargin  => 0,
		marginwidth  => 0,
		marginheight => 0,
		scroll       => 'yes',
		name         => 'body', 
		id           => 'body',
	};
	
	if (!$_USER -> {id}) {
	
		$body_options -> {scroll} = 'no';

	} 
	elsif (($parameters -> {__subset} || $parameters -> {type}) && !$_REQUEST {__top}) {

		$body .= qq {

			<div style='display:none'>$_REQUEST{__menu_links}</div>

			<v:rect style='position:absolute; left:200px; top:300px; height:100px; width:100px; z-index:0; visibility:hidden' strokecolor="#888888" strokeweight="2px" filled="no" id="slider" />
			<v:rect style='position:absolute; left:200px; top:300px; height:6px; width:6px; z-index:0; visibility:hidden' strokecolor="#ffffff" strokeweight="1px" filled="yes" fillcolor="#555555" id="slider_" />

		};
		
		$_REQUEST {__script}  .= '; check_top_window (); ';

		$_REQUEST {__on_load} .= "try {top.setCursor ()} catch (e) {}; tableSlider.set_row (" . ($_REQUEST {__scrollable_table_row} ||= 0) . ");";
		
		$_REQUEST {__on_load} .= "check_menu_md5 ('" . Digest::MD5::md5_hex (freeze ($page -> {menu_data})) . "');" if !($_REQUEST {__no_navigation} or $_REQUEST {__tree});
		
		$_REQUEST {__on_load} .= 'window.focus ();'                                                                 if ! $_REQUEST {__no_focus};

		$_REQUEST {__on_load} .= "focus_on_input ('$_REQUEST{__focused_input}');"                                   if   $_REQUEST {__focused_input};

		$_REQUEST {__on_load} .= $_REQUEST {__edit} ? " try {top.edit_mode = 1} catch (e) {};" : " try {top.edit_mode = 0} catch (e) {};"                 if ! $_REQUEST {select};

		if ($_REQUEST {__im_delay}) {
		
			$_REQUEST {__js_var} -> {__im} = {
				delay =>  $_REQUEST {__im_delay},
				idx   =>  "/i/_mbox/$_USER->{id}.txt",
				url   =>  "/?sid=$_REQUEST{sid}&type=_mbox&action=read",
				timer =>  0,
			};
		
			$_REQUEST {__on_load} .= '; try {__im_check ()} catch (e) {} ;';
		
		}

		$_REQUEST {__on_mouseover}    .= "window.parent.subsets_are_visible = 0; subsets_are_visible = 0;";

		$_REQUEST {__on_mousedown}    .= "if (window.event.button == 2 && window.event.ctrlKey && !window.event.altKey && !window.event.shiftKey) nope (window.location.href + '&__dump=1', '_blank', 'toolbar=no,resizable=yes,scrollbars=yes');\n" if $preconf -> {core_show_dump};

		$_REQUEST {__on_keydown}      .= " handle_basic_navigation_keys ();";

		foreach my $r (@{$page -> {scan2names}}) {
			next if $r -> {off};
			$r -> {data} .= '';
			my $i = 2 * $r -> {alt} + $r -> {ctrl};
			$_REQUEST {__on_load} .= "\nkb_hooks [$i] [$r->{code}] = [handle_hotkey_$r->{type}, ";
			foreach (qw (ctrl alt off type code)) {delete $r -> {$_}}
			$_REQUEST {__on_load} .=  $_JSON -> encode ($r);
			$_REQUEST {__on_load} .= '];';
		}

		$_REQUEST {__on_keydown}      .= " if (code_alt_ctrl (115, 0, 0)) return blockEvent ();";

		$_REQUEST {__on_help}          = " nope ('$_REQUEST{__help_url}', '_blank', 'toolbar=no,resizable=yes'); blockEvent ();" if $_REQUEST {__help_url};

		$_REQUEST {__on_resize}       .= " refresh_table_slider_on_resize ();";

		$_REQUEST {__on_beforeunload} .= " setCursor (window, 'wait'); try {top.setCursor (top, 'wait')} catch (e) {};";

		$_REQUEST {__head_links}      .= "<META HTTP-EQUIV=Refresh CONTENT='$_REQUEST{__meta_refresh}; URL=@{[create_url()]}&__no_focus=1'>" if $_REQUEST {__meta_refresh};

		$_REQUEST {__js_var} -> {__read_only}              = $_REQUEST {id} ? 0 + $_REQUEST {__read_only} : 1;

		$_REQUEST {__js_var} -> {__last_last_query_string} = 0 + $_REQUEST{__last_query_string};

		$body =~ /^\s*\<frameset/ism or $body = qq {
		
			<table id="body_table" cellspacing=0 cellpadding=0 border=0 width=100% height=100%>
				<tr><td valign=top height=100%>$body</td></tr>
			</table>

		};

	}
	else {

		$body_options -> {scroll} = 'no';
		
		delete $_REQUEST {__invisibles};
		
		$_REQUEST {__on_load}  = "window.focus (); setInterval (UpdateClock, 500); nope ('" . create_url (__subset => $_SUBSET -> {name}) . "', '_body_iframe');";
		
		$_REQUEST {__on_load} .= "setInterval (function () {\$.get ('$_REQUEST{__uri}?keepalive=$_REQUEST{sid}&_salt=' + Math.random ())}," . 60000 * (($conf -> {session_timeout} ||= 30) - 0.5) . ');' if !$preconf -> {no_keepalive};

#				<tr height=48><td height=48>$page->{auth_toolbar}</td></tr><tr><td>$$page{menu}</td></tr>
		$body = qq {
		
			<table id="body_table" cellspacing=0 cellpadding=0 border=0 width=100% height=100%>
				<tr><td>$page->{auth_toolbar}</td></tr><tr><td>$$page{menu}</td></tr>
				<tr><td valign=top height=100%>
					<iframe name='_body_iframe' id='_body_iframe' src="$_REQUEST{__static_url}/0.html" width=100% height=100% border=0 frameborder=0 marginheight=0 marginwidth=0 application=yes>
					</iframe>
				</td></tr>
			</table>

		};
			
	}
	
	$_REQUEST {__js_var} -> {menu_md5}                 = Digest::MD5::md5_hex (freeze ($page -> {menu_data}));

	$_REQUEST {__js_var} -> {edit_mode}                = undef;
	
	$_REQUEST {__js_var} -> {edit_mode_args}           = 

		$preconf -> {core_unblock_navigation} ? {dialog_url => "$ENV{SCRIPT_URI}/i/_skins/TurboMilk/dialog.html?$_REQUEST{__static_salt}"} : 

		!$_REQUEST {__only_tree_frameset}     ? {label      => $i18n -> {save_or_cancel}} :

		undef;

	;

	my $js_var = $_REQUEST {__js_var};
			
	$_REQUEST {__script}     .= "\nvar $_ = " . $_JSON -> encode ($js_var -> {$_}) . ";\n"                              foreach (keys %$js_var);
	
	$_REQUEST {__head_links} .= "<link  href='$_REQUEST{__static_site}/i/$_.css' type=text/css rel=stylesheet>"         foreach (@{$_REQUEST {__include_css}});

	$_REQUEST {__head_links} .= "<script src='$_REQUEST{__static_site}/i/${_}.js?$_REQUEST{__static_salt}'>\n</script>" foreach (@{$_REQUEST {__include_js}});

	foreach (keys %_REQUEST) {
	
		/^__on_(\w+)$/ or next;
		
		my $attributes = {};
		my $code       = $_REQUEST {$&};
		
		if ($1 eq 'load') {
			
			$code  = "\n\$(document).ready (function () {\n${code}\n})\n";
			
		}
		else {
		
			$attributes -> {event} = "on$1";
			$attributes -> {for}   = $1 eq 'resize' ? 'window' : $1 eq 'beforeunload' ? 'window' : 'document';
				
		}
		
		$_REQUEST {__head_links} .= dump_tag (script => $attributes, $code) . "\n";

	}
	
	$_REQUEST {__head_links} .= dump_tag (script => {}, $_REQUEST {__script}) . "\n";	
	
	$_REQUEST {__head_links}  = qq {

		<title>$$i18n{_page_title}</title>
						
		<meta name="Generator" content="Eludia ${Eludia::VERSION} / $$SQL_VERSION{string}; parameters are fetched with @{[ ref $apr ]}; gateway_interface is $ENV{GATEWAY_INTERFACE}; @{[$ENV {MOD_PERL} || 'NO mod_perl AT ALL']} is in use">
		<meta http-equiv=Content-Type content="text/html; charset=$$i18n{_charset}">
						
		<LINK href="$_REQUEST{__static_url}/eludia.css?$_REQUEST{__static_salt}" type=text/css rel=STYLESHEET>
		<style>
			v\\:*           { behavior: url(#default#VML); }
			#admin          { width:205px;height:25px;padding:5px 5px 5px 9px;background:url('$_REQUEST{__static_url}/menu_button.gif') no-repeat 0 0;}
			.calendar .nav  { background: transparent url($_REQUEST{__static_url}/menuarrow.gif) no-repeat 100% 100%; }
			td.main-menu    { padding-top:1px; padding-bottom:1px; background-image: url($_REQUEST{__static_url}/menu_bg.gif); cursor: pointer; }
			td.vert-menu    { background-color: #454a7c;font-family: Tahoma, 'MS Sans Serif';font-weight: normal;font-size: 8pt;color: #ffffff;text-decoration: none;padding-top:4px;padding-bottom:4px;background-image: url($_REQUEST{__static_url}/menu_bg.gif);cursor: pointer;}
			td.login-head   { background:url('$_REQUEST{__static_url}/login_title_pix.gif') repeat-x 1 1 #B9C5D7;font-size:10pt;font-weight:bold;padding:7px;}
			td.submit-area  { text-align:center;height:36px;background:url('$_REQUEST{__static_url}/submit_area_bgr.gif') repeat-x 0 0;}
			div.grey-submit { background:url('$_REQUEST{__static_url}/grey_ear_left.gif') no-repeat 0 0; width:165;min-width:150px;padding-left:20px;}
		</style>

		<script src="$_REQUEST{__static_url}/navigation.js?$_REQUEST{__static_salt}">
		</script>
		<script src="$_REQUEST{__static_url}/i18n_$_REQUEST{lang}.js?$_REQUEST{__static_salt}">
		</script>

	} . $_REQUEST {__head_links};
	
	if ($body !~ /^\s*\<frameset/ism) {

		$body .= "<iframe name='$_' src='$_REQUEST{__static_url}/0.html' width=0 height=0 application='yes' style='display:none'>\n</iframe>" foreach (@{$_REQUEST{__invisibles}});
		
		$body  = dump_tag (body => $body_options, $body);

	}

	return qq {<html xmlns:v="urn:schemas-microsoft-com:vml"><head>$_REQUEST{__head_links}</head>$body</html>};

}

################################################################################

sub handle_hotkey_focus {

	my ($r) = @_;
	
	$r -> {ctrl} += 0;
	$r -> {alt}  += 0;

	<<EOJS
		if (code_alt_ctrl ($$r{code}, $r->{alt}, $r->{ctrl})) {
			document.form.$$r{data}.focus ();
			return blockEvent ();
		}
EOJS

}

################################################################################

sub handle_hotkey_focus_id {

	my ($r) = @_;

	$r -> {ctrl} += 0;
	$r -> {alt}  += 0;

	<<EOJS
		if (code_alt_ctrl ($$r{code}, $r->{alt}, $r->{ctrl})) {
			document.getElementById ('$r->{data}').focus ();
			return blockEvent ();
		}
EOJS

}

################################################################################

sub handle_hotkey_href {

	my ($r) = @_;
	
	$r -> {ctrl} += 0;
	$r -> {alt}  += 0;
	
	my $condition = 
		$r -> {off}     ? '0' :
		$r -> {confirm} ? 'window.confirm(' . js_escape ($r -> {confirm}) . ')' : 
		'1';
			
#	my $code = !$r -> {href} ? "activate_link_by_id ('$$r{data}')" : "nope ('$$r{href}&__from_table=1&salt=' + Math.random () + '&' + scrollable_rows [scrollable_table_row].id, '_self');";
	my $code = !$r -> {href} ? "activate_link_by_id ('$$r{data}')" : "nope ('$$r{href}&__from_table=1&salt=' + Math.random (), '_self');";

	$condition eq '1' or $code = "if ($condition) {$code}";
	

	return <<EOJS
		if (code_alt_ctrl ($$r{code}, $r->{alt}, $r->{ctrl})) $code;
EOJS

}

################################################################################

sub lrt_print {

	my $_SKIN = shift;

	my $id = int (time * rand);
	$r -> print ("<span id='$id'><font color=white>");
	$r -> print (@_);
	$r -> print ("</span>");
	$r -> print ($lrt_bar);	
	$r -> print (<<EOH);
	<script>
		document.getElementById ('$id').scrollIntoView (false);
	</script>
	</body></html>
EOH


}

################################################################################

sub lrt_println {

	my $_SKIN = shift;

	$_SKIN -> lrt_print (@_, '<br>');
	
}

################################################################################

sub lrt_ok {
	my $_SKIN = shift;
	my $color = $_[1] ? 'red' : 'yellow';
	my $label = $_[1] ? '������' : '��';
	$_SKIN -> lrt_println ("$_[0] <font color='$color'><b>[$label]</b></font>");
}

################################################################################

sub lrt_start {

	my $_SKIN = shift;

	$|=1;
	
	$r -> content_type ('text/html; charset=windows-1251');
	$r -> send_http_header ();
	
	$_SKIN -> lrt_print (<<EOH);
		<html><head><LINK href="$_REQUEST{__static_url}/eludia.css?$_REQUEST{__static_salt}" type=text/css rel=STYLESHEET><style>BODY {background-color: black}</style></head><BODY BGCOLOR='#000000' TEXT='#dddddd'><font face='Courier New'>
			<iframe name=invisible src="$_REQUEST{__static_url}/0.html" width=0 height=0 application="yes">
			</iframe>
EOH

}

################################################################################

sub lrt_finish {

	my $_SKIN = shift;

	my ($banner, $href, $options) = @_;
	
	if ($options -> {kind} eq 'download') {
		
		$r -> print ($options -> {toolbar});

		my $js = q {

			var download = document.getElementById ('download');
			
			download.scrollIntoView (true);

		};
		
		$js .= user_agent () -> {nt} >= 6 ? '' : ' download.click ();';

		$r -> print ("<script>$js</script></body></html>" . (' ' x 4096));

	}
	elsif ($options -> {kind} eq 'link') {
		$_SKIN -> lrt_print (<<EOH);
		<br><a href="javascript: document.location = '$href'"><font color='yellow'>$banner</font></a>
		</body></html>
EOH
	}
	else {
	
		$_SKIN -> lrt_print (<<EOH);
		<script>
			alert ('$banner');
			document.location = '$href';
		</script>
		</body></html>
EOH

	}

}

################################################################################

sub draw_logon_form {

	my ($_SKIN, $options) = @_;

	if ($options -> {hta}) {
	
		$_REQUEST {__on_load} .= <<EOH;
		
			if (window.name != 'application_frame' && confirm ('$i18n->{hta_confirm}')) {
											
				var _hta = hta ();
			
				SetupHTA (
					_hta.code, 
					_hta.title, 
					_hta.url, 
					_hta.content, 
					_hta.icon, 
					_hta.hotkey
				);
			
			}
		
EOH
		
		
	
	}





	my $focused_field = $_COOKIE {user_login} ? 'password' : 'login';

	$_REQUEST {__on_load} .= qq {document.forms[0].elements["$focused_field"].focus ();};
	
	if ($preconf -> {core_fix_tz}) {
		my $tz = (Date::Calc::Timezone ()) [3] || 0;
		$_REQUEST {__on_load} .= " var d = new Date(); document.form.tz_offset.value=$tz - d.getTimezoneOffset()/60;";
	} 
	
	my $hiddens = dump_hiddens (
		[type            => 'logon'],
		[action          => 'execute'],
		[redirect_params => $_REQUEST {redirect_params}],
		[tz_offset       => ''],
	);

	return <<EOH;

<table border="0" cellpadding="0" cellspacing="0" align=center height=100% width=100%>

	<tr>

		<td valign=top height=90>
			<table id="logo_table" cellSpacing=0 cellPadding=0 width="100%" border=0 bgcolor="#e5e5e5" background="$_REQUEST{__static_site}/i/bg_logo_out.gif" style="background-repeat: repeat-x" height=90>
				<tr>
				<td width="20"><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=20 height=90 border=0></td>
				<td width=1><table border=0 valign="middle" border=0><tr>
					<td valign="top" width=1><img src="$_REQUEST{__static_site}/i/logo_out.gif" border="0"></td>
					<td width=1><img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=10 height=1 border=0></td>
					<td width=1 valign="bottom" style='padding-bottom: 5px;'><img src="$_REQUEST{__static_url}/gsep.gif?$_REQUEST{__static_salt}" width="4" height="21"></td>
					<td align="left" valign="middle" class='header_0' width=1><nobr>&nbsp;$$conf{page_title}</nobr></td>
				</tr></table></td>				
				
				<td width="20px" align="right">&nbsp;</td></tr>
			</table>

		</td>

	</tr>
	
	<tr>
	
		<td align=center valign=middle>

			<table border="0" cellpadding="4" cellspacing="1" width="470" height="225" bgcolor="#EAEAF0" class="logon">
				<tr><td class="login-head">$i18n->{authorization}</td></tr>
				<tr>
					<td bgcolor="#F9F9FF" align="center" style="border-bottom:solid 1px #9AA0A3; height:150px;">
						
					
						<table border="0" cellpadding="8" cellspacing="0">
						<form action="$_REQUEST{__uri}" method=post autocomplete="off" name=form target="$options->{target}">
							$hiddens
							<tr class="logon">
								<td><b>$i18n->{login}:</b></td>
								<td><input type="text" name="login" value="$_COOKIE{user_login}" style="width:200px;" onfocus="q_is_focused = true" onblur="q_is_focused = false" onKeyPress="if (window.event.keyCode == 13) form.password.focus ()"></td>
							</tr>
							<tr class="logon">
								<td><b>$i18n->{password}:</b></td>
								<td><input type="password" name="password" style="width:200px;" onfocus="q_is_focused = true" onblur="q_is_focused = false" onKeyPress="if (window.event.keyCode == 13) form.submit ()"></td>
							</tr>
							
							
						</form>
						</table>
					</td>
				</tr>
				<tr>
					<td class="submit-area">						
						<div class="grey-submit">
							<div style="float:left;margin-top:5px;"><a href="#"><img src="$_REQUEST{__static_url}/i_logon.gif?$_REQUEST{__static_salt}" border="0" align="left" hspace="5"></a><a href="javascript:document.forms['form'].submit()">$i18n->{execute_logon}</a></div>
							<div style="float:right;"><img src="$_REQUEST{__static_url}/grey_ear_right.gif?$_REQUEST{__static_salt}" border="0"></div>
						</div>
					</td>
				</tr>
			</table>
			
			
		</td>
		

		
	</tr>
	<tr>
		<td valign=top height=90>
			<img src="$_REQUEST{__static_url}/0.gif?$_REQUEST{__static_salt}" width=20 height=90 border=0>
		</td>
	</tr>
	
</table>

EOH

}

################################################################################

sub draw_tree {

	my ($_SKIN, $node_callback, $list, $options) = @_;
	
	my $menus = '';
	my @nodes = ();
	
	my ($root_id, $root_url, $selected_node_url, $selected_code);
	
	our %idx = ();
	our %lch = ();
		
	foreach my $i (@$list) {

		my $node = $i -> {__node};

		push @nodes, $node;
		
		($root_id, $root_url) = ($node -> {id}, $node -> {url}) unless $root_id;
			
		if ($node -> {id} == $options -> {selected_node}) {
			$selected_node_url = $options -> {url_base} . $node -> {url};
			$selected_code = 'win.d.selectedFound = true; win.d.selectedNode = ' . (@nodes - 1);

			&{$_PACKAGE . 'set_cookie'} (
				-name	=> "cs_$_REQUEST{type}",
				-value	=> $node -> {id},
			);
		}
       		
		$idx {$node -> {id}} = $node;
		$lch {$node -> {pid}} = $node if $node -> {pid};
		$menus .= $i -> {__menu};

	}
	
	unless ($selected_node_url) {
    		$options -> {selected_node} = $root_id;
    		$selected_node_url = $options -> {url_base} . $root_url;             	 
  	}
	
	while (my ($k, $v) = each %lch) {
		$idx {$k} -> {_hc} = 1;
		$v -> {_ls} = 1;
	}
	
	my $nodes = $_JSON -> encode (\@nodes);
	
	if ($options -> {active} && $_REQUEST {__parent}) {
	
		my $m = $_JSON -> encode ([$menus]);

		&{$_PACKAGE . 'set_cookie'} (
			-name	=> "co_$_REQUEST{type}",
			-value	=> ($_COOKIE {"co_$_REQUEST{type}"} ? $_COOKIE {"co_$_REQUEST{type}"} . '.' : '' ) . $_REQUEST {__parent},
		);

		return out_html ({}, <<EOH);
<html>
	<head>
		<script>
			
			function load () {
			
				var new_nodes = $nodes;
				for (i = 0; i < new_nodes.length; i++) {		
					var node = new_nodes [i];		
					if (node.title) continue;			
					node.title = node.label;		
				}
				var m = $m;
				var f = window.parent.parent.document.getElementById ('__tree_iframe');
				var d = f.contentWindow.d;
				var old_nodes = d.aNodes;
				var n = -1;

// prevent reload content frame
				d.selectedFound = true;
				var selected_node = d.selectedNode;
				old_nodes [selected_node]._is = false;

				for (i = 0; i < old_nodes.length; i ++) {
					var cn = old_nodes [i];
					if (cn.id != $_REQUEST{__parent}) continue;	
					n = i;
					cn._hac += new_nodes.length;
					cn._io = true;
					break;
				};

				var k = 0;
				var nodes = [];			

				for (i = 0;     i <= n;               i ++) nodes [k++] = old_nodes [i];
				for (i = 0;     i < new_nodes.length; i ++) nodes [k++] = new_nodes [i];
				for (i = n + 1; i < old_nodes.length; i ++) nodes [k++] = old_nodes [i];

				d.aNodes = nodes;
				
				f.contentWindow.document.getElementById ('dtree_td').innerHTML = d.toString ();
				f.contentWindow.document.getElementById ('dtree_menus').innerHTML += m [0];				
				f.contentWindow.document.body.style.cursor = 'default';
				d.selectedNode = selected_node <= n ? selected_node : selected_node + new_nodes.length;
				d.aNodes [d.selectedNode]._is = true;

				var eNew = f.contentWindow.document.getElementById("sd" + d.selectedNode);
				eNew.className = "nodeSel";
			}
			
		</script>
	</head>
	<body onLoad="load ()"></body>
</html>
EOH
	
	}

	$menus =~ s{[\n\r]+}{ }gsm;
	$menus =~ s/\"/\\"/gsm;  #"
	
	$options -> {active} += 0;
	
	if ($_COOKIE {"co_$_REQUEST{type}"}) {

		&{$_PACKAGE . 'set_cookie_for_root'} ("co_$_REQUEST{type}" => $_COOKIE {"co_$_REQUEST{type}"});
		
	}

	$_REQUEST {__only_tree_frameset} = 1;
	
	$_REQUEST {__on_load} .= <<EOH;
		var win = document.getElementById ('__tree_iframe').contentWindow;
		win.d = new win.dTree ('d');
		win.d._url_base = '$options->{url_base}';
		win.d._cookie_name = '$_REQUEST{type}';
		var c = win.d.config;
		c.iconPath = '$_REQUEST{__static_url}/tree_';
		c.target = '_content_iframe';
		c.useStatusText = true;
		c.useCookies = true;
		win.d.icon.node = 'folderopen.gif';
		
		var nodes = $nodes;
		
		for (i = 0; i < nodes.length; i++) {		
			var node = nodes [i];		
			if (node.title) continue;			
			node.title = node.label;		
		}
		
		win.d.aNodes = nodes;

		win.d._active = $options->{active};
		win.d._href = '$options->{href}';
		$selected_code
		var styleNode = win.document.createElement("STYLE");
    		styleNode.type = "text/css";
	        win.document.body.appendChild(styleNode);
    		win.document.styleSheets[0].addRule('td.vert-menu', "background-color: #454a7c;font-family: Tahoma, 'MS Sans Serif';font-weight: normal;font-size: 8pt;color: #ffffff;text-decoration: none;padding-top:4px;padding-bottom:4px;background-image: url($_REQUEST{__static_url}/menu_bg.gif);cursor: pointer;");

		win.document.body.innerHTML = "<table class=dtree width=100% height=100% celspacing=0 cellpadding=0 border=0><tr><td id='dtree_td' valign=top>" + win.d + "</td></tr></table><div id='dtree_menus'>$menus</div>";
@{[ $options->{selected_node} ? <<EOO : '' ]}		
		if (win.d.selectedNode == null || win.d.selectedFound) {
			win.d.openTo ($options->{selected_node}, true);
		}
EOO
EOH

	return qq {<frameset cols="$options->{width},*">
		<frame src="$ENV{SCRIPT_URI}/i/_skins/TurboMilk/0.html" name="_tree_iframe" id="__tree_iframe" application="yes">
		</frame>
		<frame src="${\($selected_node_url ? $selected_node_url : '$_REQUEST{__static_url}/0.html')}" name="_content_iframe" id="__content_iframe" application="yes" scroll=no>
		</frame>
	</frameset>};

}

################################################################################

sub draw_node {

	my ($_SKIN, $options, $i) = @_;
	
	$options -> {label} =~ s{\"}{\&quot;}gsm; #"

	my $node = {
		id   => $options -> {id}, 
		pid  => $options -> {parent}, 
		name => $options -> {label}, 
		url  => ($options -> {href_tail} ? '' : $ENV {SCRIPT_URI}) . $options -> {href},
		title   => $options -> {title} || $options -> {label},
	};
	
	map {$node -> {$_} = $options -> {$_} if $options -> {$_}} qw (target icon iconOpen is_checkbox);

	if ($options -> {title} && $options -> {title} ne $options -> {label}) {
		$node -> {title} = $options -> {title};
	}

	if ($i -> {cnt_children} > 0) {
		$node -> {_hc}  = 1;	
		$node -> {_hac} = 0 + $i -> {cnt_actual_children};	
		$node -> {_io}  = $i -> {id} == $_REQUEST {__parent} ? 1 : 0;
	}
	else {
		$node -> {_hc} = 0;	
	}
	
	$node -> {context_menu} = $i . '' if $i -> {__menu};

	return $node;

}

################################################################################

sub dialog_close {

	my ($_SKIN, $result) = @_;
	
	my $a = $_JSON -> encode ({
		result => $result,
		alert  => $_REQUEST {__redirect_alert},
	});
	
	$r -> content_type ("text/html; charset=$i18n->{_charset}");
	$r -> send_http_header ();
	$r -> print (<<EOH);
<html>
	<head>
		<script>
			
			function load () {
				var a = $a;
				if (a.alert) alert (a.alert);
				var w = window.parent.parent;		
				w.returnValue = a.result;
				w.close ();
			}
			
		</script>
	</head>
	<body onLoad="load ()"></body>
</html>
EOH

}

################################################################################

sub dialog_open {

	my ($_SKIN, $arg, $options) = @_;
		
	foreach (qw(status resizable help)) {$options -> {$_} ||= 'no'}
	
#	$options -> {dialogHeight} ||= '150px';
#	$options -> {dialogWidth}  ||= '600px';
	delete $options -> {dialogHeight};
	delete $options -> {dialogWidth};
	 
	
	my $url = $ENV{SCRIPT_URI} . '/i/_skins/TurboMilk/dialog.html?';
	my $o = join ';', map {"$_:$options->{$_}"} keys %$options;
	
	return "javaScript:dialog_open_$options->{id}.href = dialog_open_$options->{id}.href.replace(/\\#?\\&_salt=[\\d\\.]+\$/, ''); dialog_open_$options->{id}.href += '&_salt=' + Math.random (); var result=window.showModalDialog('$url' + Math.random (), dialog_open_$options->{id}, '$o' + ';dialogWidth=' + dialog_open_$options->{id}_width + 'px;dialogHeight=' + dialog_open_$options->{id}_height + 'px');document.body.style.cursor='default';void(0);";

}

################################################################################

sub draw_suggest_page {

	my ($_SKIN, $data) = @_;
			
	my $a = $_JSON -> encode ([map {[$_ -> {id}, $_ -> {label}, $_ -> {_confirm}]} @$data]);
	
	$size = 10 if $size > 10;
	
	return <<EOH;
<html>
	<head>
		<script>
			function r () {
				
				var q = {};
			
				var a = $a;
								
				var s = parent.document.getElementById ('_$_REQUEST{__suggest}__suggest');
				if (!s) {
					s = parent.document.getElementById ('$_REQUEST{__suggest}__suggest');
					var t = parent.document.getElementById ('$_REQUEST{__suggest}');
					try {parent.tableSlider.cell_off ()} catch (e) {}
					parent.\$(s).css ({
						top : 0,
						left : 0,
						width : t.offsetWidth,
						position : 'relative'
					});
				} else {
					var t = s.form.elements ['_$_REQUEST{__suggest}'];
					var o = parent.\$(t).offset (parent.\$(parent.document.body));
				
					parent.\$(s).css ({
						top   : o.top + 18,
						width : t.offsetWidth
					});
				}
				
				s.options.length = 0;
				for (var i = 0; i < a.length; i++) {
					var o = a [i];
					s.options [i] = new Option (o [1], o [0]);
					if (o [2]) q [o [0]] = o [2];
				}
				
				if (a.length > 0) {
					s.size = a.length > 1 ? a.length : 2;
					s.style.display = 'block';
					parent.suggest_is_visible = 1;
				}
				else {
					s.style.display = 'none';
					parent.suggest_is_visible = 0;
				}
				
				parent.questions_for_suggest ['_$_REQUEST{__suggest}__suggest'] = q;
				
			}
		</script>
	</head>
	<body onLoad="r()"></body>
</html>
EOH

}

################################################################################

sub draw_form_field_article {

	my ($_SKIN, $field, $data) = @_;

	$field -> {value} =~ s{\n}{<br>}gsm;
	
	return qq{<table width=95% align=center cellpadding=10><tr minheight=200><td>$field->{value}</td></tr></table>};
	
}

1;
