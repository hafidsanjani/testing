<%-- 
    Document   : verify_login
    Created on : Jan 31, 2017, 10:20:33 AM
    Author     : HafidS 
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.security.MessageDigest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

String usr = (request.getParameter("username") != null ? request.getParameter("username") : "");
String pwd = (request.getParameter("password") != null ? request.getParameter("password") : "");
String nextpage = "soft_token.jsp";

if (usr!="" && pwd!=""){
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(pwd.getBytes());

        byte byteData[] = md.digest();

        //convert the byte to hex format method 1
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
            ResultSet rs1 = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection();
            
            sql = "select * from co_user where user=? and password=? ";
            ps = con.prepareStatement(sql);
            out.print(sql);
            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, aw.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs =ps.executeQuery();
            
            if (rs.next()){
                sql =" select * from co_account where co_id=?";
                out.print(sql);
                ps = con.prepareStatement(sql);
                ps.setString(1, rs.getString("co_id").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                rs1 = ps.executeQuery();
                if (rs1.next()){
                    if (rs1.getString("co_status").replaceAll("[^a-zA-Z0-9 :-]", "_").equals("S")){
                        
                    sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.setString(2, "1");
                    ps.setString(3, "Account PT "+rs1.getString("co_name").replaceAll("[^a-zA-Z0-9 :-]", "_")+" Status nya Suspend");
                    ps.executeUpdate();
                    session.putValue("MSGTOKEN1", "Maaf Account anda Status nya Suspend. Silahkan Hubungi AM/PIC Telkomsel anda."); 
                    nextpage = "index.jsp";   
                    
                    }else if (rs1.getString("co_status").replaceAll("[^a-zA-Z0-9 :-]", "_").equals("T")){
                        
                    sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.setString(2, "1");
                    ps.setString(3, "Account PT "+rs1.getString("co_name").replaceAll("[^a-zA-Z0-9 :-]", "_")+" Status nya Terminated");
                    ps.executeUpdate();
                    session.putValue("MSGTOKEN1", "Maaf Account anda Status nya Terminate. Silahkan Hubungi AM/PIC Telkomsel anda."); 
                    nextpage = "index.jsp";      
                    }else{
                        
                    
                    session.putValue("jenis", rs1.getString("co_subs_type").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    session.putValue("balance", rs1.getString("balance").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    session.putValue("jnslgn", rs1.getString("co_apps_type").replaceAll("[^a-zA-Z0-9 :-]", "_"));
					session.putValue("namcp", rs1.getString("co_name").replaceAll("[^a-zA-Z0-9 :-]", "_"));
		    session.putValue("pilotnum", rs1.getString("co_pilot").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    session.putValue("usertype", rs.getString("user_type").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                
                    session.putValue("coid", rs.getString("co_id").replaceAll("[^a-zA-Z0-9 :-]", "_"));session.putValue("usernam", rs.getString("user").replaceAll("[^a-zA-Z0-9 :-]", "_"));

                    session.putValue("usrnm", rs.getString("name").replaceAll("[^a-zA-Z0-9 :-]", "_"));session.putValue("userid", rs.getString("user_id").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    session.putValue("msisdna", rs.getString("phone1").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    if ((rs.getString("user_type").replaceAll("[^a-zA-Z0-9 :-]", "_").equals("trx")) && (rs1.getString("co_apps_type").replaceAll("[^a-zA-Z0-9 :-]", "_").equals("API"))){
                    sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.setString(2, "1");
                    ps.setString(3, "Account PT "+rs1.getString("co_name").replaceAll("[^a-zA-Z0-9 :-]", "_")+" Status nya User type nya "+rs.getString("user_type").replaceAll("[^a-zA-Z0-9 :-]", "_")+" dan Jenis apps type nya "+rs1.getString("co_apps_type").replaceAll("[^a-zA-Z0-9 :-]", "_"));
                    ps.executeUpdate();
                    session.putValue("MSGTOKEN1", "Maaf Account anda Tidak Memiliki Hak Akses ke GUI.");
                    nextpage = "index.jsp";
                    }else{
                    nextpage = "login.jsp";
                    }                   
 }
                }
            }else{
                sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, "1");
                ps.setString(3, "Invalid username & password");
                ps.executeUpdate();
               session.putValue("MSGTOKEN1", "Invalid username & password. Try again."); 
               nextpage = "index.jsp";
            }
}

%>
<jsp:forward  page="<%=nextpage%>" />