function getAdminDashboardForm(){
    var form = `
	<div class="container-fluid p-0">

			<div class="row mb-2 mb-xl-3">
				<div class="col-auto d-none d-sm-block">
					<h2>FSM - INDEXES</h2>
				</div>

				<div class="col-auto ms-auto text-end mt-n1">
				</div>
			</div>
			<div class="row">
				<div class="col-12 col-md-6 col-xxl d-flex">
					<div class="card flex-fill">
						<div class="card-body">
							<div class="row">
								<div class="col mt-0">
									<h5 class="card-title">Products</h5>
								</div>

								<div class="col-auto">
									<div class="stat stat-sm" style="">
										<i class="fa fa-box-open align-middle"></i>
									</div>
								</div>
							</div>
							<h4 class="mt-0 mb-1" id="dashboard_product_count_element">00</h4>

							<div class="mb-0">
								<span class="badge badge-subtle-success"></span>
								<span class="text-muted">Over All Data</span>
							</div>

						</div>
					</div>
				</div>
				<div class="col-12 col-md-6 col-xxl d-flex">
					<div class="card flex-fill">
						<div class="card-body">
							<div class="row">
								<div class="col mt-0">
									<h5 class="card-title">DAR</h5>
								</div>

								<div class="col-auto">
									<div class="stat stat-sm" style="background: #F7931A; color: white;">
										<i class="fa fa-gift align-middle"></i>
									</div>
								</div>
							</div>
							<h4 class="mt-0 mb-1" id="dashboard_dar_count_element">00</h4>

							<div class="mb-0">
								<span class="text-muted">Over All Data</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-12 col-md-6 col-xxl d-flex">
					<div class="card flex-fill">
						<div class="card-body">
							<div class="row">
								<div class="col mt-0">
									<h5 class="card-title">Estimation</h5>
								</div>

								<div class="col-auto">
									<div class="stat stat-sm" style="background: #345D9D; color: white;">
										<i class="fa fa-donate align-middle"></i>
									</div>
								</div>
							</div>
							<h4 class="mt-0 mb-1" id="dashboard_estimation_count_element">00</h4>

							<div class="mb-0">
								<span class="text-muted">Over All Data</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-12 col-md-6 col-xxl d-flex">
					<div class="card flex-fill">
						<div class="card-body">
							<div class="row">
								<div class="col mt-0">
									<h5 class="card-title">Orders</h5>
								</div>

								<div class="col-auto">
									<div class="stat stat-sm" style="background: #627EEA; color: white;">
										<i class="fa fa-envelope align-middle"></i>
									</div>
								</div>
							</div>
							<h4 class="mt-0 mb-1" id="dashboard_order_count_element">00</h4>

							<div class="mb-0">
								<span class="text-muted">Over All Data</span>
							</div>
						</div>
					</div>
				</div>
				
			</div>
		</div>`;
    return form;
};


function showAdminDashboardForm(){
    try{
        hideAllLayer();
        var containerId = "dashboard_list_form";         
        document.getElementById(containerId).style.display = "block";	
		document.getElementById(containerId).innerHTML = getAdminDashboardForm();	
		getAdminDashboardRefresh();	
    }catch(exp){
        alert(exp);
		toastr.error(exp,"Error", {closeButton: !0,tapToDismiss: !1});
    }
};


async function getAdminDashboardRefresh(){
    var jsonObj = JSON.parse("{}");  
	jsonObj['userId'] = logginerUserId;       
    let url = "/fsm/getAdminDashboardDetailsIndexes";
	let itemName= "getAdminDashboardDetailsIndexes";
    getDataFromServicePoint(url,jsonObj)
        .then(async data => await populateAdminDashboardRefreshVResponse(data)) 
        .catch(error => handleError(itemName,error));
};


async function populateAdminDashboardRefreshVResponse(vResponse){	
	
    if(vResponse.status == "true"){
		var dataObj = vResponse.data;
		document.getElementById("dashboard_product_count_element").innerHTML = dataObj['productCount'];
		document.getElementById("dashboard_dar_count_element").innerHTML = dataObj['darCount'];
		document.getElementById("dashboard_estimation_count_element").innerHTML = dataObj['estimationCount'];
		document.getElementById("dashboard_order_count_element").innerHTML = dataObj['orderCount'];	        	
	}
};
