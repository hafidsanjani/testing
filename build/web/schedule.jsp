<%-- 
    Document   : schedule
    Created on : Dec 28, 2016, 10:46:04 AM
    Author     : HafidS 
--%>


<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            String query = "";
            String query1 = "";
            PreparedStatement ps = null;
            PreparedStatement ps1 = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection(); 
            String a="13";
            query = "select * from scheduler where co_id=?";
            ps = con.prepareStatement(query);
            ps.setString(1, a.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs = ps.executeQuery();
%>
    <script type="text/javascript">
        function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode;
         if (charCode > 31 && (charCode < 48 || charCode > 57 ) && charCode != 43 )
            return false;

         return true;
      }
      
      function der(){
        if(document.fsearch.schdt.value == ""){
        alert("Scheduler Date Harus Diisi !!!");
        document.fsearch.schdt.focus();
        }else if(document.fsearch.lbl.value == "") {
        alert("Label Harus Diisi !!!");
        document.fsearch.lbl.focus();    
        }else{
            document.fsearch.action="inputsch.jsp";
            document.fsearch.submit();
        }
          //var yt = document.fsearch.schdt.value;
          //alert("syalalalala"+yt);
      }
      
      function gift(k){
          document.fsearch.barisss.value=k;
          document.fsearch.proses.value="new";
          document.fsearch.action="main.jsp?menu=gab";
          document.fsearch.submit();
          
      }
      
      $(document).ready(function() {
      $('#example').DataTable();
      } );
      
    </script>
    <div>
    <form name="fsearch" method="POST" >
    <input name="barisss" type="hidden" />
    <input name="proses" type="hidden" />
    <div class="row m-bottom">
        <div class="col-lg-12">
            <div class="row">
                <div class="col-lg-4"></div>
                <div class="col-lg-4">
                    <div class="form-group">
                        <label>Schedule to Gift</label>
                        <div class="input-group date form_date" data-date="" data-date-format="dd-mm-yyyy hh:ii" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd hh:ii">
                            <input class="form-control" size="30" name="schdt" placeholder="Schedule to Gift" type="text" value="" readonly>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        </div>
                            <input type="hidden" id="dtp_input2" value="" /><br/>
                    </div>
                    <div class="form-group">
                        <label>Label</label>
                        <input type="text" class="form-control" name="lbl" id="lbl" placeholder="label" value="" maxlength="20" />
                    </div>
                    <input type="button" class="btn btn-success" onclick="der()" value="SUBMIT" id="s">
                </div>
                <div class="col-lg-4"></div>
            </div>
            <div class="row">
                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>    
                                                        <th>No</th>
							<th>Schedule ID</th>
							<th>Schedule Date</th>
							<th>Label</th>
							<th>Action</th>
						</tr>
					</thead>
					
					<tbody>
                                            <%
                                                int j =0;
                                                while(rs.next()){
                                                    j=j+1;
                                            %>
						<tr>
							<td><%=j%></td>
                                                        <td><input type="hidden" name="<%="schid_"+j%>" value="<%=rs.getString("sche_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("sche_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="schdt_"+j%>" value="<%=rs.getString("sche_dt").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("sche_dt").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="label_"+j%>" value="<%=rs.getString("label").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("label").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td>
                                                        <button class="btn btn-warning" ng-click="editInfo(detail)" title="Edit" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-edit"></span></button>
                                                        <button class="btn btn-success" onclick="javascript:gift(<%=j%>)" title="Gift" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-gift"></span></button>
                                                        </td>
						</tr>
                                            <%
                                                }
                                            %>
					</tbody>
				</table>
            </div>
        </div>
    </div>
    </form>
    </div>
<!--<div class="col-lg-12 wrapper" ng-controller="DbController">-->
<!--<div class="col-lg-12 wrapper">
<div class="col-md-6 col-md-offset-3">
<div ng-include src="'templates/form.html'"></div>
<div ng-include src="'templates/editForm.html'"></div>
</div>
<div class="clearfix"></div>
<div class="form-group">
                            <label class="filter-col" style="margin-right:0;" for="pref-perpage">Rows per page:</label>
                            <select id="pref-perpage" class="form-control">
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                                <option value="8">8</option>
                                <option value="9">9</option>
                                <option selected="selected" value="10">10</option>
                                <option value="15">15</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="200">200</option>
                                <option value="300">300</option>
                                <option value="400">400</option>
                                <option value="500">500</option>
                                <option value="1000">1000</option>
                            </select>                                
                        </div>  form group [rows] 
                        <div class="form-group">
                            <label class="filter-col" style="margin-right:0;" for="pref-search">Search:</label>
                            <input type="text" class="form-control input-sm" id="pref-search">
                        </div>
<div class="table-responsive">

<table class="table table-striped table-bordered">
    <nav class="navbar navbar-right">
<div class="navbar-header">
    
<div class="alert alert-default input-group search-box">
<span class="input-group-btn">
    <input type="search" aria-controls="tables_" class="form-control input-sm" placeholder="Search..."><br>
</span>    
</div>
</div>
    </nav>

<tr class="danger">
<th>Schedule ID</th>
<th>Schedule Date</th>
<th>Label</th>
<th>Action</th>
<th></th>
</tr>
<tr>
<td>6281388953184</td>
            <td>PT. test travel - 628119101327</td>
            <td>3in1_01_sa9_reg</td>
            <td>Paket 3in1 Umroh 9 Hari</td>
            <td>2016-12-12 01:00:00</td>
            <td>0000-00-00 00:00:00</td>
<td>{{detail.emp_address}}</td>
<td>
<button class="btn btn-warning" onclick="editInfo(detail.bnum)" title="Edit" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-edit"></span></button>
</td>
<td>
<button class="btn btn-danger" ng-click="deleteInfo(detail)" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>
</td>
</tr>
<tr>
<td>6281388953185</td>
            <td>PT. test travel - 628119101327</td>
            <td>3in1_01_sa9_reg</td>
            <td>Paket 3in1 Umroh 9 Hari</td>
            <td>2016-12-12 01:00:00</td>
            <td>0000-00-00 00:00:00</td>
<td>{{detail.emp_address}}</td>
<td>
<button class="btn btn-warning" onclick="editInfo(detail.bnum)" title="Edit" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-edit"></span></button>
</td>
<td>
<button class="btn btn-danger" ng-click="deleteInfo(detail)" title="Delete"><span class="glyphicon glyphicon-trash"></span></button>
</td>
</tr>
</table>
</div>
</div>-->
<!--</div>-->
<!-- Include controller -->
<!--<script src="js/angular-script.js"></script>-->
