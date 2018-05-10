<%-- 
    Document   : upload
    Created on : Dec 29, 2016, 1:49:05 PM
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
<html lang="en">
    <head>
        <meta charset="UTF-8"/>
        <link href="css/fileinput.css" media="all" rel="stylesheet" type="text/css" />
        <script src="js/fileinput.js" type="text/javascript"></script>
    </head>
<%
            String schdt = "";
            String user = (String)session.getValue("usernam");
            String msisdn = (String)session.getValue("msisdna");
            String co_id = (String)session.getValue("coid");
            String lbl = "";
            String schid = "";
            String jenis = (String)session.getValue("jenis");
            String baris   = (request.getParameter("barisss") != null ? request.getParameter("barisss") : "");
            String proses   = (request.getParameter("proses") != null ? request.getParameter("proses") : "");
            if (proses.equals("new")){
            schdt = (request.getParameter("schdt_"+baris) != null ? request.getParameter("schdt_"+baris) : "");
            lbl = (request.getParameter("label_"+baris) != null ? request.getParameter("label_"+baris) : "");
            schid = (request.getParameter("schid_"+baris) != null ? request.getParameter("schid_"+baris) : "");
            session.putValue("schdt", schdt);
            session.putValue("lbl", lbl);
            session.putValue("schid", schid);
                
            }else{
            schdt = (String)session.getValue("schdt");
            lbl = (String)session.getValue("lbl");
            schid = (String)session.getValue("schid");
                
            }
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            String query = "";
            String query1 = "";
            String tgls ="";
            PreparedStatement ps = null;
            PreparedStatement ps1 = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection(); 
            
            if (user != null && msisdn != null){
            String sql = "select * from session_access where username=? and msisdn=? and session_exp > now() ";
            ps = con.prepareStatement(sql);
            ps.setString(1, user.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, msisdn.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs = ps.executeQuery();




            if (rs.next()){

            }else{
               response.sendRedirect("https://10.2.117.46:1080/ultimate1/"); 
            }
            
            
            query = "select * from package_list where pck_id in (select pck_id from whitelist_package where co_id=?) ";
            ps = con.prepareStatement(query);
            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs1 = ps.executeQuery();
            
            query = "select * from request";
            ps = con.prepareStatement(query);
//            ps.setString(1, "13");
            rs = ps.executeQuery();
            
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
      function edt(i){
          document.fsearch.barisss.value=i;
          document.fsearch.proses.value="edit";
          document.fsearch.action="main.jsp?menu=rp1";
          document.fsearch.submit();
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
      
      function er(){
          var cxs = document.fsearch.tgls.value;
          var jns = document.fsearch.jenis.value;
           
          if(document.fsearch.schdt.value == ""){
              alert("Scheduler Date Harus Diisi !!!");
              document.fsearch.schdt.focus();
          }else{
               var cx = document.fsearch.schdt.value;
               var cx1 = cx+":00";
//               alert(cx1);
               if(cx1<cxs){
                   alert("tanggal yang anda input tidak boleh lebih kecil dari tanggal hari ini !!!");
                   document.fsearch.schdt.focus();
               }else{
                   if(jns=="Bulk"){
                   document.fsearch.action="inputupl1.jsp";
                   }else{
                   document.fsearch.action="inputupl.jsp";    
                   }
                    document.fsearch.submit();
               }
          }
      }
      
      $(document).ready(function() {
      $('#example').DataTable();
      } );
      
      
      

      
    </script>
    <body>
    <!--<div class="container kv-main">-->
    <form name="fsearch" method="POST" enctype="multipart/form-data">
    <div class="row m-bottom">
        <div class="col-lg-12">
            <div class="row">
                
                <!--<div class="col-lg-12">-->
                <div class="col-lg-4"></div>
                <div class="col-lg-6">
                    <div class="form-group">
                        <label>Date</label>
                        <div class="input-group date form_date" data-date="" data-date-format="yyyy-mm-dd hh:ii" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd hh:ii" >
                            <input class="form-control" size="30" name="schdt" placeholder="Date to Gift" type="text" value="" readonly >
                            
                            <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                            <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                        </div>
                            <input type="hidden" id="dtp_input2" value="" /><br/>
                            <input type="hidden" name="tgls" id="tgls" value="<%=tgls.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                            <input type="hidden" name="jenis" id="jenis" value="<%=jenis.replaceAll("[^a-zA-Z0-9 :-]", "_")%>" />
                    </div>
<!--                    <div class="form-group">
                        <label>Label</label>
                        <input type="text" class="form-control" name="lbl" id="lbl" placeholder="label" value="" maxlength="20" />
                    </div>-->
                    <div class="form-group">
                        <input id="file-1" type="file" name="asd" class="file" required="required">
                    </div>
                    
                    
                    <input type="button" class="btn btn-success" onclick="er()" value="Upload" id="s">
                    
                    <div class="row">
                        <br>    
                        Note :<br>
                    1. Daftar list paket yang dapat anda gunakan :
                    
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>Package_Name</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while(rs1.next()){
                            %>
                            <tr>
                                <td><%=rs1.getString("pck_name").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                <td><%=rs1.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                            </tr>
                            <%
                                }
                            %>
                         </tbody>   
                        </table>
                         <br>
                         2. format file nya harus ".csv" <br>
                         3. format content file  nya harus  : [Msisdn]|[Package_Name]. contoh nya : 628xxxx|dt_99_s99_reg99.
                                          
                    </div>
                <!--</div>-->
                </div>
                    <div class="col-lg-2">
                        
                        
                    </div>
            </div>
<%--            <div class="row">
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
                                                        <td><input type="hidden" name="<%="dtgf_"+j%>" value="<%=rs.getString("execution_time")%>"><%=rs.getString("execution_time")%></td>
                                                        <td><input type="hidden" name="<%="msisdn_"+j%>" value="<%=rs.getString("msisdn")%>"><%=rs.getString("msisdn")%></td>
                                                        <td><input type="hidden" name="<%="packet_"+j%>" value="<%=rs.getString("pck_keyword")%>"><%=rs.getString("pck_keyword")%></td>
                                                        <td>
                                                            <% if (rs.getInt("edit_count")<2){
                                                            %>
                                                            <button class="btn btn-warning" onclick="javascript:edt(<%=j%>)" title="Edit" data-toggle="tooltip" data-placement="top"><span class="glyphicon glyphicon-edit"></span></button>
                                                            <%
                                                            }else{    
                                                            %>
                                                            <button class="btn btn-warning" onclick="javascript:edt(<%=j%>)" title="Maaf Anda sudah tidak dapat melakukan edit " data-toggle="tooltip" data-placement="top" disabled="disabled"><span class="glyphicon glyphicon-edit"></span></button>
                                                            <% } %>
                                                        </td>
                                                        
                                                </tr>
                                            <%
                                                }
                                            %>
					</tbody>
				</table>
            </div>--%>
        </div>
    </div>
    </form>
        <%
}else{
        response.sendRedirect("https://10.2.117.46:1080/ultimate1/");
    }
%>
    <!--</div>-->
                                        </body>
                                        <script>
                                            $("#file-1").fileinput({
        allowedFileExtensions : ['csv'],
        });
                                        </script>
</html>
