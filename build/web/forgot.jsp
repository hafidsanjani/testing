<%-- 
    Document   : forgot
    Created on : Jan 31, 2017, 11:33:37 AM
    Author     : HafidS 
--%>

<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    </head>
    <%
        String msg = (String)session.getValue("MSGTOKEN2"); 
        String coid = (String)session.getValue("coid");
        String username = (String)session.getValue("usernam");
        String sql="";
            Connection con = null;
            Statement stat = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection();
            sql = "select * from  co_user where user=? and co_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, coid);
            rs = ps.executeQuery();
            if(rs.next()){
    %>
    <body>
        <div>
            <div class="row centered">
                <div class="col-md-4 col-md-offset-4">
                    <div class="panel panel-default">
						<div class="panel-heading">
                            <h3 class="panel-title">Silahkan Masukan Password Baru Anda</h3>
                        </div>
                        <div class="panel-body">
                            <form id="formLogin" autocomplete="off" accept-charset="UTF-8" role="form" method="post" action="inputfrgt.jsp">
                                <fieldset>
                                    <div class="form-group">  
                                        <input class="form-control success" placeholder="Password" name="password1" type="password" value="" required>
                                    </div>
                                    <div class="form-group">
                                        <input class="form-control" placeholder="Ulangi Password" name="password2" type="password" value="" required>
                                    </div>
                                    <% if (msg != null){ %>
                                    <div class="alert alert-dismissable alert-warning">
                                        <%=msg%>
                                    </div>
                                        <% session.removeAttribute("MSGTOKEN2");} %>
                                        
                                    <input class="btn btn-lg btn-danger btn-block" type="submit" value="Update Password">
                                </fieldset>
                            </form>
                                        
						</div>
                    </div>
                </div>
            </div>
        </div>
    </body>
<%
            }else{
               session.putValue("MSGTOKEN1", "Maaf Username Anda Tidak Terdaftar !! "); 
                response.sendRedirect("index.jsp"); 
            }
%>
</html>
