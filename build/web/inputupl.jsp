<%-- 
    Document   : inputupl
    Created on : Dec 30, 2016, 11:17:58 AM
    Author     : HafidS 
--%>
<jsp:useBean id="send" scope="page" class="tsel.SmsSender"></jsp:useBean>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
//    String schdt = (request.getParameter("asd") != null ? request.getParameter("asd") : "");
            String usr = (request.getParameter("username") != null ? request.getParameter("username") : "");
            String co_id = (String)session.getValue("coid");
            String user = (String)session.getValue("usernam");
            String msisdn = (String)session.getValue("msisdna");
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            ResultSet rs3 = null;
            ResultSet rs4 = null;
            ResultSet rd = null;
            PreparedStatement ps = null;
            String query ="";
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection();
            List<String> list = new LinkedList<String>(); 
            
            if (user != null && msisdn != null){
            String sql1 = "select * from session_access where username=? and msisdn=? and session_exp > now() ";
            ps = con.prepareStatement(sql1);
            ps.setString(1, user.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, msisdn.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs = ps.executeQuery();




            if (rs.next()){

            }else{
               response.sendRedirect("https://10.2.117.46:1080/ultimate1/"); 
            }
            
            query = "select * from package_list where pck_id in (select pck_id from whitelist_package where co_id=?) ";
            ps = con.prepareStatement(query);
            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs2 = ps.executeQuery();
            List<String> sids = new ArrayList<String>();
            while (rs2.next()){
            sids.add(rs2.getString("pck_name").replaceAll("[^a-zA-Z0-9 :-]", "_"));
            }
            String allow4[] = sids.toArray(new String[0]);
            
            query = "select * from prefix ";
            ps = con.prepareStatement(query);
            rs1 = ps.executeQuery();
            while(rs1.next()){
                list.add(rs1.getString("prefix").replaceAll("[^a-zA-Z0-9 :-]", "_"));
            }
            String allow3[] = list.toArray(new String[0]);
            
            String tgl="";
            query = "SELECT now() tgl from dual";
            ps = con.prepareStatement(query);
            rd = ps.executeQuery();
            if (rd.next()){
                tgl = rd.getString("tgl").replaceAll("[^a-zA-Z0-9 :-]", "_");
            }
                        
//            var cxs1 = cxs.substring(0,4);
//            var cxs2 = cxs.substring(5,7);
//            var cxs3 = cxs.substring(8,10);
//            String tgl1 = tgl.substring(0, 4);
//            String tgl2 = tgl.substring(5, 7);
//            String tgl3 = tgl.substring(8, 10);
//            String tgl4 = tgl.substring(11, 13);
//            String tgl5 = tgl.substring(14, 16);
//            String tgl6 = tgl.substring(17, 19);
//            String tgl7 = tgl1+tgl2+tgl3+tgl4+tgl5+tgl6;
////            int tgl8 = Integer.parseInt(tgl7);
//            Integer ij = Integer.parseInt(tgl7);
            
            
//            List<String> sids1 = new ArrayList<String>();
//            while (rs.next()){
//            sids1.add(rs.getString("prefix"));
//            }
//            String allow4[] = sids1.toArray(new String[0]);
            
            String desti = "/apps/apache-tomcat-8.0.24/webapps/ultimate1/upload";
            
            MultipartRequest m = new MultipartRequest(request, desti); 
//            out.print(m.getFileNames().toString());
            Enumeration files = m.getFileNames();
            String schdt = m.getParameter("schdt");
            
            if (schdt.equals("")){
            %>
                                   <script type="text/javascript" language="JavaScript">
                    
                    alert("Silahkan isi tanggal nya terlebih dahulu !!!");
                    location = 'main.jsp?menu=rp1';
                </script>
                
           <%   
            return;    
            }else{
            
            
//            String lbl = m.getParameter("lbl");
//            Date starts = new SimpleDateFormat("dd-MM-yyyy HH:mm").parse(schdt);
//            String hg = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(starts);
//            out.print(files.toString());
                String hg = schdt+":00";
           
            String upload = (String)files.nextElement();
            String filename = m.getFilesystemName(upload);
            
            String csvF = desti+"/";
            File [] fID = new File(csvF).listFiles();
            BufferedReader br = null;
            String line="";
            String splitBy="[\\|]+" ;
            
            for (File f:fID) {
                String fp = f.getAbsolutePath();
                String fes = fp.substring(fp.lastIndexOf("/")+1, fp.length());
                if (filename.equals(fes)) {
                    try {
                        br = new BufferedReader(new FileReader(fp));
						int op =0;
                        while ((line = br.readLine())!= "") {
							op =op+1;
                            line.replace("\n", "").replace("\r", "");
//                            out.print("yolo"+line+"yolo");
                            if (line.replace("\n", "").replace("\r", "").contains("|")) {
                                String [] negara = line.replace("\n", "").replace("\r", "").split(splitBy);
//                                out.print(negara[0]);
//                                out.print("wew"+negara[1]+"wew");
                                if (negara[0].contains("E+")){
                                 //return
                                    query = "delete from request where co_id=? and execution_time=? and status=? and running_id=? ";
                                    ps = con.prepareStatement(query);
                                    ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(3, "0");
                                    ps.setInt(4, 0);
                                    ps.executeUpdate();
                                    
                                    String er = negara[0];
                                    
                                    String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                    ps = con.prepareStatement(sql);
                                    ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(2, "3");
                                    ps.setString(3, "upload Record "+er.replaceAll("[^a-zA-Z0-9 :-]", "_")+" format nya bukan 628xxx");
                                    ps.executeUpdate();
                                    
                                    
                                    %>
                                    <script type="text/javascript" language="JavaScript">
                                    var er= "<%=er%>";
                                    alert("Record "+er+" format nya bukan 628xxx. Silahkan periksa kembali file yang anda Upload !!!");
                                    location = 'main.jsp?menu=rp1';
                                    </script>                
                                   <%
                                   return;
                                }else{
                                    String nomer = negara[0].replaceAll("[^0-9]", "");
                                    if(nomer.length()>6){
                                if(nomer.replaceAll("[^a-zA-Z0-9 :-]", "_").substring(0, 3).equals("628")){
                                    list.add(nomer); 
                                    //if (Arrays.asList(allow3).contains(bn))
                                    if (Arrays.asList(allow3).contains(negara[0].substring(0, 5))) { //cek prefix telkomsel
                                        if (Arrays.asList(allow4).contains(negara[1])) {//cek packet yang di upload
                                            
                                        
                                            query = "insert into request1 (co_id, msisdn, pck_keyword, submit_time, execution_time,  status, status_upload) values (?, ?, ?, now(), ?, ?, ?)";
                                            ps = con.prepareStatement(query);
                                            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, nomer.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(3, negara[1].replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(4, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(5, "0");
                                            ps.setString(6, "0");
                                            ps.executeUpdate();
                                            
                                            String respon = null;
                                            String from = "Telkomsel";
                                            String msg = "Request anda telah kami reserve ke "+op;
                                            respon = send.smsSend(nomer, from, msg); 
                                            
                                        }else{
                                            
//                                        out.print("ini"+negara[1]+"on");
//                                            out.print(allow4.toString());
//                                            for(int h=0; h<allow4.length;h++){
//                                                out.print(allow4[h]);
//                                            }
                                        
                                            query = "delete from request where co_id=? and execution_time=? and status=? and running_id=? ";
                                            ps = con.prepareStatement(query);
                                            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(3, "0");
                                            ps.setInt(4, 0);
                                            ps.executeUpdate();
                                            String er = negara[1]; 
                                            
                                            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, "3");
                                            ps.setString(3, "Upload Packet "+er.replaceAll("[^a-zA-Z0-9 :-]", "_")+" tidak ada di dalam list packet yang di perbolehkan");
                                            ps.executeUpdate();
//                                    %>
                                    <script type="text/javascript" language="JavaScript">
                                    var er= "<%=er%>";
                                    alert("Packet "+er+" tidak ada di dalam list packet yang di perbolehkan. Silahkan periksa kembali file yang anda Upload !!!");
//                                    history.go(-1);
                                    location = 'main.jsp?menu=rp1';
                                    </script>   
                                   <%
                                   return;  
                                        }
                                    }else{
                                            query = "delete from request where co_id=? and execution_time=? and status=? and running_id=? ";
                                            ps = con.prepareStatement(query);
                                            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(3, "0");
                                            ps.setInt(4, 0);
                                            ps.executeUpdate();
                                            String er = nomer; 
                                            
                                            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, "3");
                                            ps.setString(3, "Upload Msisdn "+er.replaceAll("[^a-zA-Z0-9 :-]", "_")+" bukan Telkomsel Subscriber.");
                                            ps.executeUpdate();
//                                    %>
                                <script type="text/javascript" language="JavaScript">
                                    var er= "<%=er%>";
                                    alert("Msisdn "+er+" bukan Telkomsel Subscriber. Silahkan periksa kembali file yang anda Upload !!!");
//                                    history.go(-1);
                                    location = 'main.jsp?menu=rp1';
                                    </script>   
                                   <%
                                   return;
                                   } 
                                }else{
                                    query = "delete from request where co_id=? and execution_time=? and status=? and running_id=? ";
                                    ps = con.prepareStatement(query);
                                    ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(3, "0");
                                    ps.setInt(4, 0);
                                    ps.executeUpdate();
                                    String er = nomer; 
                                    
                                            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, "3");
                                            ps.setString(3, "Upload Record "+er.replaceAll("[^a-zA-Z0-9 :-]", "_")+" format nya bukan 628xxx.");
                                            ps.executeUpdate();
                                    
                                    %>
                                    <script type="text/javascript" language="JavaScript">
                                    var er= "<%=er%>";
                                    alert("Record "+er+" format nya bukan 628xxx. Silahkan periksa kembali file yang anda Upload !!!");
                                    location = 'main.jsp?menu=rp1';
                                    </script>                
                                   <%
                                   return;
                                }
                                }else{
                                //panjang kurang dari 7
                                    query = "delete from request where co_id=? and execution_time=? and status=? and running_id=? ";
                                    ps = con.prepareStatement(query);
                                    ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(3, "0");
                                    ps.setInt(4, 0);
                                    ps.executeUpdate();
                                    String er = nomer; 
                                    
                                            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, "3");
                                            ps.setString(3, "Upload Record "+er.replaceAll("[^a-zA-Z0-9 :-]", "_")+" panjangnya kurang dari 7 digit.");
                                            ps.executeUpdate();
                                    %>
                                    <script type="text/javascript" language="JavaScript">
                                    var er= "<%=er%>";
                                    alert("Record "+er+" panjangnya kurang dari 7 digit. Silahkan periksa kembali file yang anda Upload !!!");
                                    location = 'main.jsp?menu=rp1';
                                    </script>                
                                   <%
                                   return;
                                }
                        }
                            }else{
                                    query = "delete from request where co_id=? and execution_time=? and status=? and running_id=? ";
                                    ps = con.prepareStatement(query);
                                    ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(3, "0");
                                    ps.setInt(4, 0);
                                    ps.executeUpdate();
                                    String ln = line;
                                    
                                            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, "3");
                                            ps.setString(3, "Record "+ln.replaceAll("[^a-zA-Z0-9 :-]", "_")+" yang anda upload salah format.");
                                            ps.executeUpdate();
                                    
                                %>
                                    <script type="text/javascript" language="JavaScript">
                                    var ln = "<%=ln%>";
                                    alert("Record "+ln+" yang anda upload salah format. Silahkan periksa kembali file yang anda Upload !!!");
                                    location = 'main.jsp?menu=rp1';
                                    </script>               
                                <%
                                 return;
                            }
                        }
                        HashSet<String> set = new HashSet<String>();
                        for (String arrayElement : list){
                            if(!set.add(arrayElement)){
                                //delete record
                                    query = "delete from request where co_id=? and execution_time=? and status=? and running_id=? ";
                                    ps = con.prepareStatement(query);
                                    ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(2, hg.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                    ps.setString(3, "0");
                                    ps.setInt(4, 0);
                                    ps.executeUpdate();
                                    
                                    String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, "3");
                                            ps.setString(3, "Terdapat Duplikasi pada Record MSISDN "+arrayElement);
                                            ps.executeUpdate();
                                %>
                                <script type="text/javascript" language="JavaScript">
                                var kuc = "<%=arrayElement.replaceAll("[^a-zA-Z0-9 :-]", "_")%>";
                                alert("Terdapat Duplikasi pada Record MSISDN " +kuc+ " . Silahkan periksa kembali file yang anda Upload !!!");
                                location = 'main.jsp?menu=rp1';
                                </script>
                                <%
                                return;
                            }
                        }
                        
                    }catch (Exception ex){
                        
                    }
                }
            }
            
            query = "update request1 set status_upload='1' where co_id=? and execution_time like ? and status_upload='0' ";
            ps = con.prepareStatement(query);
            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, hg+"%");
            ps.executeUpdate();
            
            
            String sql = "insert into activity_log (tanggal, username, id_activity, activity_detail) values (now(), ?, ?, ?)";
                                            ps = con.prepareStatement(sql);
                                            ps.setString(1, usr.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.setString(2, "3");
                                            ps.setString(3, "sukses Upload co_id "+co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
                                            ps.executeUpdate();
            }
            
            response.sendRedirect("main.jsp?menu=rp1");
            
}else{
        response.sendRedirect("https://10.2.117.46:1080/ultimate1/");
    }

%>
