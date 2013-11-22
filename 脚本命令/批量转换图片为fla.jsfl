fl.outputPanel.clear();

var path="";

browImageFile();  
function browImageFile()  
{  
    path = fl.browseForFolderURL("请选择导入文件夹");
    if(path)
	var fileList = FLfile.listFolder( path );  
    publishFile(fileList);    
}  

var currentDocumentName = "";
var lastFilePath = "";
var doc;
var invalidFileNum = 0;

function publishFile(fileList)
{
	for(var i = 0; i < fileList.length; i++)
	{
		var fileName = fileList[i];
		if(fileName.toLowerCase().substr(fileName.length - 4) != ".png") {
			continue;
		}
				
		var filePath = path + "/" + fileName;
		var file = fileName.replace(".png", "");
		var fileArray = file.split("-");
		if(fileArray.length < 2) {
			invalidFileNum++;
			continue;
		}
		var className = fileArray[1];
		
		if(fileArray[0] != currentDocumentName) {
			if(doc) {
				var profileXML=fl.getDocumentDOM().exportPublishProfileString();
				profileXML=profileXML.replace("<html>1</html>","<html>0</html>");
				fl.getDocumentDOM().importPublishProfileString(profileXML);
				fl.saveDocument(doc, lastFilePath);
				doc.publish();
				doc.close();
			}
			
			doc = fl.createDocument();
			currentDocumentName = fileArray[0];
		}
		doc.importFile(filePath);
		
		var lib = fl.getDocumentDOM().library;
		lib.selectItem(fileName);
		lib.setItemProperty('linkageExportForAS', true);
		lib.setItemProperty('linkageExportForRS', false);
		lib.setItemProperty('linkageExportInFirstFrame', true);
		lib.setItemProperty('linkageClassName', className);
		lib.setItemProperty('scalingGrid', false);
		lib.setItemProperty('compressionType', 'lossless');
		lib.setItemProperty('allowSmoothing', true);
		
		filePath = filePath.replace(fileName, "");
		fileName = fileArray[0] + ".fla";
		filePath += fileName;
		
		lastFilePath = filePath;
		
		if(i == (fileList.length - 1 - invalidFileNum)) {
			var profileXML=fl.getDocumentDOM().exportPublishProfileString();
			profileXML=profileXML.replace("<html>1</html>","<html>0</html>");
			fl.getDocumentDOM().importPublishProfileString(profileXML);
			fl.saveDocument(doc, lastFilePath);
			doc.publish();
			doc.close();
		}
	}
}