package require bigdcd

# get resid of hydrogen donor or acceptor from output from vmd measure hbonds
proc get_resid {hbonds_vmd} {
  set indices_donors [lindex $hbonds_vmd 0]
  set indices_acceptors [lindex $hbonds_vmd 1]
  set num_hbonds [llength $indices_donors]
  set hb_resids []
  foreach indx_donor $indices_donors indx_acceptor $indices_acceptors {
    set donor [atomselect top "index $indx_donor"]
    set resid_donor [lsort -unique [$donor get resid]]
    set acceptor [atomselect top "index $indx_acceptor"]
    set resid_acceptor [lsort -unique [$acceptor get resid]]
    set hb_resid [list $resid_donor $resid_acceptor]
    lappend hb_resids $hb_resid
  }

  set res [list $num_hbonds $hb_resids]
}

proc calc_hbonds {frame} {
  global outfile cutoff_dist cutoff_angle
  global D1seltxt D2seltxt watseltxt
  
  set sel_D1 [atomselect top $D1seltxt]
  set sel_D2 [atomselect top $D2seltxt]
  set sel_wat [atomselect top $watseltxt]

  set hbonds_vmd1 [measure hbonds $cutoff_dist $cutoff_angle $sel_wat $sel_D1]
  set hbonds_vmd2 [measure hbonds $cutoff_dist $cutoff_angle $sel_D1 $sel_wat]
  set hbonds_vmd3 [measure hbonds $cutoff_dist $cutoff_angle $sel_wat $sel_D2]
  set hbonds_vmd4 [measure hbonds $cutoff_dist $cutoff_angle $sel_D2 $sel_wat]
  set hbonds_vmd_lst [list $hbonds_vmd1 $hbonds_vmd2 $hbonds_vmd3 $hbonds_vmd4]

  set hb_resids_one_frame []
  set total_num_hbonds 0
  
  foreach hbonds_vmd $hbonds_vmd_lst {
    set res [get_resid $hbonds_vmd]
    set num_hbonds [lindex $res 0]
    set hb_resids [lindex $res 1]
    set total_num_hbonds [expr {$total_num_hbonds+$num_hbonds}]
    foreach i $hb_resids {
      lappend hb_resids_one_frame $i
    }
  }

  puts $outfile "$frame $total_num_hbonds $hb_resids_one_frame"
}

set D1seltxt "resid 1 to 138 247 to 281 290"
set D2seltxt "resid 143 to 243"
set watseltxt "water"

set cutoff_dist 3.0
set cutoff_angle 20

set outfile [open hbonds_res-D1lig-wat-D2_cut${cutoff_dist}.xvg w]
mol load parm7 ../../../../01prep/system.parm
bigdcd calc_hbonds ../files/frames_all.dcd
bigdcd_wait
close $outfile

exit
