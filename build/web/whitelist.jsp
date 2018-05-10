<%-- 
    Document   : whitelist
    Created on : Dec 28, 2016, 7:58:21 PM
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
    String co_id = (String)session.getValue("coid");
    String jenis = (String)session.getValue("jenis");
            String schdt = "";
            String lbl = "";
            String msisdn = "";
            String pckt = "";
            String schid = "";
            String proses   = (request.getParameter("proses") != null ? request.getParameter("proses") : "");
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
            ResultSet rs2 = null;
            String query = "";
            String query1 = "";
            PreparedStatement ps = null;
            PreparedStatement ps1 = null;
            Context ctx = new InitialContext ();
            String tgls="";
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection(); 
            
            
        
            
            query = "select f1.*, f2.description from (select request_id, co_id, msisdn, pck_keyword, submit_time, execution_time,  status, status_upload, (case when edit_count is null then 0 else edit_count end) edit_count from request where running_id='0' and co_id=?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.pck_keyword ";
            ps = con.prepareStatement(query);
           ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs = ps.executeQuery();
            
            query = "select * from package_list where pck_id in (select pck_id from whitelist_package where co_id=?) ";
            ps = con.prepareStatement(query);
            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs1 = ps.executeQuery();
            
            query = "SELECT now() tgl from dual ";
            ps = con.prepareStatement(query);
            rs2 = ps.executeQuery();
            if(rs2.next()){
                tgls = rs2.getString("tgl").replaceAll("[^a-zA-Z0-9 :-]", "_");
            }
            
            
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
          var cxs = document.fsearch.tgls.value;
          var jns = document.fsearch.jenis.value;
            var cx = document.fsearch.schdt.value;
            var cx1 = cx+":00"; 
            
            var a= document.fsearch.bnum.value;
            var b = a.substring(0,3);
            var c = a.length;
//            alert(c);
            
        if(document.fsearch.schdt.value == ""){
        alert("Scheduler Date Harus Diisi !!!");
        document.fsearch.schdt.focus();
        }else if(document.fsearch.bnum.value == "") {
        alert("Bnumber Harus Diisi !!!");
        document.fsearch.bnum.focus();    
        }else if(b!="628") {
        alert("Bnum yang anda input format nya bukan 628xxxx  !!!");
        document.fsearch.bnum.focus();    
        }else if(c<7) {
        alert("Bnum yang anda input kurang dari 7 digit  !!!");
        document.fsearch.bnum.focus();    
        }else if(document.fsearch.pcket.value == "") {
        alert("Packet Harus Diisi !!!");
        document.fsearch.pcket.focus();    
        }else if(cx1<cxs) {
        alert("Tanggal Schedule tidak boleh lebih kecil dari sekarang  !!!");
        document.fsearch.schdt.focus();    
        }else{
            if(jns=="Bulk"){
                   document.fsearch.action="inputwth1.jsp";
                   }else{
                   document.fsearch.action="inputwth.jsp";  
                   }
            
            document.fsearch.submit();
        }
          //var yt = document.fsearch.schdt.value;
          //alert("syalalalala"+yt);
      }
      
      function uptd(){
           var cxs = document.fsearch.tgls.value;
           var jns = document.fsearch.jenis.value;
            var cx = document.fsearch.schdt_edt.value;
            var cx1 = cx+":00"; 
            var a= document.fsearch.bnum_edt.value;
            var b = a.substring(0,3);
            var c = a.length;
        if(document.fsearch.schdt_edt.value == ""){
        alert("Scheduler Date Harus Diisi !!!");
        document.fsearch.schdt_edt.focus();
        }else if(document.fsearch.bnum_edt.value == "") {
        alert("Bnumber Harus Diisi !!!");
        document.fsearch.bnum_edt.focus();    
        }else if(b!="628") {
        alert("Bnum yang anda input format nya bukan 628xxxx  !!!");
        document.fsearch.bnum.focus();    
        }else if(c<7) {
        alert("Bnum yang anda input kurang dari 7 digit  !!!");
        document.fsearch.bnum.focus();    
        }else if(cx1<cxs) {
        alert("Tanggal Schedule tidak boleh lebih kecil dari sekarang  !!!");
        document.fsearch.schdt.focus();    
        }else if(document.fsearch.pcket_edt.value == "") {
        alert("Packet Harus Diisi !!!");
        document.fsearch.pcket_edt.focus();    
        }else{
            document.fsearch.proses.value="edit";
             if(jns=="Bulk"){
                   document.fsearch.action="inputwth1.jsp";
                   }else{
                   document.fsearch.action="inputwth.jsp";  
                   }
            document.fsearch.submit();
        }
          //var yt = document.fsearch.schdt.value;
          //alert("syalalalala"+yt);
      }
      
      function edt(i){
          document.fsearch.barisss.value=i;
          document.fsearch.proses.value="edit";
          document.fsearch.action="main.jsp?menu=gab&menu1=whst";
          document.fsearch.submit();
      }
      
      function tr(i){
          document.fsearch.proses.value="new";
          document.fsearch.barisss.value=i;
          document.fsearch.action="main.jsp?menu=tr";
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
                <% 
                    if(proses.equals("edit")){
                    String baris   = (request.getParameter("barisss") != null ? request.getParameter("barisss") : "");
                    schdt = (request.getParameter("dtgf_"+baris) != null ? request.getParameter("dtgf_"+baris) : "");
                    msisdn = (request.getParameter("msisdn_"+baris) != null ? request.getParameter("msisdn_"+baris) : "");
                    pckt = (request.getParameter("packet_"+baris) != null ? request.getParameter("packet_"+baris) : "");
                %>
                <div class="col-lg-4">
                    <div class="form-group">
                        <label>Date</label>
                        <div class="input-group date form_date" data-date="" data-date-format="yyyy-mm-dd hh:ii" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd hh:ii">
                            <input class="form-control" size="30" name="schdt_edt" placeholder="Date to Gift" type="text" value="<%=schdt.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" readonly >
                            <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        </div>
                            <input type="hidden" id="dtp_input2" value="" /><br/>
                    </div>
<!--                    <div class="form-group">
                        <label>Label</label>
                        <input type="text" class="form-control" name="lbl" id="lbl" placeholder="label" value="" maxlength="20"  />
                    </div>-->
                    <div class="form-group">
                        <label>B#</label>
                        <input type="text" class="form-control" name="bnum_edt" id="bnum_edt" placeholder="Ex:628xxx" value="<%=msisdn.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" maxlength="20" onkeypress="return isNumberKey(event)" />
                        <input type="hidden" name="tglold" id="tglold" value="<%=schdt.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                        <input type="hidden" name="tgls" id="tgls" value="<%=tgls.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                        <input type="hidden" name="bnumold" id="bnumold" value="<%=msisdn.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                        <input type="hidden" name="jenis" id="jenis" value="<%=jenis.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                    </div>
                    <div class="form-group">
                        <label>Package</label>
                        <select name="pcket_edt" id="pcket_edt" class="form-control" >
                            <option value="">Please Select Your Package</option>
                            <%
                                while (rs1.next()){
                                    if (pckt.equals(rs1.getString("pck_name").replaceAll("[^a-zA-Z0-9 :-]", "_"))){
                             %>  
                                <option value="<%=rs1.getString("pck_name").replaceAll("[^a-zA-Z0-9 :-]", "_")%>" selected="selected"><%=rs1.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></option>
                            <%            
                                    }else{
                            %>  
                                <option value="<%=rs1.getString("pck_name").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs1.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></option>
                            <%
                                }
                                }
                            %>
                        </select>
                    </div>
                    <input type="button" class="btn btn-success" onclick="uptd()" value="UPDATE" id="s">
                </div>
                <%    
                    }else{
                %>
                <div class="col-lg-4">
                    <div class="form-group">
                        <label>Date</label>
                        <div class="input-group date form_date" data-date="" data-date-format="yyyy-mm-dd hh:ii" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd hh:ii">
                            <input class="form-control" size="30" name="schdt" placeholder="Date to Gift" type="text" value="" readonly >
                            <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        </div>
                            <input type="hidden" id="dtp_input2" value="" /><br/>
                    </div>
<!--                    <div class="form-group">
                        <label>Label</label>
                        <input type="text" class="form-control" name="lbl" id="lbl" placeholder="label" value="" maxlength="20"  />
                    </div>-->
                    <div class="form-group">
                        <label>B#</label>
                        <input type="text" class="form-control" name="bnum" id="bnum" placeholder="Ex:628xxx" value="" maxlength="20" onkeypress="return isNumberKey(event)" />
                        <input type="hidden" name="tgls" id="tgls" value="<%=tgls.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                        <input type="hidden" name="jenis" id="jenis" value="<%=jenis.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                    </div>
                    <div class="form-group">
                        <label>Package</label>
                        <select name="pcket" id="pcket" class="form-control" >
                            <option value="">Please Select Your Package</option>
                            <%
                                while (rs1.next()){
                            %>  
                                <option value="<%=rs1.getString("pck_name").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs1.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <input type="button" class="btn btn-success" onclick="der()" value="SUBMIT" id="s">
                </div>
                <% } %>
                <div class="col-lg-4"></div>
            </div>
            <div class="row">
                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>    
                                                        <th>No</th>
							<th>Date Gift</th>
							<th>Msisdn</th>
							<th>Packet</th>
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
                                                        <td><input type="hidden" name="<%="dtgf_"+j%>" value="<%=rs.getString("execution_time").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("execution_time").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="msisdn_"+j%>" value="<%=rs.getString("msisdn").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><input type="hidden" name="<%="reqid_"+j%>" value="<%=rs.getString("request_id").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("msisdn").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><input type="hidden" name="<%="packet_"+j%>" value="<%=rs.getString("pck_keyword").replaceAll("[^a-zA-Z0-9 :-]", "_")%>"><%=rs.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td>
                                                            <% 
                                                                if (rs.getString("status").replaceAll("[^a-zA-Z0-9 :-]", "_").equals("0")){
                                                                    
                                                                
                                                                if (rs.getInt("edit_count")<2){
                                                            %>
                                                            <button class="btn btn-warning" onclick="javascript:edt(<%=j%>)" title="Edit" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-edit"></span></button>
                                                            <button class="btn btn-success" onclick="javascript:tr(<%=j%>)" title="Status Transaksi" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-transfer"></span></button>
                                                            <%
                                                            }else{    
                                                            %>
                                                            <button class="btn btn-warning" onclick="javascript:edt(<%=j%>)" title="Maaf Anda sudah tidak dapat melakukan edit " data-toggle="tooltip" data-placement="top" disabled="disabled"><span class="glyphicon glyphicon-edit"></span></button>
                                                            <button class="btn btn-success" onclick="javascript:tr(<%=j%>)" title="Status Transaksi" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-transfer"></span></button>
                                                            <% 
                                                                }
                                                                }else{
                                                            %>
                                                            <button class="btn btn-warning" onclick="javascript:edt(<%=j%>)" title="Maaf Anda sudah tidak dapat melakukan edit " data-toggle="tooltip" data-placement="top" disabled="disabled"><span class="glyphicon glyphicon-edit"></span></button>
                                                            <button class="btn btn-success" onclick="javascript:tr(<%=j%>)" title="Status Transaksi" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-transfer"></span></button>
                                                            <%
                                                                }
                                                                
                                                                %>
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