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
	- _**Where the lif files are**_: this parameter can be fed either by dragging and dropping the folder to the blank space or by using the "browse" button.
	- _**Where to save files**_: where to place the root folder for the output data structure.
	- _**Median filtering radius**_: the radius of the median filter applied to stack summed projection, used for cells detections.
		
<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/GUI_Step1.png">
</p>			

2. Once the GUI has been Oked, all parameters are saved under output_folder/params.txt.
3. Individual images from the lif file for each part of the sequence (2 parts per sequence: one before activation, the other one after activation) are extracted.
4. An hyperstack is created from both parts of the sequence. This hyperstack is saved under output_folder/Raw/Lif_filename_without_extension/FRAP_XX.zip.
5. The hyperstack is registered using the built-in Fiji plugin ["Correct 3D drift"](https://imagej.net/plugins/correct-3d-drift), using channel 2 as a reference (cell walls), allowing multi time-scale correction, using a maximum XYZ shift of 10 pixels. The result is saved under output_folder/Registered/Lif_filename_without_extension/FRAP_XX.zip.
6. Previous result is projected using the "summed "option ans further processed using a median filter (user-entered radius). The resulting image is saved under output_folder/Proj/Lif_filename_without_extension/FRAP_XX.zip.
	
#### Step 2: Orient Roots
This second tool allows the user to check and correct root tip's orientation as follows:

1. As the user presses the Step 2 button, a GUI pops-up asking only one parameters: where the params.txt file is. This parameter can be fed either by dragging and dropping the folder to the blank space or by using the "browse" button. NB: in case Step 2 is pressed after Step 1 has been pressed, the field is already filled with the proper link.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/GUI_Step2.png">
</p>			

2. Once the GUI has been Oked, a first montage is displayed where green arrows are pointing to the left. In case one root tip is on the opposite direction, simply click on the relevent thumbnail: the arrow should revert and become red. NB: instructions can be found in Fiji's status bar. NB2: it may take time for the macro to take into account the request to revert orientation: click again ! The "clicking" event is monitored every 150msec by default. A variable, at the start of the toolset, is used to define this delay (its name has conveniently been named... delay).

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/Status_bar_instructions.png">
</p>
<p align=center>
	<em><b>Instructions can be found in the status bar</b></em>
</p>

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/Orientation_montage.png">
</p>
<p align=center>
	<em><b>Example of orientation montage</b></em>
</p>

4. Once the process has been done for the first montage, press the space bar to jump to next dataset.
5. Once all datasets have been reviewed, orientations are stored in the output_folder/params.txt file.


#### Step 3: Segment
This third tool performs automated cells segmentation:

1. As the user presses the Step 3 button, a graphical user interface (GUI) pops-up asking for 5 parameters:
	- _**Parameters file**_: this parameter can be fed either by dragging and dropping the parameters file to the blank space or by using the "browse" button. NB: in case Step 3 is pressed after Step 1 or 2 has been pressed, the field is already filled with the proper link.
	- _**Weka model file**_: this parameter can be fed either by dragging and dropping the model file to the blank space or by using the "browse" button. NB: The model file used in production can be found [here](https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/IJ-Weka_Model/).
	- _**Number of layers cells to detect**_: this defines how far from the activation cells quantification should be performed. A value of 2 will consider two layers of cells in both directions (4 cells in total).
	- _**Minimum cell size (microns)**_: self-explanatory, allows excluding debris and small cells from detection.
	- _**Detection ROIs enlargement (pixels)**_: as the cells are detected from the cell walls, the actual ROIs might be shrunk as compared to the actual cells borders. This parameters allows compensating for this artefact by dilating the detected ROIs.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/GUI_Step3.png">
</p>			

2. Once the GUI has been Oked, all parameters are saved under output_folder/params.txt.
3. For each dataset, for each sequence:
	1. The projection is loaded.
	2. In case orientation has been labelled as reversed, the image is flipped horizontally.
	3. Channels are splitted, only channel 2 (cell walls) being retained.
	4. Trainable Weka segmentation 2D plugin (See the [documentation of the plugin here](https://imagej.net/plugins/tws/)) is called, using the provided model, to perform cells segmentation.
	5. An automated threshold is set to 0, corresponding the the "cell walls" category on the classified image.
	6. Mesurements are set to quantify the area an integrated density (ie total fluorescence) in each ROI.
	7. The "Analyze Particles" function is called, isolating individual cells which size is below the user-defined limit. The ROIs are pushed to the ROI Manager.
	8. Based on the highest integrated density, the activated cell is identified.
	9. The two bording cells from the first layer are identified by fitting the activated cell's oulines to an ellipse. The angle of its minor axis gives a rough approximate of the direction along which the bording cells will be found, its length and approximate of the intercellular distance. It is multiplied by 2 and a line roi is created from the activated cell, towards the tip root or the opposite direction. The centre of the bording cell is found as the second local minimum along this line (first minimum being within the activated cell itself).		
	10. For each bording cell from the first layer on, the reference cell is taken from the axis between the activated cell and the previous bording layer.
	11. The Background Cell is identified as the detected cell that is the furthest away from the Activated Cell.
	12. Based on these rules, the ROIs are identified, the ROI Manager is emptied the loaded with the relevent ROIs. Each individual ROI is properly renamed.
	13. A jpg image is saved is saved under output_folder/Detection_Checks/Lif_filename_without_extension/FRAP_XX.jpg, presenting the dual channel image, overlayed with the named ROIs.
	14. The corresponding registered stack is loaded from output_folder/Registered/Lif_filename_without_extension/FRAP_XX.zip.
	15. In case orientation has been labelled as reversed, the image is flipped horizontally.
	16. ROIs are overlayed to it.
	17. The stack, carying the ROIs as an overlay, is saved under output_folder/Registered_Oriented_with_ROIs/Lif_filename_without_extension/FRAP_XX.zip.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/Illust_find-cells.jpg">
</p>
<p align=center>
	<em><b>Example of how neighbour cells are found, based on oriented local maxima detection</b></em>
</p>

5. Once all datasets have been processed, parameters are stored in the output_folder/params.txt file, the "reverse tag" being set to false for all the images.


#### Step 4: Review ROIs & quantify
This final tool allows cells segmentation reviewing and performs quantifications as follows:

1. As the user presses the Step 4 button, a graphical user interface (GUI) pops-up asking for the parameters file:
	- _**Parameters file**_: this parameter can be fed either by dragging and dropping the folder to the blank space or by using the "browse" button. NB: in case Step 4 is pressed after Step 1, 2 or 3 has been pressed, the field is already filled with the proper link.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/GUI_Step4.png">
</p>			

2. Once the GUI has been Oked, all parameters are saved under output_folder/params.txt.
3. For each dataset, for each sequence:
	1. The projection is loaded.
	2. The user is presented with the detected ROIs overlaid to the projection.
	3. A GUI pops-up, aksing is detections are Ok.
		- Should the answer be Yes, the registered stack (loaded from output_folder/Registered/Lif_filename_without_extension/FRAP_XX.zip) is opened and the "Multi-measure" function is called. It generates a results table, saved under output_folder/csv/Lif_filename_without_extension/FRAP_XX.csv.
		- Should the answer be No, a new interface will appear,containing the procedure on how to correct ROIs:
			1. Click on the ROI to modify in the ROI Manager.
			2. Draw/adjust the ROI.
			3. Click on 'update' in the ROI Manager.
			4. Repeat for all ROIs then press Ok.
			5. A new version of both the projection and the registered stack overlaid with the ROIs are saved.
			6. Measurements are then perfomed as if the Yes button had been clicked.
		- Should the answer be Cancel, the macro is killed and process is stopped.
5. Once all datasets have been processed, parameters are stored in the output_folder/params.txt file.
6. A temporary folder is created under output_folder/\_dataToUpload:
	1. For each lif file, a subfolder is created: output_folder/\_dataToUpload/Lif_filename_without_extension/
	2. For each sequence, the relevent csv and jpg files are copied.
7. The temporary subfolder is zipped using the [Zip_It plugin](https://github.com/fabricecordelieres/IJ-Plugin_Zip-It) (see the instalaltion isntructions below), then deleted.
8. A message should pop-up, warning about next step: a web browser will open, directing to the [Google Colab script](https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/Python_Script/Colab_Root_Photoactivation_Analysis.ipynb). Follow the instructions on that webpage.
	
### Colab script
The Colab script will take care of compiling all the informations into XLSX files. To work, it will requiere the zip file that has been generated by the toolset, at Step 3.
1. A web browser should automatically point at the [Google Colab script](https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/Python_Script/Colab_Root_Photoactivation_Analysis.ipynb).
2. Use the arrow next to "Step 1" to fold all the code. A play button should now be visible: press it to setup the environment for execution. NB: a warning might appear: press "Run anyway".

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/Collab_Step1.jpg">
</p>	

3. Wait for the execution to end, then proceed to step 2.1: press play. A new box should appear where a zip file can be selected: feed it with the \_dataToUpload.zip file.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/Collab_Step2.jpg">
</p>	

4. After some time, the processing of data should start.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/Collab_Step3.jpg">
</p>

5. Once done, a \_dataAnalysed.zip file should automatically be downloaded to your computer: it contains all the XLSX compiled data.

<p align=center>
	<img src="https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/images/Collab_Output.jpg">
</p>
<p align=center>
	<em><b>Example of XLSX output</b></em>
</p>

### 

## How to install/use it ?

The [release page](https://github.com/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/releases/tag/v1.1) displays a download link for Root_Photoactivation_Analysis_Workflow.zip file. Once unzipped, it contains everything that needs to be installed.

*The toolset mostly relies on functions and plugins that are alredy embarqued within Fiji. Step 3, however, requires a separate plugin that should be installed before using the toolset:*
1. Download [Zip_It.jar](https://github.com/fabricecordelieres/IJ-Plugin_Zip-It/releases/tag/v1.0).
3. Drag-and-drop the .jar file to your ImageJ/Fiji toolbar.
4. In the File saver window, press Ok.
5. Restart Fiji/ImageJ.

*The toolset installation is quite straightforward:*
1. Copy/Paste the toolset file to Fiji's installation folder, in macros/toolset.
3. Under the ImageJ toolbar, on the right-most side, click on the red double arrow and select the appropriate toolset (choose "Startup macro" to go back to the original status).
4. Default ImageJ tools have partly been replaced by your toolset's buttons.

To use the toolset, first activate it, then press the buttons.


## Revisions:
### Version 1: 22/10/28 
### Version 1.1: 22/12/21
- Corrected a bug where bioformat would call several times the same dataset from the lif file when launched in batch mode.
- Corrected a bug where the Collab Script would fail due to a lack of detection of bording cells: in case the cell detection fails for a cell, a ROI is added at the top-left corner of the image.
- 
