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

function publishFile(fileList)
{
	for(var i in fileList)
	{
		var fileName = fileList[i];
				
		var filePath = path + "/" + fileName;
		var doc = fl.createDocument();
		doc.importFile(filePath);

		var profileXML=fl.getDocumentDOM().exportPublishProfileString();
		profileXML=profileXML.replace("<html>1</html>","<html>0</html>");
		fl.getDocumentDOM().importPublishProfileString(profileXML);
		
		filePath = filePath.replace(fileName, "");
		var file = fileName.replace(".png", "");
		var fileArray = file.split("-");
		var className = fileArray[1];
		
		var lib = fl.getDocumentDOM().library;
		lib.selectItem(lib.items[0].name);
		lib.setItemProperty('linkageExportForAS', true);
		lib.setItemProperty('linkageExportForRS', false);
		lib.setItemProperty('linkageExportInFirstFrame', true);
		lib.setItemProperty('linkageClassName', className);
		lib.setItemProperty('scalingGrid', false);
		lib.setItemProperty('compressionType', 'lossless');
		lib.setItemProperty('allowSmoothing', true);
		
		fileName = fileArray[0] + ".fla";
		filePath += fileName;
		fl.saveDocument(doc, filePath);
		doc.publish();
		doc.close();
	}
}