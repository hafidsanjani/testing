<%-- 
    Document   : inputfrgt
    Created on : Jan 31, 2017, 1:45:06 PM
    Author     : HafidS 
--%>

<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.security.MessageDigest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
//        String usr = (request.getParameter("username") != null ? request.getParameter("username") : "");
        String coid = (String)session.getValue("coid");
        String username = (String)session.getValue("usernam");
        String nextpage = "index.jsp";
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
            String pwd1 = (request.getParameter("password1") != null ? request.getParameter("password1") : "");
            String pwd2 = (request.getParameter("password2") != null ? request.getParameter("password2") : "");
        
        if (pwd2.equals(pwd1)){
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(pwd1.getBytes());

            byte byteData[] = md.digest();

            //convert the byte to hex format method 1
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
             sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }
            String aw = sb.toString();
        
            
            
            sql = "update co_user set password=? where co_id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, aw);
            ps.setString(2, coid);
            ps.executeUpdate();
            
            sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, "2");
                ps.setString(3, "Password "+username+" Berhasil Di Update");
                ps.executeUpdate();
                
            session.putValue("MSGTOKEN2", "Password Anda Berhasil Di Update"); 
            nextpage = "main.jsp?menu=cp";
        }else{
            sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, "2");
                ps.setString(3, "Password yang dimasukan tidak sama");
                ps.executeUpdate();
                
            session.putValue("MSGTOKEN2", "Password yang anda masukan tidak sama"); 
            nextpage = "main.jsp?menu=cp";
        }
            }else{
//              sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
//                ps = con.prepareStatement(sql);
//                ps.setString(1, username);
//                ps.setString(2, "2");
//                ps.setString(3, "Username "+username+" Tidak Terdaftar");
//                ps.executeUpdate();
                session.putValue("MSGTOKEN1", "Maaf Username Anda Tidak Terdaftar !! "); 
                nextpage="index.jsp";
            }
%>
<jsp:forward  page="<%=nextpage%>" />