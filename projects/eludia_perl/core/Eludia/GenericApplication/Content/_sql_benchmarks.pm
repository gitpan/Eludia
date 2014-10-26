################################################################################

sub select__sql_benchmarks {

	my $q = '%' . $_REQUEST {q} . '%';

	my $start = $_REQUEST {start} + 0;
	
	my $order = order ('mean DESC',
		ms            => 'ms  DESC',
		cnt           => 'cnt DESC',
		selected      => 'selected  DESC',
		mean_selected => 'mean_selected DESC',
		label         => 'label',
	);

	my ($_benchmarks, $cnt)= sql_select_all_cnt (<<EOS, $q);
		SELECT
			*
		FROM
			$conf->{systables}->{__sql_benchmarks}
		WHERE
			(label LIKE ?)
		ORDER BY
			$order
		LIMIT
			$start, $$conf{portion}
EOS

	return {
		_benchmarks => $_benchmarks,
		cnt => $cnt,
		portion => $$conf{portion},
	};
	
}

1;