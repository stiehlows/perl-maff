
$sgdfgdf = "

 647383877 : 45 = 1
 45
 --
 197
 ";


sub fast_div {
	(my $a, my $b, my $ctx) = (@_);

	$a =~ s/ //g;
	$b =~ s/ //g;

	$res = '';

	while(a_ge($a,$b,$ctx)){
		my $l_p = substr $a, 0, length($b);
		my $r_p = substr $a, length($b);


		#muessen neue zahl dazuholen
		if(a_greater($b,$l_p,$ctx)){
			$l_p = substr $a, 0, length($b)+1;
		}
		
		my $i = 0;
		my $merk = 0;

		while(1){	

			$merk = add($merk,$b,$ctx);


			#eins drüber 
			if(a_greater($merk, $l_p, $ctx)){
				$merk = mul($i, $b, $ctx);
				goto end_this_part;
			}

			$i = add($i,1,$ctx);
		};
		end_this_part:

		if(!a_greater($i,0,$ctx)){
			print("we retrN?\n");
			return (0,$l_p);
		}
		else{
			$res = "$res".$i;
		}
		
		my $rest = subb($l_p,$merk,$ctx);
		#print "$rest = $l_p-$merk\n";
		print "r $rest\n";
		if(a_greater($rest,0,$ctx)){
			$a = "$rest" . "$r_p";
		}
		else{
			$a = $r_p;
		}
	}

	return $res;
}

1;
