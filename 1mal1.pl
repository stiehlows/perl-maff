
$decimal_c = "0123456789";
$hex_c = "0123456789ABCDEF";
sub to_base10 {
	(my $src_c,  my $val) = (@_);

	my $s_b = length($src_c);

	#break down to decimal
	my @v = split('',$val);
	my $dec = 0;
	my $pow = 0;
	while(scalar @v){
		$dec += ($s_b**$pow)*index($src_c,pop(@v));
		$pow++;
	}

	return $dec;
}

sub from_base10 {

	(my $tgt_c, my $dec) = (@_);
	my $t_b = length($tgt_c);	
	my @d = split('',$dec);
	my $val = '';
	while($dec > $t_b){
		$val .= substr $tgt_c, $dec % $t_b,1;

	$dec = int($dec/ $t_b);
	}
	$val.=substr $tgt_c, $dec, 1;	


	return reverse $val;
}


sub create_mul_table {
	my $c = shift;
	my $base = length($c);
	my %results = ();
	for(my $i=0; $i<$base;$i++){
	for(my $j=0; $j<$base;$j++){
		my $mul = substr $c, $i, 1;
		$mul .= substr $c, $j, 1;
		$results{$mul} = from_base10($c,($i*$j));
	}
	}
	return %results;
}

my %mul_dec = create_mul_table($decimal_c);
my %mul_hex = create_mul_table($hex_c);

sub get_ctx_mul_table{
	$ctx = shift;
	if($ctx eq $hex_c){
		return %mul_hex;
	}
	if($ctx eq $decimal_c){
		return %mul_dec;
	}
}
1;
