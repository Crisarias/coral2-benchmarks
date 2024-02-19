#
# Simple awk script to compute figure of merit from QMCPACK standard output for CORAL2
#
# Examples:
#
# awk -f compute_fom.awk std_output_from_qmcpack
#
# awk -f compute_fom.awk -v prodsteps=640 std_output_from_qmcpack # Set production steps for FOM computation
#
# awk -f compute_fom.awk titan_baseline/run_18000/bench.out_18000
#  ^^^ When run on titan baseline, gives FOM=5.0; which would require an 90000 node machine, assuming perfect scaling
#      from 18000 to 90000 nodes and otherwise equally powerful nodes
#

BEGIN {
    equilibration_steps=250.0; # No of steps to discard/discount. Do not edit.
    samples_required=819200000 # No of samples after equilibration required. Do not edit
    samples_ref=163840000 # No of samples after equilibration for titan ref. Do not edit
    time_required_ref=19.65*(equilibration_steps+(samples_ref/(18000*14))); # Reference time for smaller baseline run. Do not edit.
    weak_scaling_factor=samples_required/samples_ref; # Proportion of additional work

    production_steps=650; # No of production steps. Set to imply n
    if (prodsteps>0) production_steps=prodsteps;
}

/Casula/ {
    nr_casula=NR; # The DMC output section prints the word Casula early in its output.
}
/QMC Execution time/ { if ( NR > nr_casula ) exec_time=$5; }
/target walkers/ { if ( NR > nr_casula ) total_walkers=$4; }
/Steps per block/ { if ( NR > nr_casula ) steps=$5; }
/Number of blocks/ { if ( NR > nr_casula ) blocks=$5; }
END {
#    print exec_time;
#    print total_walkers;
#    print steps;
#    print blocks;
    time_per_step=exec_time/(steps*blocks);
    print "Time per step : ",time_per_step,"seconds for all ",total_walkers," walkers";

    samples_obtained=production_steps*total_walkers;
    time_required=(production_steps+equilibration_steps)*time_per_step;

    print "Time required : ",time_required,"seconds for ",equilibration_steps,"equilibration and", production_steps," production steps"
    print "Samples that would be obtained by this run : ",samples_obtained;
	
    sample_ratio=samples_required/samples_obtained;

    print "For FOM, would require",sample_ratio," as many samples by scaling to ",sample_ratio,"x more nodes beyond this job";
    fom=weak_scaling_factor*time_required_ref/time_required;
    print "FOM = ",fom, " assuming perfect scaling beyond this run";
}
