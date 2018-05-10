<%-- 
    Document   : logout
    Created on : Feb 3, 2017, 2:45:08 PM
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

    String coid = (String)session.getValue("coid");
    String usrnm = (String)session.getValue("usernam");
    String msisdn = (String)session.getValue("msisdna");
    String userid = (String)session.getValue("userid");
    String nextpage = "index.jsp";
    
//    out.print(userid);
//    out.print(usrnm);
//    out.print(msisdn);
    
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
            //16kecebong6281285463941
            
            //delete from session_access where user_id='16' and username='kecebong' and msisdn='6281285463941'
            sql = "delete from session_access where user_id=? and username=? and msisdn=? ";
            ps = con.prepareStatement(sql);
            ps.setString(1, userid);
            ps.setString(2, usrnm);
            ps.setString(3, msisdn);
            ps.executeUpdate();
            
            session.invalidate();
            nextpage = "index.jsp";
            
    
%>
<jsp:forward  page="<%=nextpage%>" />