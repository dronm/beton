<?php

//helper function to executer commands
function run_cmd($cmd){
	$result_code = NULL;
	$res = system($cmd, $result_code);
	if($res === FALSE){
		throw new Exception("system() failed");
	}
	return $res;
}


function get_image_dimensions($file, &$retVal){
	static $ident_cmd = 'identify -format "%%[fx:w]-%%[fx:h]" %s';

	$dimen = run_cmd(sprintf($ident_cmd, $file));
	$dimen_ar = explode("-", $dimen);
	if(count($dimen_ar) >= 2){
		$retVal["width"] = intval($dimen_ar[0]);
		$retVal["height"] = intval($dimen_ar[1]);
	}
}

// Generates thumbnails of any file
// office formats are converted to pdf first
// pdf converted with pdftoppm
// graphical extensions are converted with convert
function gen_thumbnail($file, $ext, &$retVal) {
	static $office_ext = array("doc", "docx", "xls", "xlsx", "odt", "ods", "txt");
	static $pict_ext = array("jpg", "jpeg", "png", "gif");
	static $pdf_cmd = "pdftoppm -l 1 -scale-to 300 -jpeg %s %s";
	static $office_cmd = "soffice --headless --convert-to pdf:writer_pdf_Export --outdir %s %s";
	static $convert_cmd = "convert -define jpeg:size=500x180 %s -auto-orient -thumbnail 250x100 -unsharp 0x.5 %s";

	$retVal = array("preview_file" => NULL, "width" => NULL, "height" => NULL);

	$file_to_delete = NULL;
	$retVal["preview_file"] = dirname($file).DIRECTORY_SEPARATOR. uniqid(). '.jpg';
	$cmd = "";
	if(in_array($ext, $office_ext)){
		$cmd = sprintf($office_cmd, dirname($file), $file);
		run_cmd($cmd); //makes file with pdf ext in the same folder
		
		$file_ext = pathinfo($file, PATHINFO_EXTENSION);
		if(strlen($file_ext)){
			$file_no_ext = substr($file, 0, strlen($file) - 4);
		}else{
			$file_no_ext = $file;
		}
		$file_to_delete =  $file_no_ext. ".pdf";
		$file = $file_to_delete;
		$cmd = sprintf($pdf_cmd, $file, $retVal["preview_file"]);
		$ext = "pdf";

	}else if($ext == "pdf"){
		$cmd = sprintf($pdf_cmd, $file, $retVal["preview_file"]);

	}else if(in_array($ext, $pict_ext)){
		$cmd = sprintf($convert_cmd, $file, $retVal["preview_file"]);

	}else {
		throw new Exception("unsupported file format");
	}
	
	run_cmd($cmd);
	if($ext == "pdf"){
		$thumbnail = "";
		if(file_exists($retVal["preview_file"]."-1.jpg")){
			$thumbnail = $retVal["preview_file"]."-1.jpg";

		}else if(file_exists($retVal["preview_file"]."-01.jpg")){
			$thumbnail = $retVal["preview_file"]."-01.jpg";

		}else if(file_exists($retVal["preview_file"]."-001.jpg")){
			$thumbnail = $retVal["preview_file"]."-001.jpg";

		}else{
			throw new Exception("thumbnail file not found");
		}

		if(rename($thumbnail, $retVal["preview_file"]) === FALSE){
			throw new Exception("rename() failed");
			
		}
		if(!is_null($file_to_delete)){
			unlink($file_to_delete);
		}
	}
	get_image_dimensions($retVal["preview_file"], $retVal);
}
?>
