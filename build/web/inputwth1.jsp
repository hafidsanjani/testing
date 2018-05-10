<%-- 
    Document   : inputwth1
    Created on : Feb 7, 2017, 5:47:58 PM
    Author     : HafidS 
--%>


<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<jsp:useBean id="send" scope="page" class="tsel.SmsSender"></jsp:useBean>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
            String usr = (String)session.getValue("usernam");
            String prosess = (request.getParameter("proses") != null ? request.getParameter("proses") : "");
            String co_id = (String)session.getValue("coid");
            String msisdn = (String)session.getValue("msisdna");
            String balance = "";
            int blnc;
            int juml=0;
            int gf=0;
            
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rd1 = null;
            ResultSet rd = null;
            PreparedStatement ps = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection(); 
            String query="";
            
            List<String> sids = new ArrayList<String>();
            
            query ="select * from prefix";
            ps = con.prepareStatement(query);
            rs1 = ps.executeQuery();
            while(rs1.next()){
                sids.add(rs1.getString("prefix").replaceAll("[^a-zA-Z0-9 :-]", "_"));
            }
            String allow3[] = sids.toArray(new String[0]);
            
            
            if (prosess.equals("edit")){
                String schdt = (request.getParameter("schdt_edt") != null ? request.getParameter("schdt_edt") : "");
                String bnum = (request.getParameter("bnum_edt") != null ? request.getParameter("bnum_edt") : "");
                String packet = (request.getParameter("pcket_edt") != null ? request.getParameter("pcket_edt") : "");
                String tglold = (request.getParameter("tglold") != null ? request.getParameter("tglold") : "");
//                out.print(tglold);out.print(schdt);
                String bnumold = (request.getParameter("bnumold") != null ? request.getParameter("bnumold") : "");
               // Date startsol = new SimpleDateFormat("dd-MM-yyyy HH:mm").parse(tglold);
               // String hgol = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(startsol);
               // Date starts = new SimpleDateFormat("dd-MM-yyyy HH:mm").parse(schdt);
            //java.sql.Date sqlDates = new java.sql.Date(starts.getTime());
               // String hg = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(starts);
                
            String hg = "";
            if (schdt.length()==21){
            hg = schdt;
            }else{
              hg = schdt+":00";  
            }

                int a;
                String bn = bnum.replaceAll("[^a-zA-Z0-9 :-]", "_").substring(0,5);
                if (Arrays.asList(allow3).contains(bn)){
                query = "SELECT (case when edit_count is null then 0 else edit_count end) edit_count FROM `request` where msisdn=? and execution_time=? ";
                ps = con.prepareStatement(query);
                ps.setString(1, bnumold.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, tglold.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                rs = ps.executeQuery();
                
                if(rs.next()){
                    if (bnum.replaceAll("[^a-zA-Z0-9 :-]", "_").equals(bnumold.replaceAll("[^a-zA-Z0-9 :-]", "_"))){
                        a = rs.getInt("edit_count");
                    }else{
                    a = rs.getInt("edit_count")+1;
                    }
                query = "select kuota from package_list where keyword=?";
                                        ps = con.prepareStatement(query);
                                        ps.setString(1, packet.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                        rd1 = ps.executeQuery();
                                        if (rd1.next()){
                                            gf= rd1.getInt("kuota");
                                        }
                                        juml=juml+gf;
                                        
           query = "select * from co_account where co_id=?";
           ps = con.prepareStatement(query);
           ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
           rd=ps.executeQuery();
           int bln =0;
           if (rd.next()){
               bln=rd.getInt("balance");
           }
           if(juml>bln){
                String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, "3");
                ps.setString(3, "Balance co_id "+co_id.replaceAll("[^a-zA-Z0-9 :-]", "_")+" tidak mencukupi");
                ps.executeUpdate();
               
              %>
                                   <script type="text/javascript" language="JavaScript">
                   
//                    if(confirm("Amount " +kuc+ " yang anda upload tidak terdapat dalam list Amount yang di perbolehkan. Silahkan periksa kembali file yang anda Upload !!!")) document.location = 'main.jsp?menu=whs1';
                    alert("Maaf Balance anda tidak mencukupi !!!");
                    location = 'main.jsp?menu=rp1';
//                    history.go(-1);
                </script>
                
                                   <%
                                   return; 
           }else{
                query = "update request set msisdn=?, execution_time=?, pck_keyword=?, edit_count=? where msisdn=? and execution_time =? and co_id=? ";
                ps = con.prepareStatement(query);
                ps.setString(1, bnum.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(3, packet.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(4, Integer.toString(a).replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(5, bnumold.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(6, tglold.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(7, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.executeUpdate();
                
                 String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, "3");
                ps.setString(3, "user "+usr.replaceAll("[^a-zA-Z0-9 :-]", "_")+" melakukan update terhadap co_id "+co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.executeUpdate();
                
                                        String respon = null;
					String from = "Telkomsel";
					String msg = "Request anda telah kami reserve";
					respon = send.smsSend(bnum.replaceAll("[^a-zA-Z0-9 :-]", "_"), from.replaceAll("[^a-zA-Z0-9 :-]", "_"), msg.replaceAll("[^a-zA-Z0-9 :-]", "_")); 
                
                }
                }
                
                }else{
                String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, "3");
                ps.setString(3, "Msisdn "+bnum.replaceAll("[^a-zA-Z0-9 :-]", "_")+" Not Telkomsel Subscriber");
                ps.executeUpdate();
                    %>
                                   <script type="text/javascript" language="JavaScript">
                    var kuc = "<%=bnum.replaceAll("[^a-zA-Z0-9 :-]", "_")%>";
//                    if(confirm("Amount " +kuc+ " yang anda upload tidak terdapat dalam list Amount yang di perbolehkan. Silahkan periksa kembali file yang anda Upload !!!")) document.location = 'main.jsp?menu=whs1';
                    alert("Msisdn " +kuc+ " Not Telkomsel Subscriber !!!");
                    location = 'main.jsp?menu=rp1';
//                    history.go(-1);
                </script>
                
                                   <%
                                   return; 
                }
            }else{
            
            String schdt = (request.getParameter("schdt") != null ? request.getParameter("schdt") : "");
        //    String lbl = (request.getParameter("lbl") != null ? request.getParameter("lbl") : "");
            String schid = (request.getParameter("schid") != null ? request.getParameter("schid") : "");
            String bnum = (request.getParameter("bnum") != null ? request.getParameter("bnum") : "");
            String packet = (request.getParameter("pcket") != null ? request.getParameter("pcket") : "");
//            Date starts = new SimpleDateFormat("dd-MM-yyyy HH:mm").parse(schdt);
//            //java.sql.Date sqlDates = new java.sql.Date(starts.getTime());
//            String hg = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(starts);
            String hg = schdt+":00";
            String bn = bnum.replaceAll("[^a-zA-Z0-9 :-]", "_").substring(0,5);
            if (Arrays.asList(allow3).contains(bn)){
            query = "select kuota from package_list where keyword=?";
                                        ps = con.prepareStatement(query);
                                        ps.setString(1, packet.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                        rd1 = ps.executeQuery();
                                        if (rd1.next()){
                                            gf= rd1.getInt("kuota");
                                        }
                                        juml=juml+gf;
                                        
           query = "select * from co_account where co_id=?";
           ps = con.prepareStatement(query);
           ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
           rd=ps.executeQuery();
           int bln =0;
           if (rd.next()){
               bln=rd.getInt("balance");
           }
           if(juml>bln){
               String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, "3");
                ps.setString(3, "Balance co_id "+co_id.replaceAll("[^a-zA-Z0-9 :-]", "_")+" tidak mencukupi");
                ps.executeUpdate();
               
              %>
                                   <script type="text/javascript" language="JavaScript">
                   
//                    if(confirm("Amount " +kuc+ " yang anda upload tidak terdapat dalam list Amount yang di perbolehkan. Silahkan periksa kembali file yang anda Upload !!!")) document.location = 'main.jsp?menu=whs1';
                    alert("Maaf Balance anda tidak mencukupi !!!");
                    location = 'main.jsp?menu=rp1';
//                    history.go(-1);
                </script>
                
                                   <%
                                   return;   
               
           }else{
           
                                        
            query = "insert into request (co_id, msisdn, pck_keyword, submit_time, execution_time,  status, status_upload) values (?, ?, ?, now(), ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, bnum.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(3, packet.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(4, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(5, "0");
            ps.setString(6, "1");
            ps.executeUpdate();
            
            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, "3");
                ps.setString(3, "sukses buat Scheduler untuk co_id "+co_id+" ,bnumber "+bnum+" dan tanggal "+hg);
                ps.executeUpdate();
                
                                        String respon = null;
					String from = "Telkomsel";
					String msg = "Request anda telah kami reserve";
					respon = send.smsSend(bnum.replaceAll("[^a-zA-Z0-9 :-]", "_"), from.replaceAll("[^a-zA-Z0-9 :-]", "_"), msg.replaceAll("[^a-zA-Z0-9 :-]", "_"));  
           }
            
            }else{
                String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                ps.setString(2, "3");
                ps.setString(3, "Msisdn "+bnum.replaceAll("[^a-zA-Z0-9 :-]", "_")+" Not Telkomsel Subscriber");
                ps.executeUpdate();
               %>
                                   <script type="text/javascript" language="JavaScript">
                    var kuc = "<%=bnum.replaceAll("[^a-zA-Z0-9 :-]", "_")%>";
//                    if(confirm("Amount " +kuc+ " yang anda upload tidak terdapat dalam list Amount yang di perbolehkan. Silahkan periksa kembali file yang anda Upload !!!")) document.location = 'main.jsp?menu=whs1';
                    alert("Msisdn " +kuc+ " Not Telkomsel Subscriber !!!");
                    location = 'main.jsp?menu=rp1';
//                    history.go(-1);
                </script>
                
                                   <%
                                   return;  
            }
            
            }
            
            response.sendRedirect("main.jsp?menu=rp1"); 
            
            
%>
