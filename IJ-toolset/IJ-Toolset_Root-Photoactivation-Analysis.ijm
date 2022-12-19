//-----------------GLOBAL VARIABLES----------------------
//IO folders
var macroVersion="1.3";
var wekaVersion="v3.3.2";
var in="";
var out="";

//Orientation parameters
var delay=100; //Delay in msec

//Filter parameters
var radMed=2;

var nBordingCells=2 ;
var minSize=30;
var flip=0;
var enlarge=2;

//Data structure
var subFolders=newArray("Raw", "Registered", "Proj", "Registered_Oriented_with_ROIs", "Detection_Checks", "csv");
var paramsFile="";
var wekaModel="";


//-------------------------------------------------------
macro "Lif to Zip Action Tool - N66C633D5aD6aCc99D7eC08cD81C800D2eCcefC8acC06bCcceC58cC922D3cD49CfffD04C7beC666Da8DddCccdC19cCa00D56D57D58D69D6cD6dD79D7bD8bCfffD14D24D34D44D54Da4Db4Dc4Dd4De4Ca9cC35aCeeeC4adDe0C999DbaCfffCbccD51C555D9dDadDbdDcdCcbbD0eC0adDb1C822D1eCeffC9bcC07cCceeC58cCa44D35CfffC8ceC666Db9CcdeC48cCb00D67D68D7cD89CeffCabdC777D96CfeeC5aeCbbcD50CadeC733D7aD8aCcaaD17C09dD91Ca00D46D47D48D59D5cD5dD5eD6bCeefC99cC25aCcdeC4acDc0Dd0C922D4bC9ceD92Da2Db2C666D97Da6Da7Db6Db7DbbDc6Dc7Dd6CcddC19dCa11D99D9bC9bdC36bCeeeC7acC999CbbdC555DacCcccC0bdC911D38CeffC7bdC37cCddeC7acC888Dd5De5CaceD62C777Dc8Dd7De6CdddC49cCa11D7dD88D8cCabdC48cC5beCcccD86Dc9DcbDd8DdcDe7DedCbdeC455DaeDbeDceDdeCcaaD28D39C18dC900D36D37D4cD4dD4eD5bCeefC7adC06bCcdeC49cDa0Db0C833C8cdD61C666Db8DccCccdC38cC9bdD72C55aCeeeC5adC79bD70CbcdCdaaD65C0adC922D16D27D2dC9bdC27bD71CdeeDe3C69dC955C8dfC677CcdeC39cCb00D78C9bdC68bC7bdCbdeC633D9cCdaaD06D76C09dCeffC9adC17aCddeC5adCa33C8ceDc2CcceC1adCabdC47bC7adCaacCbceD42C566D9eDeeCcccD95C0beDe1C8beC29cCdefC79dC888Da5CaceCdddC3adDe2Ca11D6eCabdC49cD90C7beCaefC644DabC08dC900D26D3dD3eCeefC8adC06bCddeD41C48cC8beCccdC28cC9adC46aCedeC5adC99aD60CbcdCdbbD1dD2cD3bC0adDa1C8adC59dCa44D45C8dfC48cC59aC4bdCbdeD52C733D9aC99cC16aC4adC933CcceC1adC37bC7adCbbbD8eCbcdC555DbcC0beDd1C38cC9ceC49dC59cD80C6beCbdfC19dCeefC07bC933C8ceDd2C38cCabdC55aC6adC79cCbbdC0adDc1C28cCddfC888Db5Dc5C8efC39cC7beCbdeC644D98Da9C26bC944D15D25C9ceC1adCabdC47bCaacC755D87CccdC9bdD82C39cCa88D4aC9dfC39dCb11D77CbbdC5abC7cfC9bdC0aeC966D05C744D8dC645DaaCdffC49cCb44D55C59bCb22D66CbceC38cC07bBf0C633Cc99C08cC800CcefC8acD68D6dC06bD54CcceD71C58cD37C922CfffC7beD3bC666CccdC19cCa00CfffD16Ca9cC35aD55CeeeC4adC999CfffD33D7eCbccC555CcbbC0adC822CeffD19D32C9bcC07cD63CceeD34C58cCa44CfffD17D1bD76D78D79D7bD7dD81C8ceD44C666CcdeD15C48cD3cCb00CeffCabdD61C777CfeeC5aeD11CbbcCadeD4dC733CcaaC09dCa00CeefD1eD84C99cC25aCcdeC4acC922C9ceC666CcddC19dCa11C9bdC36bCeeeC7acC999D05CbbdD6aC555CcccC0bdC911CeffD1cC7bdD74C37cCddeC7acD6bC888CaceC777CdddC49cD73Ca11CabdD26C48cC5beCcccD06D0eCbdeC455CcaaC18dD53C900CeefD10C7adD2eD39C06bCcdeC49cC833C8cdC666CccdD31C38cD3aC9bdC55aCeeeC5adC79bCbcdD41CdaaC0adD02C922C9bdD49D4eC27bCdeeC69dD47D4cD58D5dC955C8dfD22C677CcdeC39cCb00C9bdD2bC68bD59D5eC7bdD24CbdeC633CdaaC09dD13CeffC9adD25C17aCddeD82C5adD72Ca33C8ceCcceD67D6cC1adCabdC47bC7adD3eD45CaacCbceD21C566CcccC0beD01C8beD4aC29cCdefD75D83C79dD27D2cC888CaceD48CdddC3adCa11CabdD51C49cC7beD00CaefD43C644C08dC900CeefC8adD5bC06bCddeC48cC8beD36CccdD04C28cC9adD2aC46aD57D5cCedeC5adD38D3dC99aCbcdCdbbC0adC8adD29C59dCa44C8dfC48cD35C59aC4bdCbdeD46D4bC733C99cC16aD64C4adC933CcceC1adC37bC7adD56D66CbbbCbcdC555C0beC38cC9ceC49dC59cC6beCbdfD42C19dD62CeefC07bC933C8ceC38cCabdC55aC6adC79cD65CbbdD28D2dC0adC28cCddfC888C8efD23C39cC7beCbdeC644C26bC944C9ceC1adCabdD69D6eC47bD5aCaacC755CccdC9bdC39cD03D14Ca88C9dfC39dD52Cb11CbbdC5abC7cfC9bdC0aeD12C966C744C645CdffC49cCb44C59bCb22CbceC38cC07bB0fC633Cc99C08cC800CcefD27C8acC06bCcceC58cC922CfffC7beC666CccdC19cCa00CfffD86Ca9cC35aCeeeD0aD8aC4adC999CfffD32CbccC555CcbbC0adC822CeffC9bcC07cD62CceeC58cD30Ca44CfffD06D84C8ceC666CcdeD4aC48cCb00CeffD37CabdC777CfeeC5aeCbbcCadeC733CcaaC09dD03D12Ca00CeefDaaC99cDa9C25aD54CcdeD39C4acC922C9ceC666CcddD1aC19dCa11C9bdD97C36bD55CeeeC7acD19C999CbbdC555CcccC0bdC911CeffD38C7bdC37cD88CddeD81C7acC888CaceC777CdddD10C49cCa11CabdD79Da6C48cC5beD48CcccCbdeD74C455CcaaC18dC900CeefD15D83C7adD77C06bD53CcdeD3aC49cD14C833C8cdC666CccdC38cC9bdC55aD99CeeeD7aC5adD73C79bCbcdCdaaC0adC922C9bdC27bCdeeC69dC955C8dfC677CcdeD2aD5aC39cD78Cb00C9bdC68bD64C7bdCbdeC633CdaaC09dD13CeffD33C9adC17aCddeD6aD82C5adD18D49Ca33C8ceCcceC1adCabdC47bDa8C7adCaacD26CbceC566CcccC0beC8beD40C29cCdefC79dC888D00CaceCdddD01C3adCa11CabdC49cC7beCaefC644C08dD57C900CeefD70C8adC06bD63CddeD9aC48cD56C8beCccdC28cD51C9adD25C46aCedeC5adC99aCbcdCdbbC0adC8adD66C59dD34D44Ca44C8dfD43C48cC59aD11C4bdCbdeC733C99cD20C16aC4adD69C933CcceD65C1adD04C37bD24C7adCbbbCbcdD07C555C0beC38cD08C9ceD36D46C49dC59cDa7C6beCbdfC19dD68CeefD31C07bD58C933C8ceD05C38cD35D61CabdD87C55aC6adD71C79cD17CbbdC0adC28cCddfD76C888C8efD22C39cD72C7beD45CbdeD29C644C26bD59C944C9ceD21C1adD67CabdC47bD50CaacD89D96C755CccdD16C9bdC39cCa88C9dfD41D42C39dCb11CbbdD09C5abC7cfD23D47C9bdC0aeC966C744C645CdffD28C49cCb44C59bD02Cb22CbceD60C38cD98C07bD52Nf0C633Cc99C08cC800CcefC8acC06bCcceC58cC922CfffC7beC666CccdDe9C19cD84Ca00CfffD01Da1Da8Db1DbaDc1Dd1De1Ca9cDd9C35aCeeeC4adC999CfffCbccC555CcbbC0adC822CeffDa6C9bcDd3C07cCceeC58cCa44CfffD45C8ceC666CcdeD54C48cCb00CeffCabdD83D93Da3C777CfeeD51C5aeCbbcCadeC733CcaaC09dCa00CeefD76D86D96De6C99cC25aCcdeC4acC922C9ceC666CcddC19dD94Ca11C9bdDb3Dc3C36bCeeeD11D21D31D41Da9DdaDeaC7acC999CbbdC555CcccD53C0bdDd4C911CeffD66C7bdD65C37cCddeC7acC888CaceC777Da0Dd0De0CdddD43C49cD95Ca11CabdC48cD75C5beCcccD90CbdeC455CcaaD60C18dC900CeefC7adC06bCcdeC49cC833D10D20C8cdC666CccdC38cC9bdC55aCeeeDe2C5adC79bCbcdCdaaC0adC922C9bdC27bCdeeC69dC955D00C8dfC677Db0Dc0CcdeC39cDe8Cb00C9bdC68bC7bdCbdeDb8C633CdaaC09dCeffC9adDc6C17aDc5CddeDb6C5adCa33D50C8ceCcceC1adDa4CabdD73C47bC7adCaacCbceDe7C566CcccC0beC8beC29cDb5CdefDb7C79dC888CaceCdddC3adCa11CabdC49cC7beCaefC644C08dC900CeefC8adC06bCddeD44C48cC8beCccdD55C28cC9adC46aCedeDcaC5adC99aCbcdD63CdbbC0adC8adC59dDd7Ca44C8dfC48cC59aC4bdDe5CbdeC733C99cC16aC4adC933D40CcceC1adC37bC7adCbbbCbcdC555C0beDe4C38cC9ceC49dDc8C59cC6beD64CbdfDc7C19dCeefC07bC933D30C8ceC38cCabdC55aDc9C6adC79cCbbdC0adDc4C28cD74Dd5CddfC888C8efC39cC7beCbdeC644C26bDd8C944C9ceC1adDb4CabdC47bCaacC755CccdC9bdC39cCa88C9dfC39dDa5Cb11CbbdDb9C5abDe3C7cfC9bdDd6C0aeC966C744C645CdffC49cD85Cb44C59bCb22CbceC38cC07b"{
	run("Close All");
	GUI_extract();
	lifNames=getFilteredFileNamesWoExtension(in, ".lif");
	createDataStructure(lifNames);
	
	//setBatchMode(true); 
	for(i=0; i<lifNames.length;i++){
		lifToZip(in, lifNames[i], radMed, out);
	}
	
	List.set("Extraction_end_time", getDate());
	List.set("Extraction_macro_version", macroVersion);
	saveParameters(out);
}

//-------------------------------------------------------
macro "Orient Roots Action Tool - N66Cf00D05D06D15D16D25D26D35D36D45D46D55D56D65D66D75D76D85D86D95D96Da5Da6Db5Db6Dc5Dc6Dd5Dd6De5De6C0f0Bf0Cf00D05D06D12D13D14D15D16D17D18D19D22D23D24D25D26D27D28D29D33D34D35D36D37D38D43D44D45D46D47D48D54D55D56D57D58D64D65D66D67D74D75D76D77D85D86D95D96Da6C0f0B0fCf00C0f0D03D04D13D14D23D24D33D34D43D44D53D54D63D64D73D74D83D84D93D94Da3Da4Nf0Cf00C0f0D04D13D14D23D24D32D33D34D35D42D43D44D45D52D53D54D55D56D61D62D63D64D65D66D71D72D73D74D75D76D80D81D82D83D84D85D86D87D90D91D92D93D94D95D96D97Da3Da4Db3Db4Dc3Dc4Dd3Dd4De3De4"{
	run("Close All");
	GUI_orientation();
	
	
	out=List.get("out");
	paths=split(List.get("paths"), ",");
	
	for(i=0; i<paths.length; i++){
		processOrientation(out, paths[i]);
	}
	
	List.set("Orientation_Check_end_time", getDate());
	List.set("Orientation_Check_macro_version", macroVersion);
	saveParameters(out);
}


//-------------------------------------------------------
macro "Segment Action Tool - N66Cf00DbaDbbDcbDccDdcDddDedDeeC5b5D2dD2eD3bD3cD49D4aD4bD4cD4dD58D59D5dD66D67D68D69D6aD6dD6eD74D75D79D7aD7cD7dD7eD83D84D85D86D89D8aD8bD8cD8dD8eD93D94D95D96D98D99D9aD9bD9cDa2Da6Da7Da8Da9DaaDabDacDadDb1Db2Db3Db6Db7Db8Db9DbcDbdDbeDc0Dc1Dc2Dc3Dc5Dc6Dc7Dc8Dc9DcaDcdDceDd3Dd4Dd5Dd6Dd7DdaDdbDdeDe0De3De4De5De6De7De8DebDecCfa0D9dD9eDaeDd8Dd9De9DeaBf0Cf00C5b5D00D02D03D04D07D08D09D0cD0dD0eD10D11D12D13D14D15D18D19D1aD1dD1eD20D21D22D23D24D25D26D29D2aD2bD2cD2dD30D31D34D35D36D37D3aD3bD3cD3dD40D41D42D45D46D47D48D49D4aD4cD4dD4eD52D53D56D57D58D59D5aD5dD5eD60D63D64D67D68D69D6aD6bD6cD6dD6eD70D71D74D75D76D77D79D7aD7bD80D81D82D85D86D87D8aD8bD8cD90D91D92D93D94D95D97D98D99D9eDa0Da1Da2Da3Da4Da5Da8Da9DaaDadCfa0D0aD0bD1bD1cB0fCf00C5b5D00D01D03D04D05D07D08D10D11D14D15D16D17D20D21D22D26D31D32D33D36D40D41D42D43D45D53D54D60D63D70D72D80D81D90Cfa0Nf0Cf00C5b5D02D03D04D05D06D07D08D10D11D12D13D14D15D16D17D18D19D20D21D24D27D28D29D31D33D34D35D39D41D42D45D46D47D49D50D51D52D53D56D57D58D59D62D63D64D67D69D70D73D74D75D78D79D80D81D84D85D86D87D88D89D90D91D92D95D96D99Da1Da2Da3Da4Da5Da6Da7Da9Db2Db3Db4Db5Db6Db7Db9Dc0Dc3Dc4Dc5Dc6Dc7Dc8Dc9Dd0Dd1Dd2Dd3Dd4Dd8De0De1De2De3De4De5De8Cfa0Da0Db0Db1Dc1Dc2"{
	run("Close All");
	
	GUI_segment();
	
	out=List.get("out");
	paths=split(List.get("paths"), ",");
	
	for(i=0; i<paths.length; i++){
		folder=out+"Registered"+File.separator+paths[i];
		files=getFilteredFileNamesWoExtension(folder, ".zip");
		for(j=0; j<files.length; j++){
			stack=folder+files[j]+".zip";
			flip=List.get(paths[i]+files[j]+"_direction");
			if(flip==""){
				flip=0;
			}
			detectCells(stack, flip);
			List.set(paths[i]+files[j]+"_direction", 0);
		}
	}
	
	List.set("Segmentation_end_time", getDate());
	List.set("Segmentation_macro_version", macroVersion);
	saveParameters(out);
}

//-------------------------------------------------------
macro "Review ROIs & quantify Action Tool - N66C000De1Cf00D63D64D65D73D76D77D78D83D8dD8eD93Da3DbaDcaDcbDccDcdDceC1b0D19D1aD1bD29D2aD2bD2cD39D3aD3bD3cD3dD3eD4aD4bD4cD4dD4eD5bD5cD5dD5eD6aD6bD6cD6dD6eD79D7aD7bD7cD7dD7eD87D88D89D8aD8bD8cD96D97D98D99D9aD9bDa4Da5Da6Da7Da8Da9DaaDb3Db4Db5Db6Db7Db8Dc3Dc4Dc5Dc6Dc7Dd3Dd4Dd5C888De3De5De7De9DebDedBf0C000D01D11D21D31D41D51D61D71D81D91Da1Cf00C1b0C888D03D05D07D09D0bD0dD13D15D17D19D1bD1dD23D25D27D29D2bD2dD33D35D37D39D3bD3dD63D65D67D69D6bD6dD73D75D77D79D7bD7dD83D85D87D89D8bD8dD93D95D97D99D9bD9dDa3Da5Da7Da9DabDadB0fC000Cf00C1b0C888D00D02D04D06D08D10D12D14D16D18D20D22D24D26D28D30D32D34D36D38D60D62D64D66D68D70D72D74D76D78D80D82D84D86D88D90D92D94D96D98Da0Da2Da4Da6Da8Nf0C000Cf00D75D76D80D82D83D84D85D86D90D92D96D97Da0Da2Da7Db0Db2Db4Db5Db6Db7Dc0Dc2Dc3Dc4C1b0D40D50D60C888De0De2De4De6De8"{
run("Close All");
	
	checkForPlugin("Zip it", "Zip It", "https://github.com/fabricecordelieres/IJ-Plugin_Zip-It/releases/download/v1.0/Zip_It.jar");
	
	GUI_measure();
	
	out=List.get("out");
	paths=split(List.get("paths"), ",");
	
	for(i=0; i<paths.length; i++){
		folder=out+"Registered_Oriented_with_ROIs"+File.separator+paths[i];
		files=getFilteredFileNamesWoExtension(folder, ".zip");
		for(j=0; j<files.length; j++){
			stack=folder+files[j]+".zip";
			flip=List.get(paths[i]+files[j]);
			if(flip==""){
				flip=0;
			}
			measureCells(stack);
		}
	}
	
	List.set("Quantification_end_time", getDate());
	List.set("Quantification_macro_version", macroVersion);
	saveParameters(out);
	prepareDataForUpload();
	
	//Launch the colab script
	showMessage("Next step: data compilation with Python", "A web browser window will pop-up\nwith the Google Colab script to compile the data:\nfollow the instructions.");
	exec("open", "https://colab.research.google.com/github/fabricecordelieres/IJ-Toolset_Root-Photoactivation-Analysis/blob/main/Python_Script/Colab_Root_Photoactivation_Analysis.ipynb");
}


//-------------------------------------------------------
function GUI_extract(){
	Dialog.create("Data extraction and registration");
	Dialog.addDirectory("Where_are_the_lif_files_?", "");
	Dialog.addDirectory("Where_to_save_files_?", "");
	Dialog.addSlider("Median_filtering_radius_(pixels)", 1, 10, radMed);
	
	Dialog.show();
	
	in=Dialog.getString()+File.separator;
	out=Dialog.getString()+File.separator;
	radMed=Dialog.getNumber();
	
	List.clear();
	List.set("in", in);
	List.set("out", out);
	List.set("radMed", radMed);
	List.set("Extraction_start_time", getDate());
}

//-------------------------------------------------------

function GUI_orientation(){
	Dialog.create("Dataset orientation");
	Dialog.addFile("Parameters file", paramsFile);
	Dialog.show();
	
	paramFile=Dialog.getString();
	loadParameters(paramFile);
	List.set("Orientation_Check_start_time", getDate());
}

//-------------------------------------------------------
function GUI_segment(){
	Dialog.create("Segment Cells");
	Dialog.addFile("Parameters_file", paramsFile);
	Dialog.addFile("Weka_model_file", wekaModel);
	Dialog.addSlider("Number_of_layers_of_cells_to_detect", 1, 5, nBordingCells);
	Dialog.addSlider("Minimum_cell_size_(microns)", 10, 250, minSize);
	Dialog.addSlider("Detection_ROIs_enlargement_(pixels)", 1, 10, enlarge);
	Dialog.show();
	
	paramFile=Dialog.getString();
	wekaModel=Dialog.getString();
	
	loadParameters(paramFile);
	out=List.get("out");
	
	if(File.exists(wekaModel)){
		File.copy(wekaModel, out+"Weka_model.model");
		wekaModel=out+"Weka_model.model";
	}else{
		exit("Weka model file not found at "+wekaModel);
	}
	
	nBordingCells=Dialog.getNumber();
	minSize=Dialog.getNumber();
	enlarge=Dialog.getNumber();
	
	List.set("nBordingCells", nBordingCells);
	List.set("minSize", minSize);
	List.set("enlarge", enlarge);
	List.set("Weka_version", wekaVersion);
	List.set("Weka_model", wekaModel);
	List.set("Segmentation_start_time", getDate());
	
	saveParameters(out);
}

//-------------------------------------------------------
function GUI_measure(){
	Dialog.create("Check ROIs and Quantify Cells");
	Dialog.addFile("Parameters_file", paramsFile);
	Dialog.show();
	
	paramFile=Dialog.getString();
	
	loadParameters(paramFile);
	out=List.get("out");
	
	List.set("Quantification_start_time", getDate());
	
	saveParameters(out);
}

//-------------------------------------------------------
function loadParameters(file){
	paramArray=split(File.openAsString(file), "\n");
	
	List.clear();
	for(i=0; i<paramArray.length; i++){
		keyValue=split(paramArray[i], "=");
		List.set(keyValue[0], keyValue[1]);
	}
}

//-------------------------------------------------------
function saveParameters(out){
	paramsFile=out+"params.txt";
	File.saveString(List.getList, paramsFile);
}

//-------------------------------------------------------
function createDataStructure(lifNames){
	pathList=newArray();
	for(i=0; i<subFolders.length; i++){
		subFolder=out+subFolders[i]+File.separator;
		File.makeDirectory(subFolder);
		for(j=0; j<lifNames.length; j++){
			File.makeDirectory(subFolder+lifNames[j]);
			if(i==0){
				pathList=Array.concat(pathList, lifNames[j]+File.separator);
			}
		}
	}
	List.set("paths", String.join(pathList, ","));
}

//-------------------------------------------------------
function lifToZip(in, fileName, radMed, out){
	run("Bio-Formats Macro Extensions"); 

	Ext.setId(in+File.separator+fileName+".lif");
	Ext.getSeriesCount(seriesCount);

	for(i=0; i<seriesCount; i++){
		Ext.setSeries(i);

		Ext.getSeriesName(seriesName);

		if(indexOf(seriesName, "FRAP Series")!=-1){
			getStack(seriesName);
			name=substring(seriesName, 0, lastIndexOf(seriesName, "/"));
			
			rename("Prebleach");
			
			Ext.setSeries(i+1);
			Ext.getSeriesName(seriesName);
			getStack(seriesName);
			
			rename("Postbleach");
			
			run("Concatenate...", "open image1=Prebleach image2=Postbleach");
			saveAs("ZIP", out+"Raw"+File.separator+fileName+File.separator+name+".zip");
			
			//Performs registration on channel 2
			run("Correct 3D drift", "channel=2 correct edge_enhance only=0 lowest=1 highest=1 max_shift_x=50.000000000 max_shift_y=50 max_shift_z=10");
			selectWindow("registered time points");
			
			close(name+".tif");
			selectWindow("registered time points");
			saveAs("ZIP", out+"Registered"+File.separator+fileName+File.separator+name+".zip");
			
			run("Z Project...", "projection=[Sum Slices]");
			//run("Median...", "radius="+radMed);
			saveAs("ZIP", out+"Proj"+File.separator+fileName+File.separator+name+".zip");
			
			run("Close All");
	
			call("java.lang.System.gc");
		}
	}
	Ext.close();
}

//-------------------------------------------------------
function getStack(seriesName){
		Ext.getImageCount(imageCount);
			
		for(j=0; j<imageCount; j++){
			Ext.openImage("", j);
			rename("Img_"+j);
		}

		if(imageCount>1) run("Images to Stack", "name=["+seriesName+"] title=Img_ use");

		Ext.getDimensionOrder(dimOrder);

		Ext.getSizeZ(sizeZ);
		Ext.getSizeC(sizeC);
		Ext.getSizeT(sizeT);

		if(imageCount>1) run("Stack to Hyperstack...", "order=xyczt(default) channels="+sizeC+" slices="+sizeZ+" frames="+sizeT+" display=Composite");
}

//-------------------------------------------------------
function processOrientation(in, path){
	setBatchMode(true);
	fileList=getFilteredFileNamesWoExtension(in+"Proj"+File.separator+path, ".zip");
	for(i=0; i<fileList.length; i++){
		open(in+"Proj"+File.separator+path+fileList[i]+".zip");
		ori=getTitle();
		run("RGB Color");
		close(ori);
		rename(fileList[i]);
	}
	
	run("Images to Stack", "use");
	w=getWidth();
	h=getHeight();
	setForegroundColor(255, 255, 255);
	run("Make Montage...", "scale=1 font="+h/20+" label use");
	nCol=getWidth()/w;
	nRow=getHeight()/h;
	
	roiManager("Reset");
	index=0;
	for(y=0; y<nRow; y++){
		for(x=0; x<nCol; x++){
			if(index<fileList.length){
				makeArrow(w*(x+0.8), h*(y+0.5), w*(x+0.2), h*(y+0.5), "Filled Large Outline");
				Roi.setStrokeWidth(w/50);
				Roi.setFillColor("Green");
				roiManager("Add");
				index++;
			}
		}
	}
	run("Select None");
	run("Remove Overlay"); //Required for batch mode
	close("Stack");
	setBatchMode("exit and display");
	roiManager("Show All without labels");
	
	x2=-1; y2=-1; z2=-1; modifiers=-1;
	while(!isKeyDown("space")){
		showStatus("Click on the image to invert orientation, press SPACE once done.");
		getCursorLoc(x, y, z, modifiers);
		if(modifiers&16!=0){
			col=floor(x/w);
			row=floor(y/h);
			
			roiManager("Select", col+row*nCol);
			if(Roi.getFillColor=="green"){
				makeArrow(w*(col+0.2), h*(row+0.5), w*(col+0.8), h*(row+0.5), "Filled Large Outline");
				Roi.setStrokeWidth(w/50);
				Roi.setFillColor("red");
				roiManager("Update");
				wait(250);
			}else{
				makeArrow(w*(col+0.8), h*(row+0.5), w*(col+0.2), h*(row+0.5), "Filled Large Outline");
				Roi.setStrokeWidth(w/50);
				Roi.setFillColor("green");
				roiManager("Update");
				wait(delay);
			}
		}
		
		wait(delay);
		roiManager("Show All without labels");
	}
	
	for(i=0; i<fileList.length; i++){
		roiManager("Select", i);
		color=Roi.getFillColor;
		direction=0;
		if(color=="red"){
			direction=1;
		}
		List.set(path+fileList[i]+"_direction", direction);
	}
	run("Close All");
}

//-------------------------------------------------------
function detectCells(stack, flip){
	//Load parameters
	wekaModel=List.get("Weka_model");
	nBordingCells=List.getValue("nBordingCells");
	minSize=List.getValue("minSize");
	enlarge=List.getValue("enlarge");
	
	proj=replace(stack, "Registered", "Proj");

	roiManager("Reset");
	run("Clear Results");
	
	open(proj);
	run("Remove Overlay");
	
	if(flip) run("Flip Horizontally");
	
	ori=getTitle();
	
	run("Duplicate...", "title=Sum duplicate");
	run("Split Channels");
	
	selectWindow("C2-Sum");
	
	run("Trainable Weka Segmentation");
	wait(3000);
	selectWindow("Trainable Weka Segmentation "+wekaVersion);
	call("trainableSegmentation.Weka_Segmentation.loadClassifier", wekaModel);
	call("trainableSegmentation.Weka_Segmentation.getResult");
	
	while (getTitle()!="Classified image"){
		wait(1000);
	}
	selectWindow("Trainable Weka Segmentation v3.3.2");
	run("Close");
	
	selectWindow("Classified image");
	wait(500); //Sometimes, the macro fails to activate the image to set threshold
	setThreshold(0, 0);
	
	run("Set Measurements...", "area mean fit integrated centroid redirect=[C1-Sum] decimal=4");
	run("Analyze Particles...", "size="+minSize+"-Infinity display exclude clear add");
	roiManager("Show None");
	
	//Find the max intensity cell
	selectWindow("Results");
	rawIntDen=Table.getColumn("RawIntDen");
	ranksRawIntDen=Array.rankPositions(rawIntDen);
	activatedCell=ranksRawIntDen[ranksRawIntDen.length-1];
	
	//Get the coordinates of the activated cell and computes distances to it
	xActivated=Table.get("X", activatedCell);
	yActivated=Table.get("Y", activatedCell);
	Table.applyMacro("Distance=sqrt((X-"+xActivated+")*(X-"+xActivated+")+(Y-"+yActivated+")*(Y-"+yActivated+"))");
	
	distances=Table.getColumn("Distance");
	ranksDistance=Array.rankPositions(distances);
	
	cellsIndex=newArray(nBordingCells*2+2);
	cellsNames=newArray(nBordingCells*2+2);
	
	cellsIndex[0]=activatedCell; cellsNames[0]="Activated Cell";
	cellsIndex[cellsIndex.length-1]=ranksDistance[ranksDistance.length-1]; cellsNames[cellsNames.length-1]="Background";
	
	for(i=0; i<nBordingCells; i++){
		if(i==0){
			//Find the bording cell by ellipse fitting the activated cell
			tmp=getBorder1Cell(activatedCell);
			leftCell=tmp[0];
			rightCell=tmp[1];
		}else{
			//From 2-2' on, uses the previous cell as reference to find next closest cell
			//Left
			leftCell=getNextCellInLine(cellsIndex[0], cellsIndex[2*(i-1)+1], i+1); //getIndexClosestCell(cellsIndex[2*(i-1)+1]);
			//Right
			rightCell=getNextCellInLine(cellsIndex[0], cellsIndex[2*(i-1)+2], i+1); //getIndexClosestCell(cellsIndex[2*(i-1)+2]);
		}
		
		cellsIndex[2*i+1]=leftCell; cellsNames[2*i+1]="Border Cell "+(i+1);
		cellsIndex[2*i+2]=rightCell; cellsNames[2*i+2]="Border Cell "+(i+1)+"'";	
	}
	run("Remove Overlay");
	
	for(i=0; i<cellsIndex.length; i++){
		if(cellsIndex[i]!=-1){
			roiManager("Select", cellsIndex[i]);
			run("Enlarge...", "enlarge="+enlarge+" pixel");
		}else{
			makeRectangle(0,0,1,1);
		}
		Roi.setName(cellsNames[i]);
		run("Add Selection...");
	}
	
	roiManager("Reset");
	run("To ROI Manager");
	
	selectWindow(ori);
	run("From ROI Manager");
	saveAs("ZIP", proj);
	 
	run("Labels...", "color=white font=12 show use");
	saveAs("Jpeg", replace(replace(stack, "Registered", "Detection_Checks"), ".zip", ".jpg"));
	
	open(stack);
	if(flip) run("Flip Horizontally");
	run("From ROI Manager");
	
	//Save the registered, oriented stack with ROIs
	saveAs("ZIP", replace(stack, "Registered", "Registered_Oriented_with_ROIs"));
	run("Close All");
	
	roiManager("Reset");
	
	selectWindow("Results");
	run("Close");
}

//-------------------------------------------------------
function measureCells(stack){
	//Load parameters
	proj=replace(stack, "Registered_Oriented_with_ROIs", "Proj");

	roiManager("Reset");
	run("Clear Results");
	
	open(proj);
	run("To ROI Manager");
	
	roiNames=newArray(roiManager("Count"));
	for(i=0; i<roiNames.length; i++){
		roiManager("Select", i);
		roiNames[i]=Roi.getName;
	}
	
	ori=getTitle();
	
	roiManager("Show All with labels");
	roiManager("UseNames", "true");
	
	//Check ROIs
	isDetectionOk=getBoolean("Is detection Ok ?");
	if(!isDetectionOk){
		run("Remove Overlay");
		setTool("freehand");
		waitForUser("1-Click on the ROI to modify in the ROI Manager\n2-Draw/adjust the ROI\n3-Click on 'update' in the ROI Manager\n4-Repeat for all ROIs then press Ok");
		setTool("rectangle");
		for(i=0; i<roiNames.length; i++){
			roiManager("Select", i);
			roiManager("rename", roiNames[i]);
		}
	}
	
	//Save intermediate checks
	selectWindow(ori);
	run("Remove Overlay");
	run("From ROI Manager"); 
	run("Labels...", "color=white font=12 show use");
	saveAs("Jpeg", replace(replace(stack, "Registered_Oriented_with_ROIs", "Detection_Checks"), ".zip", ".jpg"));
	
	open(stack);
	run("Remove Overlay");
	run("From ROI Manager");
	
	//Performs measurements
	run("Set Measurements...", "area integrated redirect=None decimal=4");
	roiManager("Multi Measure");
	saveAs("Results", replace(replace(stack, "Registered_Oriented_with_ROIs", "csv"), ".zip", ".csv"));
	selectWindow("Results");
	run("Close");

	//Save the registered, oriented stack with ROIs
	saveAs("ZIP", stack);
	run("Close All");
	
	roiManager("Reset");
}

//-------------------------------------------------------
function prepareDataForUpload(){
	out=List.get("out");
	paths=split(List.get("paths"), ",");

	dataToUpload=out+"_dataToUpload"+File.separator;
	File.makeDirectory(dataToUpload);
	
	csvRoot=out+"csv"+File.separator;
	jpgRoot=out+"Detection_Checks"+File.separator;
	
	for(i=0; i<paths.length; i++){
		files=getFilteredFileNamesWoExtension(csvRoot+paths[i], ".csv");
		dataToUploadSub=dataToUpload+paths[i];
		
		File.makeDirectory(dataToUploadSub);
		for(j=0; j<files.length; j++){
			File.copy(csvRoot+paths[i]+files[j]+".csv", dataToUploadSub+files[j]+".csv");
			File.copy(jpgRoot+paths[i]+files[j]+".jpg", dataToUploadSub+files[j]+".jpg");
		}
	}
	
	saveParameters(dataToUpload);//saves a copy once everything is extracted, to be used by the data formatting script
	run("Zip it", "input_folder=["+dataToUpload+"] output_folder=["+out+"] zip_filename=_dataToUpload.zip remove_input_folder");
}

//-------------------------------------------------------
function getFilteredFileNamesWoExtension(folder, ext){
	fileNames=getFileList(folder);
	for(i=0; i<fileNames.length; i++){
		if(!endsWith(fileNames[i], ext)){
			fileNames=Array.deleteIndex(fileNames, i);
			i--;
		}else{
			fileNames[i]=replace(fileNames[i], ext, "");
		}
	}
	return fileNames;
}

//-------------------------------------------------------
function getIndexClosestCell(refCell){
	x=Table.get("X", refCell);
	y=Table.get("Y", refCell);
	Table.applyMacro("Distance=sqrt((X-"+x+")*(X-"+x+")+(Y-"+y+")*(Y-"+y+"))");
	Table.update;
	
	distances=Table.getColumn("Distance");
	tag=Table.getColumn("Tag");
	Table.update;
	ranksDistance=Array.rankPositions(distances);
	
	cell=-1;
	for(i=1; i<ranksDistance.length; i++){ // Exclude the rank 0 which is the ref cell
		if(tag[ranksDistance[i]]==0){
			cell=ranksDistance[i];
			break;
		}
	}
	
	return cell;
}

//-------------------------------------------------------
function getBorder1Cell(activatedCell){
	getPixelSize(unit, pixelWidth, pixelHeight);
	minor=2*getResult("Minor", activatedCell)/pixelWidth;
	angle=90-getResult("Angle", activatedCell);

	Xa=getResult("X", activatedCell)/pixelWidth;
	Ya=getResult("Y", activatedCell)/pixelHeight;

	Xr=Xa+minor*cos((angle)*PI/180);
	Yr=Ya+minor*sin((angle)*PI/180);

	Xl=Xa+minor*cos((180+angle)*PI/180);
	Yl=Ya+minor*sin((180+angle)*PI/180);

	makeLine(Xa, Ya, Xl, Yl);
	indexLeft=getNthMinimaOnLine(1); //Left cell is the next minimum on the right
	makeLine(Xa, Ya, Xr, Yr);
	indexRight=getNthMinimaOnLine(1); //Right cell is the next minimum on the right
	
	return newArray(indexLeft, indexRight);
}

//-------------------------------------------------------
function getNextCellInLine(activated, neighbour, nthLayer){
	if(neighbour==-1){
		return -1;
	}
	
	x=Table.getColumn("X");
	y=Table.getColumn("Y");
	
	getPixelSize(unit, pixelWidth, pixelHeight);
	
	Xa=x[activated]/pixelWidth;
	Ya=y[activated]/pixelWidth;
	
	Xb=x[neighbour]/pixelWidth;
	Yb=y[neighbour]/pixelWidth;
	
	Xt=Xb+nthLayer*(Xb-Xa);
	Yt=Yb+nthLayer*(Yb-Ya);
	
	makeLine(Xa, Ya, Xt, Yt);
	
	return getNthMinimaOnLine(nthLayer);
}


//-------------------------------------------------------
function getNthMinimaOnLine(nth){
	run("Interpolate", "interval=1 adjust");
	Roi.getCoordinates(xpoints, ypoints);
	getPixelSize(unit, pixelWidth, pixelHeight);
	run("32-bit");
	run("Gaussian Blur...", "sigma=2"); //Smooth borders to highlight local min/max
	
	profile=getProfile();
	
	run("Undo");
	minimas=Array.findMinima(profile, 0.5);
	Array.sort(minimas);
	
	
	cellIndex=-1;
	
	if(nth<minimas.length){
		Xt=xpoints[minimas[nth]]; // Finds the x of the nth minima on the line
		Yt=ypoints[minimas[nth]]; // Finds the y of the nth minima on the line
		
		for(i=0; i<roiManager("Count"); i++){
			roiManager("Select", i);
			if(Roi.contains(Xt, Yt)){
				cellIndex=i;
				break;
			}
		}
	}
	
	return cellIndex;
}

//-------------------------------------------------------
function getDate(){
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	return ""+year+"-"+IJ.pad(month, 2)+"-"+IJ.pad(dayOfMonth, 2)+" "+IJ.pad(hour, 2)+":"+IJ.pad(minute, 2)+":"+IJ.pad(second, 2);
}

//----------------------------------------------------------------------
function checkForPlugin(menuName, pluginName, URL){
	List.setCommands;
	if(List.get(menuName)==""){
		waitForUser("The "+pluginName+" plugin is missing\nand will be downloaded.\nIn the next window, simply\nclick on \"Save\" button to install it.");
		open(URL);
		showStatus(pluginName+" downloaded");
	}else{
		showStatus("Check for "+pluginName+" passed");
	}
}
