<%-- 
    Document   : informasi1
    Created on : Jan 31, 2017, 2:37:50 PM
    Author     : HafidS 
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
            String name="";
            String yrpckg = "";
            String co_id = (String)session.getValue("coid");
            String msisdn = (String)session.getValue("msisdna");
	    String pilot = (String)session.getValue("pilotnum");
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            ResultSet rs3 = null;
            ResultSet rs4 = null;
            int a=0;
            int b=0,c=0;
            PreparedStatement ps = null;
            String query ="";
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection();
            ArrayList al = new ArrayList();
            ArrayList a2 = new ArrayList();
            
            query = "select * from co_account where co_id=? ";
            ps = con.prepareStatement(query);
            ps.setString(1, co_id);
            rs = ps.executeQuery();
           
            while (rs.next()){
                name = rs.getString("co_name");
                    query = "select * from monetary where mon_id=? ";
                    ps = con.prepareStatement(query);
                    ps.setString(1, rs.getString("mon_id"));
                    rs1 = ps.executeQuery();
                    
                    if (rs1.next()){
                        yrpckg = rs1.getString("name");
                        a = Integer.parseInt(rs1.getString("nominal"));
                    }
                    
                    
//                c = a-b;
//                al.add(c);
//                a2.add(b);
            }
            
            String url = "http://10.250.195.155:8011/Amdocs/RPL/Service/GetBonusService?628119103148|0";
            URL obj = new URL(url);
            HttpURLConnection cons = (HttpURLConnection) obj.openConnection();
            cons.setRequestMethod("POST");
            BufferedReader in = new BufferedReader(new InputStreamReader(cons.getInputStream()));
            String inputLine;
            StringBuffer response1 = new StringBuffer();

            while ((inputLine = in.readLine()) != null){
                response1.append(inputLine);
            }
            in.close();
//            String hasil = response1.toString();
//            out.print(hasil);
            String [] status_charging = response1.toString().split("[\\\\s|\\r\\n]+");
            String resBnum = status_charging[2];
//            out.println("ini adalah "+resBnum);

            for (int i=0; i<status_charging.length; i++){
                if (status_charging[i].equals("T")){
//                    out.print("ini a"+a);
					if(status_charging[i+1].matches("-?[\\d.]+(?:E-?\\d+)?")){
//						out.print("lkj");
						Double scientificDouble = Double.parseDouble(status_charging[i+1]);
						NumberFormat nf = new DecimalFormat("################################################.###########################################");
						String decimalString = nf.format(scientificDouble);
						b = Integer.parseInt(decimalString);
						out.print(b);
					}else{
					double value = Double.parseDouble(status_charging[i+1]);
                    Long L = Math.round(value);
					b = Integer.valueOf(L.intValue());
					}
                    
                   // b = Integer.valueOf(L.intValue());
//                    b = Integer.valueOf(value.intValue());;
//                    out.print("ini a"+b);
                }
               }
                c = a-b;
                out.print("ini c"+c);
                
//                out.print("ini a"+a);
//                out.print("ini b"+b);
//                out.print("ini c"+c);
//                    al.add(c);
//                    a2.add(b);
            
            
            
//            
//            ArrayList valuelist1=(ArrayList)al;
//            Iterator valueIterator = valuelist1.iterator();
//            
//            ArrayList valuelist2=(ArrayList)a2;
//            Iterator valueIterator2 = valuelist2.iterator();
            
            
%>





