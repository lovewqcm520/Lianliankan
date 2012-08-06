// set all linkage class name to "flash.display.Sprite"
// move all mc position to (0, 0)
// change all mc size

//var lib = fl.getDocumentDOM().library; //library object
var lib = fl.getDocumentDOM().library;
fl.trace(lib.getSelectedItems());

var arr = lib.getSelectedItems();
var libLength = arr.length;
var itemArr=[];
for(var i=0; i < libLength; i++) {
   //push movie clip item to array
   if(arr[i].itemType=='movie clip')
		itemArr.push(arr[i]);
}


for (var i = 0; i < itemArr.length; i++) 
{


// get only mc name without path 
var mcName = itemArr[i].name;
var pos = mcName.lastIndexOf("/");
mcName = mcName.slice(pos+1);

	if(mcName.indexOf("SMALL_ITEM_") == 0)
	{
		itemArr[i].name = "SMALL_ITEM_" + (i+1).toString() + "_";
		itemArr[i].linkageClassName = "SMALL_ITEM_" + (i+1).toString() + "_";
	}
	
	

fl.trace(mcName);
}

// exit the edit mode
fl.getDocumentDOM().exitEditMode();
