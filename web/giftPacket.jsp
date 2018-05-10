<%-- 
    Document   : schedule
    Created on : Dec 28, 2016, 10:46:04 AM
    Author     : HafidS 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html ng-app="crudApp">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <script type="text/javascript">
        function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode;
         if (charCode > 31 && (charCode < 48 || charCode > 57 ) && charCode != 43 )
            return false;

         return true;
      }
      
      function editInfo(ad){
          alert(ad);
      }
    </script>
    <form name="fsearch" method="POST" >
    <div class="row m-bottom">
        <div class="col-lg-12">
            <div class="row">
                <div class="col-lg-4"></div>
                <div class="col-lg-4">
                    <div class="form-group">
                        <label>B#</label>
                        <input type="text" class="form-control" name="bnum" id="bnum" placeholder="Ex:628xxx" value="" maxlength="20" onkeypress="return isNumberKey(event)"/>
                    </div>
                    <div class="form-group">
                        <label>Package</label>
                        <select name="camreg" id="camreg" class="form-control">
                            <option value="">Please Select Your Package</option>
                            <option value="">Paket Data Roaming Singapore 1 Hari</option>
                            <option value="">Paket Data Roaming Singapore 3 Hari</option>
                            <option value="">Paket Data Roaming Singapore 7 Hari</option>
                            <option value="">Paket Data Roaming Asia dan Australia 3 Hari</option>
                            <option value="">Paket Data Roaming Eropa 3 Hari</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Schedule to Gift</label>
                        <div class="input-group date form_date" data-date="" data-date-format="dd-mm-yyyy hh:ii" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd hh:ii">
                            <input class="form-control" size="30" placeholder="Schedule to Gift" type="text" value="" readonly>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        </div>
                            <input type="hidden" id="dtp_input2" value="" /><br/>
                    </div>
                    <input type="button" class="btn btn-success" value="SUBMIT" id="s">
                </div>
                <div class="col-lg-4"></div>
            </div>
        </div>
    </div>
    </form>
    
<div class="col-lg-12 wrapper" ng-controller="DbController">
<div class="col-md-6 col-md-offset-3">
<div ng-include src="'templates/form.html'"></div>
<div ng-include src="'templates/editForm.html'"></div>
</div>
<div class="clearfix"></div>
<div class="table-responsive">

<table class="table table-striped table-bordered">
    <nav class="navbar navbar-right">
<div class="navbar-header">
<div class="alert alert-default input-group search-box">
<span class="input-group-btn">
    <input type="text" class="form-control" placeholder="Search..." ng-model="search_query"><br>
</span>    
</div>
</div>
    </nav>

<tr class="danger">
<th>Schedule ID</th>
<th>Schedule Date</th>
<th>Label</th>
<th>Action</th>
<!--<th></th>-->
</tr>
<tr ng-repeat="detail in details| filter:search_query">
<td>
<span>{{detail.no}}</span></td>
<td>{{detail.bnum}}</td>
<td>{{detail.package}}</td>
<td>{{detail.sch}}</td>
<!--<td>{{detail.emp_address}}</td>-->
<td>
<button class="btn btn-warning" onclick="editInfo(detail)" title="Edit" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-edit"></span></button>
</td>
<!--<td>
<button class="btn btn-danger" ng-click="deleteInfo(detail)" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>
</td>-->
</tr>
</table>
</div>
</div>
<!--</div>-->
<!-- Include controller -->
<script src="js/angular-script.js"></script>
</body>
</html>
