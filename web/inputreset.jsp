<%-- 
    Document   : inputreset
    Created on : Feb 2, 2017, 9:38:06 AM
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
<jsp:useBean id="send" scope="page" class="tsel.SmsSender"></jsp:useBean>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
        String usr = (request.getParameter("username") != null ? request.getParameter("username") : "");
        String nextpage = "reset.jsp";
            String pwd1 = "B2b2c@2017!";
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(pwd1.getBytes());

            byte byteData[] = md.digest();

            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
             sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }
            String aw = sb.toString();
        
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
            
            sql = "select * from  co_user where user=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, usr);
            rs = ps.executeQuery();
            if (rs.next()){
                sql = "update co_user set password=? where user=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, aw);
                ps.setString(2, usr);
                ps.executeUpdate();
                
                sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr);
                ps.setString(2, "2");
                ps.setString(3, "Password "+usr+" Berhasil Di Reset");
                ps.executeUpdate();
                
                String respon = null;
		String from = "Telkomsel";
		String msg = "Password untuk username "+usr+" adalah B2b2c@2017! Silahkan login menggunakan password tersebut dan segera UPDATE Password Anda setelah login.";
		respon = send.smsSend(rs.getString("phone1"), from, msg);
                session.putValue("MSGTOKEN1", "Silahkan Login Menggunakan Password Yang Telah Di Kirim Ke MSISDN Anda"); 
                nextpage = "index.jsp";
            }else{
                sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr);
                ps.setString(2, "2");
                ps.setString(3, "Username "+usr+" Tidak Terdaftar");
                ps.executeUpdate();
                session.putValue("MSGTOKEN3", "Maaf Username Anda Tidak Terdaftar !! "); 
                nextpage = "reset.jsp";
            }
            
            
%>
<jsp:forward  page="<%=nextpage%>" />
