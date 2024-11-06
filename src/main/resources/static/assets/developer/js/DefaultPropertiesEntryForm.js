function getDefaultPropertiesEntryForm(){
	
	var form = `<div class="modal fade show" id="" tabindex="-1" role="dialog" style="display: block;" aria-modal="true">
					<div class="modal-dialog modal-dialog-centered" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<h2 class="modal-title">Default Properties</h2>
									<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closeDefaultPropertiesEntryForm()"></button>
								</div>
								<div class="modal-body mx-3">
									<div class="mb-3">
										<label class="form-label">Property Name</label>
										<input type="hidden" class="form-control" placeholder="Enter the new DefaultProperties" id="fsm_default_properties_uuid_id">
										<input type="text" class="form-control" placeholder="Enter the new Property Name" id="fsm_default_properties_property_name">								
									</div>	
									<div class="mb-3">
										<label class="form-label">Property Value</label>										
										<textarea class="form-control" placeholder="Enter the new property value" id="fsm_default_properties_property_value"></textarea>
									</div>									
								</div>
								<div class="modal-footer">
									<button class="btn btn-primary" data-bs-dismiss="modal" id="fsm_default_properties_delete_btn" style="background:#fe3f51;display:none;" onclick="deleteDefaultPropertiesDetails('')">Delete</button>
									<button class="btn btn-light" data-bs-dismiss="modal" onclick="clearDefaultPropertiesDetails()">Clear</button>
									<button class="btn btn-primary" data-bs-dismiss="modal" onclick="updateDefaultPropertiesDetails()">Save</button>																		
								</div>
							</div>
						</div>
					</div>`;
	return form;
};

function closeDefaultPropertiesEntryForm(){
	var containerId = "transparent_general_form_container_id";
	document.getElementById(containerId).style.display = "none";
};

function showDefaultPropertiesEntryForm(action){
    try{        
		var containerId = "transparent_general_form_container_id";
        document.getElementById(containerId).innerHTML = getDefaultPropertiesEntryForm();
		if(action == "edit"){			
			document.getElementById("fsm_default_properties_delete_btn").style.display = "block";
		}
        document.getElementById(containerId).style.display = "block";		
    }catch(exp){        
		toastr.error(exp,"Error", {closeButton: !0,tapToDismiss: !1});
    }
};



/*****************************************Update *********************************************** */
async function updateDefaultPropertiesDetails(){	
	var canContinue	= true;
    var jsonObj = JSON.parse("{}");
	jsonObj['ID'] = document.getElementById("fsm_default_properties_uuid_id").value;
    jsonObj['Property Name'] = document.getElementById("fsm_default_properties_property_name").value;
	jsonObj['Property Value'] = document.getElementById("fsm_default_properties_property_value").value;				  
	/*var inputNames = "DefaultProperties"; 
	var inputTypes = "text";
	var inputElementIds = "fsm_category_details_new_category";
	canContinue ? canContinue = await checkValidationDynamicInputRow(inputNames,inputTypes,inputElementIds): canContinue = false;*/
	if(canContinue){  		
	    let url = "/fsm/updateDefaultPropertiesDetails";
		let itemName = "updateDefaultPropertiesDetails";
	    await getDataFromServicePoint(url,jsonObj)
	        .then(async data => await populateDefaultPropertiesDetailsVResponse(data)) 
	        .catch(error => handleError(itemName,error));
	}
};

async function populateDefaultPropertiesDetailsVResponse(vResponseObj){
    if(vResponseObj.status == "true"){	
		toastr.success("Successfully Updated","Completed", {closeButton: !0,tapToDismiss: !1});		
		closeDefaultPropertiesEntryForm();		        
		showDefaultPropertiesListForm('');		
	}else{
		toastr.warning("Invalid DefaultProperties Details","Warning", {closeButton: !0,tapToDismiss: !1});
	}
};

/*****************************************Clear *********************************************** */
function clearDefaultPropertiesDetails(){    
	document.getElementById("fsm_default_properties_uuid_id").value = "";
	document.getElementById("fsm_default_properties_property_name").value = "";
	document.getElementById("fsm_default_properties_property_value").value = "";    
};
/*****************************************Edit *********************************************** */


async function editDefaultPropertiesDetails(vObj){
	
	var jsonObj = JSON.parse("{}");	
	jsonObj = await buildDynamicTableJsonObj(vObj);	
	swal({
	        title: "Confirmation",
	        text: "Do you want to Edit ?",
	        icon: "info",
	        buttons: true,
	        dangerMode: true,
	 }).then((confirmation) => {
	        if (confirmation) {				
				let url = "/fsm/editDefaultPropertiesDetails";
				let itemName= "editDefaultPropertiesDetails";
			    getDataFromServicePoint(url,jsonObj)
			        .then(data => populateEditDefaultPropertiesDetailsVResponse(data)) 
			        .catch(error => handleError(itemName,error));     
	        } 
	 });				
};

function populateEditDefaultPropertiesDetailsVResponse(vResponseObj){
    if(vResponseObj.status == "true"){
		showDefaultPropertiesEntryForm('edit');		
		var dataObj = vResponseObj.data;				
		document.getElementById("fsm_default_properties_uuid_id").value = dataObj['ID'];
		document.getElementById("fsm_default_properties_property_name").value = dataObj['Property Name'];
		document.getElementById("fsm_default_properties_property_value").value = dataObj['Property Value'];	
	}
};
/*****************************************Delete *********************************************** */
async function deleteDefaultPropertiesDetails(vObj){
	var jsonObj = JSON.parse("{}");
	if(vObj == ""){
		jsonObj['ID'] = document.getElementById("fsm_default_properties_uuid_id").value;		    		    		   
	}else{
		jsonObj = await buildDynamicTableJsonObj(vObj);
	}		
	
		swal({
		        title: "Confirmation",
		        text: "Do you want to delete ?",
		        icon: "warning",
		        buttons: true,
		        dangerMode: true,
		 }).then((confirmation) => {
		        if (confirmation) {
					let url = "/fsm/deleteDefaultPropertiesDetails";
					let itemName= "deleteDefaultPropertiesDetails";
	    			getDataFromServicePoint(url,jsonObj)
	        			.then(data => populateDeleteDefaultPropertiesDetailsVResponse(data)) 
	        			.catch(error => handleError(itemName,error));
				}
		});	
				
};

function populateDeleteDefaultPropertiesDetailsVResponse(vResponseObj){
    if(vResponseObj.status == "true"){			
		toastr.success("Deleted Successfully","Completed", {closeButton: !0,tapToDismiss: !1});
		closeDefaultPropertiesEntryForm();	
		showDefaultPropertiesListForm('');		    		    		   	
	}
};