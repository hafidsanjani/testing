<%-- 
    Document   : check
    Created on : Dec 29, 2016, 2:32:11 PM
    Author     : Rojayadi
--%>

<%@page import="com.jay.b2b2c.ultimate.check_monetary"%>
<jsp:useBean id="submit" scope="page" class="com.jay.b2b2c.ultimate.check_monetary"></jsp:useBean>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String user = request.getParameter("user");
    String pass = request.getParameter("pass");
    String client_ip = request.getRemoteAddr();
    String client_id = "";
    String msisdna = "";
    String status = "";
    check_monetary get = new check_monetary();
    Connection con = null;
    out.clear();
    
    try{
        Context ctx = new InitialContext ();
        if(ctx == null)
        throw new Exception("Boom - No Context");
        DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );
        con = ds.getConnection();
        
        String query = "SELECT user.`co_id`, account.`co_pilot` FROM `co_user` user, `co_account` account WHERE user.`user` = ? AND user.`password` = MD5(?) AND user.`co_id` = account.`co_id`";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, user);
        ps.setString(2, pass);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            client_id = rs.getString("co_id");
            msisdna = rs.getString("co_pilot");
            
            String cek_whitelist_ip = "SELECT * FROM `whitelist_ip` WHERE `co_id` = ? AND `ip` = ?";
            PreparedStatement ps_cek_whitelist_ip = con.prepareStatement(cek_whitelist_ip);
            ps_cek_whitelist_ip.setString(1, client_id);
            ps_cek_whitelist_ip.setString(2, client_ip);
            ResultSet rs_cek_whitelist_ip = ps_cek_whitelist_ip.executeQuery();
            if(rs_cek_whitelist_ip.next()){
                //hit api check monetary allowance
                submit.set_pilot(msisdna);
                check_monetary.main();
//                out.print(get.set_ack());
                
                String monetary_allowance = "nothing monetary allowance";
                String[] parts = get.set_ack().split("\\|");
                for(int i=0;i<parts.length;i++){
//                    out.println(i + "." +parts[i]);
                    if(parts[i].equals("T")){
                        int T = i+1;
                        monetary_allowance = parts[T];
                    }
                }
                out.print(monetary_allowance);
            }else{
                out.print("IP Unauthorized");
            }
            ps_cek_whitelist_ip.close();
            ps_cek_whitelist_ip = null;
            rs_cek_whitelist_ip.close();
            rs_cek_whitelist_ip = null;
        }else{
            out.print("Username or Password is wrong");
        }
        ps.close();
        ps = null;
        rs.close();
        rs = null;
        
        con.close();
        con = null;
        out.close();
    }catch(Exception e){e.printStackTrace();out.print(e);}
%>