<%-- 
    Document   : report
    Created on : Nov 25, 2016, 3:32:54 PM
    Author     : HafidS 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<%
    String proses = request.getParameter("proses");
    String mulai="";
    String akhir="";
    String stas="";
    String tgl="";
    String tgl1="";
        
//            response.setContentType("application/vnd.ms-excel");
//            response.setHeader("Content-Disposition", "inline; filename="+ "excel.xls");
//            response.setHeader("Content-Disposition", "inline; <span id="IL_AD6">filename");
//            response.setHeader("Content-Disposition", "inline; <span id="IL_AD6" class="IL_AD">filename</span>="+ "excel.xls");
 
//        }
            String coid = (String)session.getValue("coid");
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
            if (proses != null && proses.toString().equalsIgnoreCase("cari")) {
                mulai  = request.getParameter("mulai");
                akhir  = request.getParameter("akhir");
                stas   = request.getParameter("stas");
                tgl =mulai+":00";
                tgl1=akhir+":00";
                session.putValue("stas", stas);
                session.putValue("tgl", tgl);
                session.putValue("tgl1", tgl1);
                if (stas.equals("All")){
                    session.putValue("jns", "all");
                    query = "select f1.*, f2.description, f2.price from (select * from transaction_log where corp_id=? and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";
                    ps = con.prepareStatement(query);
                    ps.setString(1, coid.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.setString(2, tgl.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.setString(3, tgl1.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                }else if (stas.equals("Success")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description, f2.price from (select * from transaction_log where corp_id=? and (status='OK00' or status='0000') and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";   
                    }else if(stas.equals("Reserved")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description, f2.price from (select * from transaction_log where corp_id=? and status='0' and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";   
                    }else if (stas.equals("Accepted")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description, f2.price from (select * from transaction_log where corp_id=? and status='1' and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";    
                    }else if (stas.equals("Failed")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description, f2.price from (select * from transaction_log where corp_id=? and status not in ('OK00', '0000', '0', '1') and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";    
                    }
                    
                    ps = con.prepareStatement(query);
                    ps.setString(1, coid.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.setString(2, tgl.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.setString(3, tgl1.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                
            }else{
            mulai  = "";
            akhir  = "";
            stas   = "";
            session.putValue("jns", "awal");    
            query = "select f1.*, f2.description, f2.price from (select * from transaction_log where corp_id=?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";
            ps = con.prepareStatement(query);
            ps.setString(1, coid.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            }
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
      
      function cr (){
        if(document.fsearch.mulai.value == ""){
        alert("Start Date Harus Diisi !!!");
        document.fsearch.mulai.focus();
        }else if(document.fsearch.akhir.value == "") {
        alert("End Date Harus Diisi !!!");
        document.fsearch.akhir.focus();    
        }else if(document.fsearch.stas.value == "") {
        alert("Status Harus Diisi !!!");
        document.fsearch.stas.focus();    
        }else{
            document.fsearch.proses.value="cari";
            document.fsearch.action="main.jsp?menu=rp";
            document.fsearch.submit();
        } 
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
                        <label>Start Date</label>
                        <div class="input-group date form_date" data-date="" data-date-format="yyyy-mm-dd hh:ii" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd hh:ii">
                            <input class="form-control" size="30" name="mulai" placeholder="Start Date" type="text" value="<%=mulai.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" readonly>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        </div>
                            <input type="hidden" id="dtp_input2" value="" /><br/>
                    </div>
                    <div class="form-group">
                        <label>End Date</label>
                        <div class="input-group date form_date" data-date="" data-date-format="yyyy-mm-dd hh:ii" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd hh:ii">
                            <input class="form-control" size="30" name="akhir" placeholder="End Date" type="text" value="<%=akhir.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" readonly>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select name="stas" id="pcket_edt" class="form-control" >
                            <%
                             if (stas.replaceAll("[^a-zA-Z0-9 :-]", "_").equals("Reserved")){
                            %>
                            <option value="">Status</option>
                            <option value="Reserved" selected="selected">Reserved</option>
                            <option value="Accepted">Accepted</option>
                            <option value="Success">Success</option>
                            <option value="Failed">Failed</option>
                            <option value="All">All</option>
                            <%     
                             }else if(stas.replaceAll("[^a-zA-Z0-9 :-]", "_").equals("Accepted")){
                            %>
                            <option value="">Status</option>
                            <option value="Reserved">Reserved</option>
                            <option value="Accepted" selected="selected">Accepted</option>
                            <option value="Success">Success</option>
                            <option value="Failed">Failed</option>
                            <option value="All">All</option>
                            <%     
                             }else if(stas.replaceAll("[^a-zA-Z0-9 :-]", "_").equals("Success")){
                            %>
                             <option value="">Status</option>
                            <option value="Reserved">Reserved</option>
                            <option value="Accepted">Accepted</option>
                            <option value="Success" selected="selected">Success</option>
                            <option value="Failed">Failed</option>
                            <option value="All">All</option>
                            <%     
                             }else if (stas.replaceAll("[^a-zA-Z0-9 :-]", "_").equals("Failed")){
                            %>
                            <option value="">Status</option>
                            <option value="Reserved">Reserved</option>
                            <option value="Accepted">Accepted</option>
                            <option value="Success">Success</option>
                            <option value="Failed" selected="selected">Failed</option>
                            <option value="All">All</option>
                            <%     
                             }else if (stas.replaceAll("[^a-zA-Z0-9 :-]", "_").equals("All")){
                            %>
                            <option value="">Status</option>
                            <option value="Reserved">Reserved</option>
                            <option value="Accepted">Accepted</option>
                            <option value="Success">Success</option>
                            <option value="Failed">Failed</option>
                            <option value="All" selected="selected">All</option>
                            <%     
                             }else{
                            %>
                            <option value="">Status</option>
                            <option value="Reserved">Reserved</option>
                            <option value="Accepted">Accepted</option>
                            <option value="Success">Success</option>
                            <option value="Failed">Failed</option>
                            <option value="All">All</option>
                            <%
                             }
                            %>
                        </select>
                    </div>
                    <input type="button" class="btn btn-success" onclick="cr()" value="Cari" id="s">
                </div>
                <div class="col-lg-4"></div>
            </div>
            <div class="row">
                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>    
                                                        <th>Request ID</th>
							<th>Trx ID</th>
							<th>Pilot Number</th>
							<th>#Bnumber</th>
							<th>Package</th>
							<th>Price</th>
                                                        <th>Date</th>
                                                        <th>Status</th>
<!--                                                        <th>Download</th>-->
						</tr>
					</thead>
					
					<tbody>
                                            <%
                                                int j =0;
                                                while(rs.next()){
                                                    j=j+1;
                                            %>
						<tr>
							<td><input type="hidden" name="<%="reqid_"+j%>" value="<%=rs.getString("request_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("request_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="trxid_"+j%>" value="<%=rs.getString("trx_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("trx_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="pltnm_"+j%>" value="<%=rs.getString("pilot").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("pilot").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="bnm_"+j%>" value="<%=rs.getString("bnumber").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("bnumber").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="pckg_"+j%>" value="<%=rs.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
														<td><input type="hidden" name="<%="prc_"+j%>" value="<%=rs.getString("price").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("price").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="exetm_"+j%>" value="<%=rs.getString("execution_time").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("execution_time").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="sts_"+j%>" value="<%=rs.getString("detail_code").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("detail_code").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        
						</tr>
                                            <%
                                                }
                                            %>
					</tbody>
				</table>
                                    <a href="excel1.jsp">Export to Excel</a>   
            </div>
        </div>
    </div>
    </form>
    </div>