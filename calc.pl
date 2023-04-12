$G = "04 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798 483ADA77 26A3C465 5DA4FBFC 0E1108A8 FD17B448 A6855419 9C47D08F FB10D4B8"	;




$H_s = "02 79BE667E F9DCBBAC 55A06295 CE870B07 029BFCDB 2DCE28D9 59F2815B 16F81798";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$n = "FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFE BAAEDCE6 AF48A03B BFD25E8C D0364141";	

#systems
$decimal_c = "0123456789";
$hex_c = "0123456789ABCDEF";


require "./1mal1.pl";

#MAtemA staRts here

sub subtr {
	(my $a, my $b, my $ctx) = (@_);

	#a + b = c
	#a = c - b
	#a - b = c
	#a = c + b
	#a = b + ?
	my $res = 0;	
	my $i = 0;
	while(a_greater($a,add($b,$res,$ctx),$ctx)){
		$res = add($res,1,$ctx);
		$i++;
	}

	$res =~ s/^0+/0/g;
	return $res;
}

sub subb {
	(my $a, my $b, my $ctx) = (@_);

	$a =~ tr/ //ds;
	$b =~ tr/ //ds;

	if(!a_greater($a,$b,$ctx)){
		print "$a\n-$b\CANT SUBSTRACT NEGATIVE \n";
		return 0;
	}


	my @a = split('', $a);
	my @b = split('', $b); 
	my $ctx_mod = length($ctx);
	my $len = scalar @a;
	if(scalar @a < scalar @b){
		$len = scalar @b;
	}
	my @c = ();
	my @result = ();
	for(my $i=0; $i<$len; $i++){
		my $a_ = pop(@a);
		my $b_ = pop(@b);
		my $c_ = pop(@c);
		my $a_idx = index($ctx,$a_);
		my $b_idx = index($ctx,$b_);
		my $c_idx = index($ctx,$c_);
		my $res = $a_idx-$b_idx-$c_idx;
		my $digit_res = $res;

		if($res < 0){
			$digit_res = (-$res % $ctx_mod);
			$carry = int(-$res / $ctx_mod);
			push(@c, reverse split('',$carry));

		}

		else{
			push(@c, 0);
		}

		push(@result,(substr $ctx,$digit_res,1));
	}
	


	for my $c_ (@c){
		push(@result, (substr $ctx, $c_,1));
	}
	my $final_res = join('', reverse @result);
	$final_res =~ s/^0+//g;
	return $final_res;
};




sub add {
	(my $a, my $b, my $ctx) = (@_);

	$a =~ tr/ //ds;
	$b =~ tr/ //ds;
	my @a = split('', $a);
	my @b = split('', $b); 
	my $ctx_mod = length($ctx);
	my $len = scalar @a;
	if(scalar @a < scalar @b){
		$len = scalar @b;
	}
	my @c = ();
	my @result = ();
	for(my $i=0; $i<$len; $i++){
		my $a_ = pop(@a);
		my $b_ = pop(@b);
		my $c_ = pop(@c);
		my $a_idx = index($ctx,$a_);
		my $b_idx = index($ctx,$b_);
		my $c_idx = index($ctx,$c_);
		my $res = $a_idx+$b_idx+$c_idx;
		my $digit_res = $res;

		if($res >= $ctx_mod){
			$digit_res = ($res % $ctx_mod);
			$carry = int($res / $ctx_mod);
			push(@c, reverse split('',$carry));

		}

		else{
			push(@c, 0);
		}

		push(@result,(substr $ctx,$digit_res,1));
	}
	


	for my $c_ (@c){
		push(@result, (substr $ctx, $c_,1));
	}
	my $final_res = join('', reverse @result);
	$final_res =~ s/^0+//g;
	return $final_res;
};

sub mod_ctx {
	(my $n, my $ctx, my $digits) = (@_);
	my $ret = '';
	for(my $i=0;$i<$digits;$i++){
		my @n = split('', $n);
		$n = pop(@n);
		if(index($n,$ctx)!=-1){
			$ret = $n . $ret;
		}
	}
	return $ret;
}


sub mul {
	(my $a, my $b, my $ctx) = (@_);
	$a =~ s/ //g;
	$b =~ s/ //g;
	my @l = split('',$a);
	my @r = split('',$b);

	my %multi_table = get_ctx_mul_table($ctx);
	#so man nimmt die linke zahl von r, und
	#multipliziert von rechts her ie linke seite
	my @multi_rows = ();
	while(scalar @r){

		my $score = '';
		for(my $z=1;$z<scalar @r;$z++){
		$score=$score."0";
		}
		my $rz = shift(@r);
		my @tmpL = @l;
		my $carry = '';
		while(scalar @tmpL){
			my $lz = pop(@tmpL);
			my $to_mul = "$lz$rz";
			my $res = add($multi_table{$to_mul},$carry,$ctx);
			my $zz = substr $res, -1;
			if(length($res)==1){
				$carry = '';
			}
			else{
				if($ctx == $hex_c){

					$carry = substr $res, 0,1;
				}
			}
			$score = $zz . $score;
		}
		#eine rechte zahl fertig
		push(@multi_rows, ($score));
	}

	my $end_score = 0;
	while(scalar @multi_rows > 0){
		my $row = pop(@multi_rows);
		$end_score = add($end_score,$row,$ctx);
	}

	return $end_score;
}


sub div {
	(my $x, my $y, my $ctx) = (@_);

	my $space = 0;
	my $sum = $y;
	while(a_ge($x,$sum,$ctx)){
		$sum = add($sum,$y,$ctx);
		$space = add($space,1,$ctx);
	}
	$sum = subtr($sum,$y,$ctx);
	my $mod = subtr($x,$sum,$ctx);

print "\ns $x $y\n";
print "\ns $space m $mod\n";
	return ($space,$mod);
}
		

sub a_ge {
	(my $x, my $y, my $ctx) = (@_);
	if(a_greater($x,$y,$ctx) || ''.$x eq ''.$y){
		return 1;
	}
	return 0;
}

sub a_greater {
	(my $x, my $y, my $ctx) = (@_);
	if(length($x)>length($y)){
		return 1;
	}
	if(length($x)<length($y)){
		return 0;
	}
	my @x = split('',$x);
	my @y = split('',$y);

	for(my $i=0; $i<scalar @x; $i++){
		$x[$i] = ctx_v($x[$i],$ctx);
		$y[$i] = ctx_v($y[$i],$ctx);
		if($x[$i] > $y[$i]){
			return 1;
		}
		if($x[$i] < $y[$i]){
			return 0;
		}
	}
	return 0;
}

sub b_greater {
	(my $x, my $y, my $ctx) = (@_);
	return a_greater($y, $x, $ctx);
}

sub ctx_v {
	(my $x, my $ctx) = (@_);
	return index($ctx,$x);
}

sub modulo {
	(my $z, my  $mod, my $ctx) = (@_);
	(my $xd, my $res) = div($z, $mod, $ctx);
	return $res;
}

1;
