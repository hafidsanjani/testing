<%-- 
    Document   : transaksi
    Created on : Jan 4, 2017, 5:00:38 PM
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
            String schdt = "";
            String lbl = "";
            String msisdn = "";
            String pckt = "";
            String schid = "";
            String reqid = "";
            String proses   = (request.getParameter("proses") != null ? request.getParameter("proses") : "");
            String baris   = (request.getParameter("barisss") != null ? request.getParameter("barisss") : "");
            if (proses.equals("new")){
            schdt = (request.getParameter("dtgf_"+baris) != null ? request.getParameter("dtgf_"+baris) : "");
            reqid = (request.getParameter("reqid_"+baris) != null ? request.getParameter("reqid_"+baris) : "");
            msisdn = (request.getParameter("msisdn_"+baris) != null ? request.getParameter("msisdn_"+baris) : "");
            session.putValue("schdt", schdt);
            session.putValue("reqid", reqid);
            session.putValue("msisdn", msisdn);
            }else{
                schdt = (String)session.getValue("schdt");
                reqid = (String)session.getValue("reqid");
                msisdn = (String)session.getValue("msisdn");
                    
            }
//            if (proses.equals("new")){
//            schdt = (request.getParameter("schdt_"+baris) != null ? request.getParameter("schdt_"+baris) : "");
//            lbl = (request.getParameter("label_"+baris) != null ? request.getParameter("label_"+baris) : "");
//            schid = (request.getParameter("schid_"+baris) != null ? request.getParameter("schid_"+baris) : "");
//            session.putValue("schdt", schdt);
//            session.putValue("lbl", lbl);
//            session.putValue("schid", schid);
//                
//            }else{
//            schdt = (String)session.getValue("schdt");
//            lbl = (String)session.getValue("lbl");
//            schid = (String)session.getValue("schid");
//                
//            }
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
            
            
        
            
            query = "select * from request where msisdn=? and request_id=? ";
            ps = con.prepareStatement(query);
            ps.setString(1, msisdn.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, reqid.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs = ps.executeQuery();
            
            query = "select * from package_list ";
            ps = con.prepareStatement(query);
            rs1 = ps.executeQuery();
%>
    <script type="text/javascript">
        function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode;
         if (charCode > 31 && (charCode < 48 || charCode > 57 )  )
            return false;

         return true;
      }
      
      function der(){
        if(document.fsearch.schdt.value == ""){
        alert("Scheduler Date Harus Diisi !!!");
        document.fsearch.schdt.focus();
        }else if(document.fsearch.bnum.value == "") {
        alert("Bnumber Harus Diisi !!!");
        document.fsearch.bnum.focus();    
        }else if(document.fsearch.pcket.value == "") {
        alert("Packet Harus Diisi !!!");
        document.fsearch.pcket.focus();    
        }else{
            document.fsearch.action="inputwth.jsp";
            document.fsearch.submit();
        }
          //var yt = document.fsearch.schdt.value;
          //alert("syalalalala"+yt);
      }
      
      function uptd(){
        if(document.fsearch.schdt_edt.value == ""){
        alert("Scheduler Date Harus Diisi !!!");
        document.fsearch.schdt_edt.focus();
        }else if(document.fsearch.bnum_edt.value == "") {
        alert("Bnumber Harus Diisi !!!");
        document.fsearch.bnum_edt.focus();    
        }else if(document.fsearch.pcket_edt.value == "") {
        alert("Packet Harus Diisi !!!");
        document.fsearch.pcket_edt.focus();    
        }else{
            document.fsearch.proses.value="edit";
            document.fsearch.action="inputwth.jsp";
            document.fsearch.submit();
        }
          //var yt = document.fsearch.schdt.value;
          //alert("syalalalala"+yt);
      }
      
      function itr(i){
          document.fsearch.barisss.value=i;
          document.fsearch.action="inputtrx.jsp";
          document.fsearch.submit();
      }
      
      function edt(i){
          document.fsearch.barisss.value=i;
          document.fsearch.proses.value="edit";
          document.fsearch.action="main.jsp?menu=rp1";
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
                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>    
                                                        <th>No</th>
							<th>Msisdn</th>
							<th>Packet</th>
                                                        <th>Error Code</th>
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
                                                        <td><input type="hidden" name="<%="msisdn_"+j%>" value="<%=rs.getString("msisdn").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("msisdn").replaceAll("[^a-zA-Z0-9 :-]", "_")%>
                                                            <input type="hidden" name="<%="reqid_"+j%>" value="<%=rs.getString("request_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%>">
                                                            <input type="hidden" name="<%="coid_"+j%>" value="<%=rs.getString("co_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%>">
                                                            <input type="hidden" name="<%="runid_"+j%>" value="<%=rs.getString("running_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%>">
                                                        </td>
                                                        <td><input type="hidden" name="<%="packet_"+j%>" value="<%=rs.getString("pck_keyword").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("pck_keyword").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="dtgf_"+j%>" value="<%=rs.getString("status").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("status").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td>
                                                            <% if (rs.getString("status_tombol").equals("0")) {%>
                                                            <button class="btn btn-danger" onclick="javascript:itr(<%=j%>)" title="Retry" data-toggle="tooltip" data-placement="top" ><span class="glyphicon glyphicon-refresh"></span></button>
                                                            <% }else{
                                                            %>
                                                            <button class="btn btn-danger" title="Retry" data-toggle="tooltip" data-placement="top" disabled="disabled"><span class="glyphicon glyphicon-refresh"></span></button>
                                                        <% } %>
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
