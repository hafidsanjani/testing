<%-- 
    Document   : cekAuth
    Created on : Feb 21, 2017, 8:46:03 AM
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
<%
    String user = (String)session.getValue("usernam");
    String msisdn = (String)session.getValue("msisdn");
    
            String sql="";
            Connection con = null;
            Statement stat = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection();
            
    if (user != null && msisdn != null){
        sql = "select * from session_access where username=? and msisdn=? and session_exp > now() ";
//        out.print(sql);
        ps = con.prepareStatement(sql);
        ps.setString(1, user);
        ps.setString(2, msisdn);
        rs = ps.executeQuery();
        
        if (rs.next()){
            
        }else{
           response.sendRedirect("https://10.2.117.46:1080/ultimate1/"); 
        }
    }else{
        response.sendRedirect("https://10.2.117.46:1080/ultimate1/");
    }
%>
