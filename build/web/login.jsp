<%-- 
    Document   : login
    Created on : Jan 5, 2017, 2:59:26 PM
    Author     : HafidS 
--%>

<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language = "java" import = "java.io.*, java.util.*, java.text.*, java.sql.*,com.telkomsel.web2sms.corp.*"%>
<%@page import="org.w3c.dom.*, javax.xml.parsers.*" %>
<%--@page language="java" import="org.apache.commons.lang.*"--%>


<jsp:useBean id="lbean" scope="page" class="com.telkomsel.web2sms.corp.loginBean"></jsp:useBean>
<jsp:useBean id="softToken" scope="page" class="com.telkomsel.web2sms.corp.RandomString"></jsp:useBean>
    <%--<jsp:useBean id="send" scope="page" class="com.telkomsel.web2sms.corp.SmsSender"></jsp:useBean>--%>
<jsp:useBean id="send" scope="page" class="tsel.SmsSender"></jsp:useBean>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%--@ include file="content/include/ip.jsp" --%>
<%--@ include file="/autentik.jsp" --%>

<%
//    String nextPage = "index.jsp?err=errorlogin";
//    String username = request.getParameter("username");
//    String password = request.getParameter("password");
String nextPage ="";
  Connection cons = null;
  Statement stats = null;
  ResultSet rss = null;
  String querys="";
  PreparedStatement pss;  
  Context ctx;
  
  ctx = new InitialContext();
                                if(ctx == null)
                                throw new Exception("Boom - No Context");
                                DataSource  ds = (DataSource)ctx.lookup("java:comp/env/jdbc/b2b2c_ultimate");
                                cons = ds.getConnection();
                                
  
//    String NIKS = (String)session.getValue("nik");
//    String curr_login = (String)session.getValue("curr_login");
    String username = (String)session.getValue("usernam");
    String msisdn = (String)session.getValue("msisdna");
    String userid = (String)session.getValue("userid");
    String jnslgn = (String)session.getValue("jnslgn");
    
//    if (jnslgn.equals("API")){
//        String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
//               PreparedStatement ps = cons.prepareStatement(sql);
//                ps.setString(1, username);
//                ps.setString(2, "1");
//                ps.setString(3, "User "+username+" gak punya akses ke web gui. akses nya "+jnslgn);
//                ps.executeUpdate();
//               session.putValue("MSGTOKEN1", "Maaf Anda tidak memiliki Hak akses web GUI."); 
//               nextPage = "index.jsp";
//    }else{
//    String username = (request.getParameter("username") != null ? request.getParameter("username") : "");
//    String msisdn = (request.getParameter("msisdn") != null ? request.getParameter("msisdn") : "");
//    session.putValue("username", username);
//    session.putValue("msisdn", msisdn);
    
//	if((NIKS == null) || (NIKS.equals(""))) {
//		nextPage = "index.jsp?err=errorlogin";
//	}else{
    	String loginStatus = "";
//	loginStatus = lbean.authenticate(NIKS);
//	
//	
//		if(loginStatus.equals("true"))
//    	{
//   		    out.println("kajhsfjkh");
        
        
			session.putValue("MSGTOKEN", "Input token that we send to your msisdn.");
//				if(curr_login.equals("0")) {
				String token = softToken.getUniqueID();
                                        
                                
//                                String quer3 = "insert into activity_log(tanggal, username, id_activity, activity_detail) values (now(), ?, ?,?)"; 
//                                PreparedStatement ps1 = cons.prepareStatement(quer3);
//                                ps1.setString(1, username);
//                                ps1.setString(2, "1");              
//                                ps1.setString(3, "Token Request come from user "+username+" ");                 
//                                ps1.executeUpdate();
//                                out.println("\n hafid userdews ");
        String query = "SELECT token from session_access where username=? and msisdn=? and user_id=?  and now() <= session_exp ";
//        out.print(query);
        pss = cons.prepareStatement(query);
        pss.setString(1, username);
        pss.setString(2, msisdn);
        pss.setString(3, userid);
        rss = pss.executeQuery();
        if (rss.next()){
           nextPage="main.jsp"; 
        }else{
                                String respon = null;
					String from = "Telkomsel";
					String msg = "Token untuk username "+username+" adalah "+token;
//                                       respon = SEND.smsSend(msisdn, from, msg);
//                                        respon = Send.smsSend(msisdn, from, msg);
					respon = send.smsSend(msisdn, from, msg);

                                String quer4 = " select * from session_access where username=? and msisdn=? and user_id=? ";
                                PreparedStatement ps2= cons.prepareStatement(quer4);
                                ps2.setString(1, username);
                                ps2.setString(2, msisdn);
                                ps2.setString(3, userid);
                               ResultSet rs = ps2.executeQuery();

                                if (rs.next()){ //update
                                    String quer5 = " update session_access set session_start = now(), session_exp = date_add(now(), Interval 900 SECOND), token = ? where username=? and msisdn=? and user_id=? ";
                                    PreparedStatement  ps3 = cons.prepareStatement(quer5);
                                    ps3.setString(1, token);
                                    ps3.setString(2, username);
                                    ps3.setString(3, msisdn);
                                    ps3.setString(4, userid);
                                    ps3.executeUpdate();
//                                    out.println("\n hafid ggaa ");
                                } else { //insert
//                                    out.println("\n hafid kebongceng ");
                                   
                                    String quer6 = " insert into session_access (user_id, username, msisdn, session_start, session_exp, token) values (?,?,?, now(), date_add(now(), Interval 900 SECOND), ?)  ";
                                   PreparedStatement ps4 = cons.prepareStatement(quer6);
                                     ps4.setString(1, userid);
                                    ps4.setString(2, username);
                                    ps4.setString(3, msisdn);
                                    ps4.setString(4, token);
                    //                ps4.setString(4, "");
                                    ps4.executeUpdate();
//                                    out.println("\n hafid zxzcv ");
                                }
				
//                                querys = " update session_access set token = ? where nik =? and username=? and msisdn=? "; 
//                                pss = cons.prepareStatement(querys);
//                                pss.setString(1, token);
//                                pss.setString(2, NIKS);
//                                pss.setString(3, username);
//                                pss.setString(4, msisdn);
//                                pss.executeUpdate();
//                                out.println("\n hafid sunj ");
                                
					
//                                        out.println(msg);
					nextPage="soft_token.jsp";							
//				}else{
//					nextPage="access_denied.jsp";
//				}
            				
//        }
                
//    }
        }
//    }
%>

<jsp:forward  page="<%= nextPage %>" />
