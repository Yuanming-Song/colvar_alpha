# -------------------------------------------------------------------------
# Template script for calculating alpha score of peptides using VMD
# This script:
# 1. Loads a PSF file
# 2. Processes all DCD files from a specified directory
# 3. Runs Colvars analysis on each DCD file to calculate alpha score
# 4. Outputs results to a data file, printing frame number, DCD filename, and alpha score
# -------------------------------------------------------------------------

# Define input parameters
set psf_file "path/to/your/structure.psf"  # Path to your PSF file
set traj_dir "path/to/your/trajectories/"  # Directory containing DCD files
set output_file "colvar_output.dat"        # Output file name
set colvar_config "colvar.inp"             # Colvars configuration file

# Open output file and write header
set outfile [open $output_file "w"]
puts $outfile "frame dcd_file colvar_val"

# Load the structure
puts "Loading structure from $psf_file"
mol new $psf_file

# Get list of DCD files
if {[catch {set dcd_files [glob -directory $traj_dir *.dcd]} err]} {
    puts "Error: Could not read directory $traj_dir"
    puts "Error message: $err"
    exit
}

# Process each DCD file
foreach dcd $dcd_files {
    # Get just the basename of the DCD file
    set dcd_name [file tail $dcd]
    puts "Processing trajectory: $dcd_name"
    
    # Delete any existing animations
    animate delete all
    
    # Reset Colvars module if it exists
    if {[info exists cv]} {
        cv delete
    }
    
    # Load the DCD file
    if {[catch {animate read dcd $dcd waitfor all} err]} {
        puts "Warning: Could not load DCD file $dcd_name - skipping"
        continue
    }
    
    # Activate Colvars on the top molecule
    cv molid top
    
    # Load the Colvars configuration
    if {[catch {cv configfile $colvar_config} err]} {
        puts "Warning: Could not load Colvars configuration - skipping"
        continue
    }
    
    # Get the name of the first colvar
    set colvar_name [lindex [cv list] 0]
    
    # Get number of frames
    set num_frames [molinfo top get numframes]
    
    # Process each frame
    for {set frame 0} {$frame < $num_frames} {incr frame} {
        if {[catch {
            cv frame $frame
            cv update
            # Get the colvar value
            set colvar_val [cv colvar $colvar_name value]
            # Write to output file with DCD filename
            puts $outfile [format "%8d %s %20.12e" $frame $dcd_name $colvar_val]
        } err]} {
            puts "Warning: Error processing frame $frame - skipping"
            continue
        }
    }
    
    # Clean up Colvars module
    cv delete
}

# Close output file
close $outfile
puts "Analysis complete. Results written to $output_file" 