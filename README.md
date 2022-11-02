# Root Photoactivation Analysis Workflow

*This combinaison of tools (toolset and Colab script) is aimed at automatically quantifying the diffusion of Dronpa from one activated cell to adjacent cells.*


## What was the user's request ?
The user has a set of two channels acquisitions+t images saved as lif files. Channel 1 is Dronpa signal, channel 2 is a cell wall labeling.
Images are stored as time series, one experiment being composed of two time series: FRAP XXX/SeriesYY as the pre-activation sequence, FRAP XX/FRAP Pb2 Series(YY+1) as the post-activation sequence.
The aim of this workflow is:
- For the toolset:
    1. Export individual sequences (pre and post-activation) as a unique tif-zipped composite file.
    2. As the acquisitions suffer from a slight drift, correct for it.
    3. Ask the user for the orientation of individual shots: as default, the tip root is supposed to be pointing at the left side of the image.
    4. Identify the activated cell.
    5. Identify and label bording cells (bording cell 1 being the closest from the activated cells, on the root tip side, bording cell 1' same on the opposite side, bording cell 2 begin the second closest on the root tip side etc...)
    6. Identify the furthest cell from the activated cell: to be used for background evaluation.
    7. Quantify the area and the total fluorescence on all the cells of interest.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/FRAP.jpg">
</p>
<p align=center>
	<em><b>Example image and detections</b></em>
</p>

- For the Colab script:
    1. Create an XLSX file containing one sheet per individual sequence
    2. For each sheet:
		- Copy the raw data
		- Correct the raw data for background (see eq. 1)
		- Normalize the data assuming the total fluorescence between the activated cell and bording cells is only exchanged. It is assumed the systems acts as a closed container: no material leaves or enters the system made of the activated cells and the bording cells. The total fluorescence over those cells of interest is therefore normalised to 1 (see eq. 2)
		- Plot a graph of normalized data vs time for all cells
		- Add to the sheet a snapshot of the cell, presenting the detected cells
    3. Create a summary sheet:
		- Present the normalized data, for all datasets, for all detected cell
		- For each cell, compute the average value, SD and effective
		- Plot the average values +/- SD for each cell, as a function of time
		
_**Eq. 1: Background subtraction**_
<p align=center>
	$Integrated\ density(Cell_{Background\ corrected})=Integrated\ density(Cell_{Raw})-\frac{Integrated\ density(Cell_{Background})}{Area(Cell_{Background})}*Area(Cell_{Raw})$
</p>

_**Eq. 2: Normalization**_
<p align=center>
	$Normalised\ fluorescence(Cell)=\frac{Integrated\ density(Cell_{Background\ corrected})}{\sum_{i} Integrated\ density(Cell_{i, Background\ corrected})}$
</p>

## How does it work ?
The toolset works in a sequential fashion: a first tool will take care of extracting the images and registering the time point, a second tool will ask the user for images' orientation, a third tool will segment cells and extract data while calling the Colab script.


### IJ Toolset
	
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/GUI.jpg">
</p>

#### Data structure for output
The toolset will output many data. In order to keep everything sorted, a specific folder/subfolders structure is adopted. The datastructure is generated as the user is activating the different tools. For each of the following folders, a subfolder is created per lif file and contains one file per sequence. This data structure is hosted in a user-defined root folder.
	
- _**dataToUpload.zip**_: Populated after step 3, contains all the csv files and detection check files. It is used by the Colab script to generate the XLSX files.
- _**csv**_: Populated after step 3, it contains one csv file per sequence. It includes the area an integrated density (total fluorescence) for each cell (activated, n x bording and background).
- _**Detection_Checks**_: Populated after step 3, it includes all jpg files of the sequence summed projection, with an overlay of the detected ROIs. It allows the user to check for proper detection of cells.
- _**params.txt**_: This file is populated as the toolset is used, after each step. It contains all information/parameters used for analysis and ensures passing parameters from one step to another, and documenting the full process. It ensures analysis reproducibility as it encloses all settings.
- _**Proj**_: Populated after step 1, it includes zip files of the sequences summed projections.
- _**Raw**_: Populated after step 1, it includes zip files of the raw sequences, after assembly from the lif file, before registration.
- _**Registered**_: Populated after step 1, it includes zip files of the registered sequences.
- _**Registered_Oriented_with_ROIs**_: Populated after step 3, it includes zip files of the registered sequences, after cells have been detected.	

#### Step 1: Lif to Zip
This first tool performs the following steps:

1. As the user presses the Step 1 button, a graphical user interface (GUI) pops-up asking for 3 parameters:
		- Where the lif files are: this apramete can be fed either by dragging and dropping the folder to the blank space or by using the "browse" button.
		- Where to save files: where to place the root folder for the output data structure.
		- Median filtering radius: the radius of the median filter applied to stack summed projection, used for cells detections.
		
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/GUI_Step1.png">
</p>			

2. Once the GUI has been Oked, all parameters are saved under output_folder/params.txt.
3. Individual images from the lif file for each part of the sequence (2 parts per sequence: one before activation, the other one after activation) are extracted.
4. An hyperstack is created from both parts of the sequence. This hyperstack is saved under output_folder/Raw/Lif_filename_without_extension/FRAP_XX.zip.
5. The hyperstack is registered using the built-in Fiji plugin ["Correct 3D drift"](https://imagej.net/plugins/correct-3d-drift), using channel 2 as a reference (cell walls), allowing multi time-scale correction, using a maximum XYZ shift of 10 pixels. The result is saved under output_folder/Registered/Lif_filename_without_extension/FRAP_XX.zip.
6. Previous result is projected using the "summed "option ans further processed using a median filter (user-entered radius). The resulting image is saved under output_folder/Proj/Lif_filename_without_extension/FRAP_XX.zip.
	
#### Step 2: Orient Roots
#### Step 3: Segment and quantify
	
### Colab script
	
	
#### Graphical user interface:

The user is provided with a Graphical User Interface (GUI) from where (s)he should select the images to work with, fill in the labelling tags (tags to be reused to name the different outputs) and parameters for pre-processing and analysis:



* *Size of detection square*: used to isolate each synaptosome.
* *Radius for spots filtering*: radius used to perform local filtering during the pre-processing step (gaussian blur and median filtering).
* *Noise tolerance for spots detection*: extend to which the intensity of a pixel should be above adjacent pixels' intensities to be considered as a local maximum.
* *Min size for spots*: during pre-processing, all input images are fused and filtered to end up with "blobs" from which synaptosomes are delineated. This parameter is the minimum blob area to be considered as a particle of interest.
* *Max size for spots*: same as above, dealing with the maximum size.
* *Size for the quantification circle square*: diameter of the circular ROI used to quantify the synaptosome-associated signal.
* *Pixel size in microns*: Size, in physical units, of a single pixel.

#### Pre-processing images:

1. In order to end up with similar segmentation procedure between all images of a set, images are first normalised. The procedure relies on centering then reduicing the images' intensity. This step is achieved by:
	1. Transtyping the images to 32-bits.
	2. Subtracting the image's average intensity to all pixels (centering step).
	3. Dividing the image by its intensities' standard deviation (reduicing step).
2. On all input images, structures of interest are detected, making the assomption they are close enough in all channels. If so, hen fusing all normalised images, one should end up having blob-like, to be detected as spot-like structures:
	1. All normalised images (all labels) are grouped into a single stack.
	2. A maximum intensity projection is performed.
	3. The projection is subjected to gaussian blurring (default radius: 3 pixels).
	4. The image is median filtered (default radius: 3 pixels).
	5. A search for local maxima is performed (default tolerance to noise: 3).
	6. For each retrieved maximum, the "magic wand" tool is activated on the spot, generating a ROI surrounding each "blob". In case the delineated are falls into the user-specified range (default: minim 5 pixels, maximum 100 pixels), a square ROI is centered over the picked point (default size: 64 pixels) and is added to the ROI Manager.
3. Both original images are activated and overlayed, generating a composite image.
4. On the composite image, all ROIs are activated in turn and the corresponding portion of the image is duplicated.
5. All duplicates are asembled into a stack and a montage ("Gallery") is generated.

#### Reviewing synaptosome-candidates:

1. The ROI Manager is emptied and new ROIs are generated. At first, those ROIs are green circles, on per thumbnail on the gallery.
2. The gallery is displayed to the user.
3. A user interaction is required to validate each detection: to change the status of one thumbnail (from validate to non-valide or the opposite way round), click on the thumbnail. The ROI should go from a green circle (valide) to a red crossed rectangle (non valide) or the opposite way round.
4. Once all candidates have been reviewed, press on the space bar to proceed to next step.

![GUI](images/Gallery.jpg)

#### Data extraction:

1. A circular region of interest is drawn over each validated structure candidate (default radius 32 pixels). The average intensity is extracted and logged for both channels to the results table.
2. The coordinates of the centroid for the ROI is also logged for each channel.
3. Having the two centroids' coordinates (one per channel), the distance between both is computed, calibrated (according to the provided calibration, default: 0.103 microns/pixel) and logged to the results table .
4. A donut-like ROI is then drawn, which width corresponds to each thumbnails' width, and excluding the circular ROI that has been quantified during step 1. This ROI is used to evaluate local background. This information is logged to the results table for both channels.
5. A table is saved containing all the intensity-based information, as comma-separated values. All values are rounded. This file format allows importing data to a flow cytometry software for further analysis (user's request). The first intend was to use the FCS format (see: [FCS file format by the International Society for Advancement in Cytometry](https://isac-net.org/page/Data-Standards)).
6. Three graphs are plotted:
	1. *Cytofluorogram of raw intensities*.
	2. *Cytofluorogram of background-corrected intensities*.
	3. *Distribution of distances*: the histogram is drawn by performing data grouping so that 128 bins are displayed. This graph is intended for initial experiment's evaluation, not for definitive conclusions to be drawn !!!

![GUI](images/Graphs.jpg)
	
7. A synthetic image is generated: from the coordinates stored in the results table, small hollow squares are drawn. Please take into consideration the results are decimals, whilst the coordinates on the image are non decimals: this image is therfore to be interpreted with great care, and used only as a rough quality control image of the detection method.

![GUI](images/Control.jpg)


**_Please see the Revisions section for additionnal informations about recently implemented features_**

## How to use it ?
### Macro ImageJ (versions 1 to 3):

1. Update ImageJ : Help/update puis Ok.
2. Drag and drop the macro file onto ImageJ's toolbar.
3. Open both images to analyze.
4. Navigate to Macro/Run Macro within the macro window.

### Toolset ImageJ (version 4 to 6):

1. Update ImageJ : Help/update puis Ok.
2. Copy/Paste the macro file to ImageJ's instalaltion folder, in macros/toolset.
3. Under the ImageJ toolbar, on the right-most side, click on the red double arrow and select the appropriate toolset (choose "Startup macro" to go back to tthe original status).
4. Default ImageJ tools have partly been replaced with your toolset's buttons.

### Toolset ImageJ (version >=7):
The toolset embarks randomization capability that require a plugin.
In addition to the previous procedure, you will need to install [RandomizerColocalization](https://github.com/flevet/RandomizerColocalization).
The sources are available from [here](https://github.com/flevet/RandomizerColocalization). A compiled version is available from [here](https://github.com/fabricecordelieres/IJ-Toolset_SynaptosomesMacro/tree/master/Plugins#:~:text=RandomizerColocalization_.class)
1. Download [RandomizerColocalization_.class](https://github.com/fabricecordelieres/IJ-Toolset_SynaptosomesMacro/raw/master/Plugins/RandomizerColocalization_.class).
2. Drag-and-drop the .class file to your ImageJ/Fiji toolbar.
3. In the File saver window, press Ok.
4. Restart Fiji/ImageJ.

## Revisions:
### Version 1: 22/10/28 
