// set all linkage class name to "flash.display.Sprite"
// move all mc position to (0, 0)
// change all mc size

var lib = fl.getDocumentDOM().library; //library object
fl.trace(fl.getDocumentDOM().name);

var libLength = lib.items.length;
var itemArr=[];
for(var i=0; i < libLength; i++) {
   //push movie clip item to array
		itemArr.push(lib.items[i]);
}


for (var i = 0; i < itemArr.length; i++) 
{


// get only mc name without path 
var mcName = itemArr[i].name;
var pos = mcName.lastIndexOf(".png");
mcName = mcName.slice(0, pos);

	// change the linkage base class
	if(pos != -1)
	{
		itemArr[i].name = mcName;
		fl.trace(mcName);
	}


}

// exit the edit mode
fl.getDocumentDOM().exitEditMode();
