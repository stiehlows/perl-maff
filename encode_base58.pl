$code_string = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
@code = split('',$code_string);


sub divide {
	($to_div, $by) = (@_);
	$i = 1;
	while($by*$i < $to_div){
		$i++;
	}
	$i--;
	$remainder = $to_div - ($i*$by);
	return ($i, $remainder);


sub int_to_b52 {
	$x = shift;
	$res = '';
	while($x>0){
		($x, $remainder) = divide(x,58);
		$res .= $code[$remainder]
	}
	
	return reverse $res;
}



