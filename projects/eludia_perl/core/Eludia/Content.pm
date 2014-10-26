no warnings;

use Eludia::Content::Auth;
use Eludia::Content::ModuleTools;
use Eludia::Content::Mbox;
use Eludia::Content::Handler;
use Eludia::Content::HTTP;
use Eludia::Content::Validators;
use Eludia::Content::Templates;
use Eludia::Content::Tie;

#############################################################################

sub darn ($) {warn Dumper ($_[0]); return $_[0]}

#############################################################################

sub ids {

	my ($ar, $options) = @_;
	
	$options -> {field} ||= 'id';
	$options -> {empty} ||= '-1';
	$options -> {idx}   ||= {};
	
	my $ids = $options -> {empty};
	my $idx = $options -> {idx};
	
	foreach my $i (@$ar) {

		my $id = $i -> {$options -> {field}};
		
		if (ref $idx eq HASH && $id) {
			$idx -> {$id} = $i;
		}
		elsif (ref $idx eq ARRAY && $id > 0) {
			$idx -> [$id] = $i;
		}
		
		$id > 0 or next;
		$ids .= ',';
		$ids .= $id;

	}
	
	return wantarray ? ($ids, $idx) : $ids;

}

################################################################################

sub add_totals {

	my ($ar, $options) = @_;

	my @ar = ({_root => -1}, @$ar, {_root => 1});	
	
	$options -> {no_sum} .= ',id,label';
	$options -> {no_sum} = { map {$_ => 1} split /\,/, $options -> {no_sum}};
	
	unless ($options -> {fields}) {

		my $field = {name => '_root'};

		if (defined $options -> {position} && $options -> {position} == 0) {
			$field -> {top} = 1;
		}
		else {
			$field -> {bottom} = 1;
		}

		$options -> {fields} = [$field];

	}	
	
	my @totals_top    = ();
	my @totals_bottom = ();
	
	foreach my $field (@{$options -> {fields}}) {
		$field -> {top} or $field -> {bottom} ||= 1;
		push @totals_top,    {};
		push @totals_bottom, {};
		$options -> {no_sum} -> {$field -> {name}} = 1;
	};
	
	my @result = ();
	
	my $is_topped = 0;
	
	my $inserted = 0;
	
	for (my $i = 1; $i < @ar; $i++) {
	
		my $prev = $ar [$i - 1];
		my $curr = $ar [$i];
		
		my $first_change = -1;
		
		for (my $j = 0; $j < @{$options -> {fields}}; $j++) {
			my $name = $options -> {fields} -> [$j] -> {name};
			next if $prev -> {$name} eq $curr -> {$name};
			$first_change = $j;
			last;
		}

		if ($first_change > -1) {
						
			for (my $j = @{$options -> {fields}} - 1; $j >= $first_change; $j--) {

				my $field = $options -> {fields} -> [$j];

				$field -> {bottom} or next;

				if ($curr -> {_root} || !$prev -> {_root}) {

					$totals_bottom [$j] -> {is_total} = 1 + $j;
					$totals_bottom [$j] -> {def}      = $field;
					$totals_bottom [$j] -> {data}     = $prev;
					$totals_bottom [$j] -> {label}    = '�����';

					push @result, $totals_bottom [$j];
					
					$inserted ++;

				}

				$totals_bottom [$j] = {};

			}

			for (my $j = $first_change; $j < @{$options -> {fields}}; $j++) {

				my $field = $options -> {fields} -> [$j];

				$field -> {top} or next;

				$totals_top [$j] = {
					is_total => -(1 + $j),
					def      => $field,
					data     => $curr,
					label    => '�����',
				};

				if ($prev -> {_root} || !$curr -> {_root}) {

					push @result, $totals_top [$j];

					$inserted ++;

					$is_topped = 1;

				}

			}
									
		}

		foreach my $key (keys %$curr) {
			next if $options -> {no_sum} -> {$key};
			my $value = $curr -> {$key};
			next if $value !~ /^[\-\+]?\d+(\.\d+)?/;
			next if $value == 0;
			next if $value =~ /^\d\d\d\d\-\d\d\-\d\d/;
			foreach my $sum (@totals_bottom) { $sum -> {$key} += $value}
			next unless $is_topped;
			foreach my $sum (@totals_top)    { $sum -> {$key} += $value}
		}

		push @result, $curr;

	}

	@$ar = grep {!$_ -> {_root}} @result;
	
	return $inserted;
	
}

################################################################################

sub __log_profilinig {

	my $now = time ();
	
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime ($now);
	$year += 1900;
	$mon ++; 

	printf STDERR "[%04d-%02d-%02d %02d:%02d:%02d:%03d $$] %7.2f ms %s\n", 
		$year,
		$mon,
		$mday,
		$hour,
		$min,
		$sec,
		int (1000 * ($now - int $now)),
		1000 * ($now - $_[0]), 
		$_[1] 
		
		if $preconf -> {core_debug_profiling} > 0;
	
	return $now;

}

################################################################################

sub dt_y_m_d {

	$_[0] =~ /^(\d+)\D(\d+)\D(\d+)/ or return ();
		
	return $1 > 1900 ? ($1, $2, $3) : ($3, $2, $1);

}

################################################################################

sub dt_iso {

	my @ymd = map {split /\D+/} @_;
	
	@ymd = reverse @ymd if $ymd [0] < 1000;
		
	return sprintf ('%04d-%02d-%02d', @ymd);

}

################################################################################

sub dt_dmy {

	my @dmy = map {split /\D+/} @_;
	
	@dmy = reverse @dmy if $dmy [2] < 1000;
	
	my $c = substr $i18n -> {_format_d}, 2, 1; 
	
	$c ||= '.';
	
	return sprintf ("\%02d${c}\%02d${c}\%02d", @dmy);

}

################################################################################

sub dt_add {

	my ($dt, $delta) = @_;
	
	my $was_iso = $dt =~ /^\d\d\d\d\-\d\d\-\d\d/;
	
	my $was_hms = $dt =~ /(\d+):(\d+):(\d+)$/;
	
	my @hms = $was_hms ? ($1, $2, $3) : ();

	my @delta = split /\s+/, $delta;
	
	my $what = 'Days';
	
	@delta [-1] =~ /^[A-Za-z]/ and $what = pop @delta;
	
	my $want_24 = ($what =~ s{24}{});
	
	if ($what =~ /^H/i) {
		
		$what = 'DHMS'; 	@delta = (0, @delta [0], 0, 0);
	
	}
	elsif ($what =~ /^M/i) {
		
		$what = 'DHMS';		@delta = (0, 0, @delta [0], 0);
	
	}
	elsif ($what =~ /^S/i) {
		
		$what = 'DHMS';		@delta = (0, 0, 0, @delta [0]);
	
	}
	
	require Date::Calc;
	
	my @ymd = dt_y_m_d ($dt);

	my $want_hms = $what =~ /HMS$/;
	
	if ($want_hms) { 
		
		@hms > 0 or @hms = (0, 0, 0);
		
		if ($hms [0] == 24) {
		
			$hms [0] = 0;
			
			@ymd = Date::Calc::Add_Delta_Days (@ymd, 1);
		
		}
	
	} else {	
		
		@hms = ();
	
	}

	my @dt = &{"Date::Calc::Add_Delta_$what"} (@ymd, @hms, @delta);

	return @dt if wantarray;
	
	if ($want_hms && $want_24 && $dt [3] == 0) {
	
		@dt [0 .. 2] = Date::Calc::Add_Delta_Days (@dt [0 .. 2], -1);
		
		$dt [3] = 24;

	}

	my $dt = $was_iso ? dt_iso (@dt [0 .. 2]) : dt_dmy (@dt [0 .. 2]);

	$dt .= sprintf (' %02d:%02d:%02d', @dt [3 .. 5]) if $want_hms;

	return $dt;

}

################################################################################

sub get_ids {

	my ($name) = @_;
	
	$name .= '_';
	
	my @ids = ();
	
	while (my ($key, $value) = each %_REQUEST) {
		$key =~ /$name(\d+)/ or next;
		push @ids, $1;
	}
	
	return @ids;	

}

################################################################################

sub prev_next_n {

	my ($what, $where, $options) = @_;
	
	$options -> {field} ||= 'id';
	
	my $id = $what -> {$options -> {field}};

	my ($prev, $next) = ();
	
	for (my $i = 0; $i < @$where; $i++) {

		$where -> [$i] -> {$options -> {field}} == $id or next;
		
		$prev = $where -> [$i - 1] if $i;
		$next = $where -> [$i + 1];
		
		return ($prev, $next, $i);
	
	}
	
	return ();

}

################################################################################

sub tree_sort {

	my ($list, $options) = @_;
	
	my $id        = $options -> {id}        || 'id';
	my $parent    = $options -> {parent}    || 'parent';
	my $ord_local = $options -> {ord_local} || 'ord_local';
	my $ord       = $options -> {ord}       || 'ord';
	my $level     = $options -> {level}     || 'level';

	my $idx = {};
	
	my $len = length ('' . (0 + @$list));
		
	my $template = '%0' . $len . 'd';
	
	for (my $i = 0; $i < @$list; $i++) {
	
		$list -> [$i] -> {$ord_local} = sprintf ($template, $i);
		
		$idx -> {$list -> [$i] -> {$id}} = $list -> [$i];
	
	}

	foreach my $i (@$list) {
	
		my @parents_without_ord = ();
	
		$i -> {$ord}   = '';
		$i -> {$level} = 0;
	
		my $j = $i;
		
		while ($j) {
		
		 	if ($j -> {$ord}) {			
				$i -> {$ord}    = $j -> {$ord} . $i -> {$ord};
				$i -> {$level} += $j -> {$level};				
				last;			
			}
		
			$i -> {$ord} = $j -> {$ord_local} . $i -> {$ord};
			
			$i -> {$level} ++;
			
			$parents_without_ord [$level] = $j;
			
			$j = $idx -> {$j -> {$parent}};
		
		}
		
		for (my $level = 1; $level < @parents_without_ord; $level ++) {
		
			$parents_without_ord [$level] -> {$ord} = substr $i -> {$ord}, 0, $len * ($i -> {$level} - $level);
		
		}
	
	}
	
	return [sort {$a -> {$ord} cmp $b -> {$ord}} @$list];

}

################################################################################

sub merge_cells {

	my $options = shift;
	
	my @result;

	my $last_dump;

	foreach my $cell (@_) {
	
		my $dump = Dumper ($cell);

		if ($last_dump eq $dump) {
		
			$result [-1] -> {colspan} ||= 1;
			
			$result [-1] -> {colspan} ++;
		
		}
		else {
		
			push @result, Storable::dclone $cell;
		
			$last_dump = $dump;

		}	
	
	}
	
	return @result;

}

################################################################################

sub defaults {

	my ($data, $context, %vars) = @_;
		
	my $names = "''";

	foreach my $key (keys %vars) {
	
		ref $vars {$key} or $vars {$key} = {};
		
		$vars {$key} -> {name} ||= $key;
		
		$names .= ",'$vars{$key}->{name}'";
	
	}
		
	my %def = ();
	
	sql_select_loop ("SELECT * FROM $conf->{systables}->{__defaults} WHERE fake = 0 AND context = ? AND name IN ($names)", sub {$def {$i -> {name}} = $i -> {value}}, $context);
	
	if ($data -> {fake} == $_REQUEST {sid}) {
	
		foreach my $key (keys %$data) {
		
			$data -> {$key} or delete $data -> {$key};
		
		}
	
	}
	
	foreach my $key (keys %vars) {
	
		my $name = $vars {$key} -> {name};
	
		if (exists $data -> {$key}) {
		
			if ($data -> {$key} ne $def {$name}) {
			
				sql_select_id ($conf -> {systables} -> {__defaults} => {

					fake    => 0,
					context => $context,
					name    => $name,
					-value  => $data -> {$key},

				}, ['context', 'name']);
			
			}
		
		}
		else {
		
			$data -> {$key} = $def {$name};
		
		}
		
		check_query () if $key eq 'id___query';
	
	}

}

################################################################################

sub user_agent {

	my $src = $r -> headers_in -> {'User-Agent'};
	
	my $result = {};
	
	if ($src =~ /MSIE (\d+\.\d+)/) {
	
		$result -> {msie} = $1;
	
	}

	if ($src =~ /Windows NT (\d+\.\d+)/) {
	
		$result -> {nt} = $1;
	
	}

	return $result;

}

1;