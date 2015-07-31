mol load pdb ../../../../01prep/prot.pdb

set cutoff 3.0
set infile [open "hb_counts_res_D1lig-wat-D2_cut${cutoff}.xvg"]
set outfile [open "hb_counts_name_res_D1lig-wat-D2_cut${cutoff}.xvg" w]

while {[gets $infile line] > 0} {
  set donor_resid [lindex $line 0]
  set acceptor_resid [lindex $line 1]
  set counts [lindex $line 2]
  set percentage [lindex $line 3]
  
  set donor [atomselect top "resid $donor_resid"]
  set donor_resname [lsort -unique [$donor get resname]]
  
  set acceptor [atomselect top "resid $acceptor_resid"]
  set acceptor_resname [lsort -unique [$acceptor get resname]]
  
  set donor_string "$donor_resname $donor_resid"
  set acceptor_string "$acceptor_resname $acceptor_resid"
  
  puts $outfile [format "%-12s : %-12s : %8i%8.3f" $donor_string $acceptor_string $counts $percentage]
}

close $infile
close $outfile

exit
