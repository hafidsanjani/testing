<%-- 
    Document   : cekQuota
    Created on : Jan 22, 2018, 1:48:43 PM
    Author     : Hafidsan
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="javax.xml.soap.SOAPMessage"%>
<%@page import="tsel.CekNum"%>
<%@page import="javax.xml.soap.SOAPConnection"%>
<%@page import="javax.xml.soap.SOAPConnectionFactory"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
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
            ArrayList <String> a = null;ArrayList <String> d = null;
            String lbl = "";
            String pckt = "";
            String schid = "";
            String gfd = "";
            String kuotas = "";
            String proses   = (request.getParameter("proses") != null ? request.getParameter("proses") : "");
            String msisdn   = (request.getParameter("msisdn") != null ? request.getParameter("msisdn") : "");
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            String query = "";
            String query1 = "";int b,c =0;
            PreparedStatement ps = null;
            PreparedStatement ps1 = null;
            Context ctx = new InitialContext ();
            String tgls="";
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection(); 
            
            query = " SELECT f1.msisdn, f2.description, f2.kuota FROM (select * from `request` where msisdn=? and co_id=?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.pck_keyword ";
            ps = con.prepareStatement(query);
            ps.setString(1, msisdn);
            ps.setString(2, co_id);
            rs2 = ps.executeQuery();
            if(rs2.next()){
            SOAPConnectionFactory connFac = SOAPConnectionFactory.newInstance(); //buat koneksi SOAP
            SOAPConnection soapConn = connFac.createConnection();
            CekNum cn = new CekNum();
            SOAPMessage reqs = soapConn.call(cn.reqs(msisdn), "http://10.251.38.178:7477/UPCC/Service/ViewProfileP3UPCC");
            cn.getResponseOSB_A(reqs);
            gfd = cn.er;
            if(cn.er.equals("0000")){
                a = cn.tlists;
                d = cn.tlists1;
            }
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
        document.fsearch.action="main.jsp?menu=ckq";
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
                        <label>Msisdn</label>
                        <input type="text" class="form-control" name="msisdn" id="msisdn" placeholder="Ex:628xxx" value="" maxlength="20" onkeypress="return isNumberKey(event)" />
                    </div>
                    <input type="button" class="btn btn-success" onclick="der()" value="Cek Kuota" id="s">
                </div>
                <div class="col-lg-4"></div>
            </div>
            <div class="row">
                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>    
                                                        <th>Msisdn</th>
							<th>Paket</th>
                                                        <th>Sisa Kuota</th>
						</tr>
					</thead>
					
					<tbody>
                                            <%
                                                if(gfd.equals("0000")){
                                                for(int k=0; k<a.size(); k++){
                                                    
                                            %>
						<tr>
							<td><%=msisdn.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                                                        <td><%=a.get(k)%></td>
                                                        <td><%=d.get(k)%></td>
                                                </tr>
                                            <%
                                                }
                                                }
                                            %>
					</tbody>
				</table>
            </div>
        </div>
    </div>
    </form>
    </div>