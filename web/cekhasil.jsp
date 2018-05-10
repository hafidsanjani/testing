<%-- 
    Document   : cekhasil
    Created on : Mar 24, 2017, 11:42:52 AM
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
            
            query = "select * from cek_hasil  ";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
           
            while (rs.next()){
                
                String url = "http://10.251.38.178:7477/Amdocs/RPL/Service/GetBonusService?"+rs.getString("msisdn")+"|0";
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
//            String resBnum = status_charging[2];
//            out.println("ini adalah "+resBnum);

            for (int i=0; i<status_charging.length; i++){
               if(status_charging[i].equals("Error")){
//                   String afg = status_charging;
                String url1 = "update cek_hasil set kuota=? where msisdn=? ";
                                                ps = con.prepareStatement(url1);
                                                ps.setString(1, status_charging[i]);
                                                ps.setString(2, rs.getString("msisdn"));
                                                ps.executeUpdate();
                
                }else{
                if (status_charging[i].equals("T") || status_charging[i].equals("O")|| status_charging[i].equals("S")){
                   
//                    out.print("ini a"+a);
					if(status_charging[i+1].matches("-?[\\d.]+(?:E-?\\d+)?")){
						Double scientificDouble = Double.parseDouble(status_charging[i+1]);
						NumberFormat nf = new DecimalFormat("################################################.###########################################");
						String decimalString = nf.format(scientificDouble);
						b = Integer.parseInt(decimalString);
                                                String url1 = "update cek_hasil set kuota=? where msisdn=? ";
                                                ps = con.prepareStatement(url1);
                                                ps.setInt(1, b);
                                                ps.setString(2, rs.getString("msisdn"));
                                                ps.executeUpdate();
						out.print(decimalString);
					}else{
//					double value = Double.parseDouble(status_charging[i+1]);
//                                        Long L = Math.round(value);
//					b = Integer.valueOf(L.intValue());
                                        String url1 = "update cek_hasil set kuota=? where msisdn=? ";
                                                ps = con.prepareStatement(url1);
                                                ps.setString(1, status_charging[i]);
                                                ps.setString(2, rs.getString("msisdn"));
                                                ps.executeUpdate();
					}
                    
                    
//                c = a-b;
//                al.add(c);
//                a2.add(b);
            }
            
            
                    
                }
            }
               }
            
            
%>
