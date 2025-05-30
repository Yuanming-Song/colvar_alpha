# Template_colvar Directory

This directory contains template files for calculating alpha scores of peptides using VMD's Colvars module.
For detailed documentation on the alpha score collective variable in Colvars, refer to the [Colvars Reference Manual](https://colvars.github.io/master/colvars-refman-vmd.html#sec:cvc_alpha).

## Files
- `template_colvar.tcl`: Tcl script for running the analysis
- `template_colvar.inp`: Colvars configuration file

## Usage

1. Edit the input variables in `template_colvar.tcl`:
   ```tcl
   set psf_file "path/to/your/structure.psf"  # Your PSF file
   set traj_dir "path/to/your/trajectories/"  # Directory with DCD files
   set output_file "colvar_output.dat"        # Output file name
   set colvar_config "colvar.inp"             # Colvars config file
   ```

2. Edit `template_colvar.inp` to match your system:
   - Update `psfSegID` to match your peptide's segment name
   - Adjust `residueRange` to include the residues you want to analyze
   - Modify boundaries if needed (default: 0.0 to 1.0)

3. Run the analysis:
   ```bash
   vmd -e template_colvar.tcl
   ```

## Output
The script generates a data file with three columns:
- Frame number
- DCD filename
- Alpha score value

## Notes
- The alpha score is calculated using VMD's Colvars module
- Values are clamped between 0.0 and 1.0 for histogram purposes
- Make sure your PSF file has the correct segment names and residue numbering 