use JSON::PP;

#################################################################################

sub setup_json {

	our $_JSON = JSON::PP -> new -> latin1 (1) -> allow_nonref (1);

}

1;