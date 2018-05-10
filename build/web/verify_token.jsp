<%-- 
    Document   : verify_token
    Created on : Jan 5, 2017, 4:20:14 PM
    Author     : HafidS 
--%>

<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@ page language = "java" import = "java.io.*, java.util.*, java.text.*, java.sql.*,com.telkomsel.web2sms.corp.*"%>


<%
        String in_token = "";
	String usr_token = "";
	in_token = (request.getParameter("softtoken") != null ? request.getParameter("softtoken") : "");
	String isLogin = (String)session.getValue("ISLOGGEDIN");
        String username = (String)session.getValue("usernam");
        String msisdn = (String)session.getValue("msisdna");
    
	
            String nextpage = "soft_token.jsp";
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection(); 
            String query = "SELECT token from session_access where username=? and msisdn=?  and now() <= session_exp ";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, msisdn);
            rs = ps.executeQuery();

            if(rs.next()) {
            	usr_token = rs.getString("token");
                if (in_token.equals(usr_token) && in_token != null){	  
	     session.putValue("ISLOGGEDIN", "valid");       
            String quer5 = " update session_access set session_exp = date_add(now(), Interval 4800 SECOND), token_status=1 where username=? and msisdn=? ";
            PreparedStatement  ps3 = con.prepareStatement(quer5);
            ps3.setString(1, username);
            ps3.setString(2, msisdn);
            ps3.executeUpdate();
            session.setMaxInactiveInterval(4800);
            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, "1");
                ps.setString(3, "login");
                ps.executeUpdate(); 
            nextpage= "main.jsp";
            }else {
             String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, "1");
                ps.setString(3, "Invalid token");
                ps.executeUpdate();       
             session.putValue("MSGTOKEN", "Invalid token. Try again.");
            nextpage = "soft_token.jsp";
		}
	    } else {
            nextpage= "index.jsp";
            } 
	
%>
<jsp:forward  page="<%=nextpage%>" />

