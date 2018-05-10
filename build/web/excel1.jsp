<%-- 
    Document   : excel1
    Created on : Feb 5, 2017, 9:27:22 AM
    Author     : HafidS 
--%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@page import="java.io.OutputStream"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Export to Excel - Demo</title>
</head>
<body>
    <%
            String coid = (String)session.getValue("coid");
            String namcp1 ="";
            String namcp = (String)session.getValue("namcp");
            if (namcp != null){
               namcp1 = namcp.replace(".", "_").replace(" ", "_");
            }
            String jns = (String)session.getValue("jns");
            String stas = (String)session.getValue("stas");
            String tgl = (String)session.getValue("tgl");
            String tgl1 = (String)session.getValue("tgl1");
            
            HSSFWorkbook wb = new HSSFWorkbook();
                HSSFSheet personSheet = wb.createSheet("Report");
                HSSFRow headerRow = personSheet.createRow(0);
                headerRow.createCell(0).setCellValue("Request ID");
                headerRow.createCell(1).setCellValue("Trx ID");
                headerRow.createCell(2).setCellValue("Pilot Number");
                headerRow.createCell(3).setCellValue("#Bnumber");
                headerRow.createCell(4).setCellValue("Package");
                headerRow.createCell(5).setCellValue("Date");
                headerRow.createCell(6).setCellValue("Status");
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            String query = "";
            String query1 = "";
            PreparedStatement ps = null;
            PreparedStatement ps1 = null;
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection();
            
            if (jns.equals("awal")){
                query = "select f1.*, f2.description from (select * from transaction_log where corp_id=?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";
                ps = con.prepareStatement(query);
                ps.setString(1, coid);
            }else if(jns.equals("all")){
                query = "select f1.*, f2.description from (select * from transaction_log where corp_id=? and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";
                ps = con.prepareStatement(query);
                ps.setString(1, coid);
                ps.setString(2, tgl);
                ps.setString(3, tgl1);
            }else if (stas.equals("Success")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description from (select * from transaction_log where corp_id=? and (status='OK00' or status='0000') and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";   
                    ps = con.prepareStatement(query);
                    ps.setString(1, coid);
                    ps.setString(2, tgl);
                    ps.setString(3, tgl1);
            }else if(stas.equals("Reserved")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description from (select * from transaction_log where corp_id=? and status='0' and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";   
                    ps = con.prepareStatement(query);
                    ps.setString(1, coid);
                    ps.setString(2, tgl);
                    ps.setString(3, tgl1);
            }else if (stas.equals("Accepted")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description from (select * from transaction_log where corp_id=? and status='1' and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";    
                    ps = con.prepareStatement(query);
                    ps.setString(1, coid);
                    ps.setString(2, tgl);
                    ps.setString(3, tgl1);
            }else if (stas.equals("Failed")){
                    session.putValue("jns", "filter");
                    query = "select f1.*, f2.description from (select * from transaction_log where corp_id=? and status not in ('OK00', '0000', '0', '1') and execution_time between ? and ?) f1 inner join (select * from package_list) f2 on f2.pck_name=f1.package ";    
                    ps = con.prepareStatement(query);
                    ps.setString(1, coid);
                    ps.setString(2, tgl);
                    ps.setString(3, tgl1);
            }
                    
            int row = 1;        
            rs = ps.executeQuery();
            while(rs.next()) {
                    String reqid = rs.getString("request_id");
                    String trxid = rs.getString("trx_id");
                    String pltm = rs.getString("pilot");
                    String bnm = rs.getString("bnumber");
                    String pckg = rs.getString("description");
                    String exetm = rs.getString("execution_time");
                    String sts = rs.getString("detail_code");
                    
                    Row dataRow = personSheet.createRow(row);
                    
                    Cell req = dataRow.createCell(0);
                    req.setCellValue(reqid);
                    
                    Cell trx = dataRow.createCell(1);
                    trx.setCellValue(trxid);
                    
                    Cell plt = dataRow.createCell(2);
                    plt.setCellValue(pltm);
                    
                    Cell bmn = dataRow.createCell(3);
                    bmn.setCellValue(bnm);
                    Cell pck = dataRow.createCell(4);
                    pck.setCellValue(pckg);
                    Cell exet = dataRow.createCell(5);
                    exet.setCellValue(exetm);
                    Cell sst = dataRow.createCell(6);
                    sst.setCellValue(sts);
                    
                    row = row + 1;
                }
//        String exportToExcel = request.getParameter("exportToExcel");
//        if (exportToExcel != null
//                && exportToExcel.toString().equalsIgnoreCase("YES")) {
//            response.setHeader("Content-type", "application/vnd.ms-excel");
//            response.setHeader("Content-Disposition", "inline; filename=excel_kjh.xlsx");
            ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
            wb.write(outByteStream);
            byte [] outArray = outByteStream.toByteArray();
            response.setContentType("application/ms-excel");
            response.setContentLength(outArray.length);
            response.setHeader("Expires:", "0"); // eliminates browser caching
            response.setHeader("Content-Disposition", "attachment; filename="+namcp1.replaceAll("[^a-zA-Z0-9 :-]", "")+".xls");
            OutputStream outStream = response.getOutputStream();
            outStream.write(outArray);
            outStream.flush();
//            response.setHeader("Content-Disposition", "inline; <span id="IL_AD6">filename");
//            response.setHeader("Content-Disposition", "inline; <span id="IL_AD6" class="IL_AD">filename</span>="+ "excel.xls");
 
//        }
    
//        response.sendRedirect("excel.jsp"); 
    %>
</body>
</html>
        
