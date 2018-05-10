<%-- 
    Document   : inputtrx
    Created on : Jan 5, 2017, 9:51:15 AM
    Author     : HafidS 
--%>

<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

            String baris   = (request.getParameter("barisss") != null ? request.getParameter("barisss") : "");
            String reqid = (request.getParameter("reqid_"+baris) != null ? request.getParameter("reqid_"+baris) : "");
            String msisdn = (request.getParameter("msisdn_"+baris) != null ? request.getParameter("msisdn_"+baris) : "");
            String coid = (request.getParameter("coid_"+baris) != null ? request.getParameter("coid_"+baris) : "");
            String runid = (request.getParameter("runid_"+baris) != null ? request.getParameter("runid_"+baris) : "");
            String pckt = (request.getParameter("packet_"+baris) != null ? request.getParameter("packet_"+baris) : "");
    
    
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            PreparedStatement ps = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection(); 
            String query="";
            
            
            query = " update request set status_tombol=? where msisdn=? and request_id=? and running_id=? ";
            ps = con.prepareStatement(query);
            ps.setString(1, "1");
            ps.setString(2, msisdn);
            ps.setInt(3, Integer.parseInt(reqid));
            ps.setInt(4, Integer.parseInt(runid));
            ps.executeUpdate();
            
            int a = Integer.parseInt(runid)+1;
            
            query = " insert into request (request_id, co_id, msisdn, pck_keyword, submit_time, execution_time,  status, status_upload, running_id) values (?,?,?,?,now(), now(),?,?,?) ";
            ps = con.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(reqid));
            ps.setString(2, coid);
            ps.setString(3, msisdn);
            ps.setString(4, pckt);
            ps.setString(5, "0");
            ps.setString(6, "1");
            ps.setInt(7, a);
            ps.executeUpdate();
            
                    
            response.sendRedirect("main.jsp?menu=tr");         
            
            

%>
