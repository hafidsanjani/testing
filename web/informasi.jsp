<%-- 
    Document   : informasi
    Created on : Nov 24, 2016, 11:10:00 AM
    Author     : HafidS 
--%>


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
            String user = (String)session.getValue("usernam");
            String usrnm ="";
            String pltnm ="";
            String tkn ="";
            String rtp = "";
            String nmcrp = "";
            String almt = "";
            String telp = "";
            String sisa = "";
            
            Connection con = null;
            Statement stat = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            ResultSet rs3 = null;
            ResultSet rs4 = null;
            double a;
            double b,c;
            PreparedStatement ps = null;
            String query ="";
            Context ctx = new InitialContext ();
            if(ctx == null)
            throw new Exception("Boom - No Context");

            DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );  // tempat penyimpanan didalam tomcat 

            con = ds.getConnection();
            ArrayList al = new ArrayList();
            ArrayList a2 = new ArrayList();
            
            query = "SELECT f1.user, f2.co_pilot, f1.phone1, (case when f2.co_subs_type = 'BL' then 'Bulk' else 'Moneytery' end)jenis, f2.co_name, f2.co_address, f2.limit, f2.balance, (case when f2.limit-f2.balance = 0 then f2.balance else f2.balance end) sisa FROM (select * from `co_user`where co_id=? and user=?) f1 "+
                    " inner join (select * from co_account) f2 on f2.co_id=f1.co_id ";
            ps = con.prepareStatement(query);
            ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, user.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            rs = ps.executeQuery();
			
			query = "select f3.description from (select * from `co_user`where co_id=? and user=?) f1 inner join (select * from whitelist_package) f2 on f2.co_id=f1.co_id inner join (select * from package_list) f3 on f3.pck_id=f2.pck_id";
			ps = con.prepareStatement(query);
			ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, user.replaceAll("[^a-zA-Z0-9 :-]", "_"));
			rs1 = ps.executeQuery();
			
			
			query = "select f2.ip from (select * from `co_user`where co_id=? and user=?) f1 inner join (select * from whitelist_ip) f2 on f2.co_id=f1.co_id";
			ps = con.prepareStatement(query);
			ps.setString(1, co_id.replaceAll("[^a-zA-Z0-9 :-]", "_"));
            ps.setString(2, user.replaceAll("[^a-zA-Z0-9 :-]", "_"));
			rs2 = ps.executeQuery();
            
            while (rs.next()){
                usrnm =rs.getString("user").replaceAll("[^a-zA-Z0-9 :-]", "_");
                pltnm =rs.getString("co_pilot").replaceAll("[^a-zA-Z0-9 :-]", "_");
                tkn =rs.getString("phone1").replaceAll("[^a-zA-Z0-9 :-]", "_");
                rtp = rs.getString("jenis").replaceAll("[^a-zA-Z0-9 :-]", "_");
                nmcrp = rs.getString("co_name").replaceAll("[^a-zA-Z0-9 :-]", "_");
                almt = rs.getString("co_address").replaceAll("[^a-zA-Z0-9 :-]", "_");
                telp = rs.getString("phone1").replaceAll("[^a-zA-Z0-9 :-]", "_");
                sisa = rs.getString("sisa").replaceAll("[^a-zA-Z0-9 :-]", "_");
                a =rs.getDouble("limit");
                b = rs.getDouble("balance");
                c = a-b;
                al.add(c);
                a2.add(b);
            }
            
            ArrayList valuelist1=(ArrayList)al;
            Iterator valueIterator = valuelist1.iterator();
            
            ArrayList valuelist2=(ArrayList)a2;
            Iterator valueIterator2 = valuelist2.iterator();
            
            
%>


<script type="text/javascript">
var dataValues = <% for (int i = 0; i < valuelist1.size(); i++) { %><%= valuelist1.get(i) %><% } %>;
var dataValues2 = <% for (int i = 0; i < valuelist2.size(); i++) { %><%= valuelist2.get(i) %><% } %> ;

$(function () {

    $(document).ready(function () {
        Highcharts.setOptions({
     colors: ['#ff3300', '#1aff1a']
    });

        // Build the chart
        $('#containerew678').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie'
            },
            title: {
                text: 'Statistik Usage'
            },
//            tooltip: {
//                pointFormat: '{series.name}: <b>{point.percentage:.1f}</b>'
//            },
tooltip: {
//            formatter: function() {
//                return Highcharts.numberFormat(this.percentage, 2) + '%<br />' + '<b>' + this.point.name + '</b><br />Sebesar ' + Highcharts.numberFormat(this.y) +' Mb';
//            }
        pointFormat: "{point.percentage} %<br /><b>{point.name}</b><br />Sebesar  {point.y} Mb"
        },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
//                        tooltip:{
                            format: "{point.percentage} %<br /><b>{point.name}</b><br />Sebesar  {point.y} Mb"
//                        }
//			formatter: function() {
//                return Highcharts.numberFormat(this.percentage, 2) + '%<br />' + '<b>' + this.point.name + '</b><br />Sebesar ' + Highcharts.numberFormat(this.y) +' Mb';
//            }                    
           },
                    showInLegend: true
                }
            },
            series: [{
                name: 'Brands',
                colorByPoint: true,
                data: [
                    {
                    
                    name: 'Pemakaian',
                    y: dataValues
                }, {
                    name: 'Sisa',
                    y: dataValues2
                }
            ]
            }]
        });
    },
function(chart) {
         chart.tooltip.refresh(chart.series[dataValues2].data[dataValues]);   
    });
});
        </script>
    
<div>
        
<form name="fsearch" method="POST" >   
<input type="hidden" name="kegiatan">
<div class="row m-bottom">  
<div class="col-lg-12">
    <div class="row">
        <div class="col-lg-6">
			<table>
				<tbody>
					<tr>
						<td width="60%">Nama Perusahaan</td>
						<td width="5%">:</td>
						<td><%=nmcrp.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
					</tr>
					<tr>
						<td width="60%">Alamat</td>
						<td width="5%">:</td>
						<td><%=almt.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
					</tr>
					<tr>
						<td width="60%">Telepon</td>
						<td width="5%">:</td>
						<td><%=telp.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
					</tr>
					<tr>
						<td width="60%">Sisa Kuota lalalalalala</td>
						<td width="5%">:</td>
						<td><%=sisa.replaceAll("[^a-zA-Z0-9 :-]", "_")%> Mb</td>
					</tr>
					<tr>
						<td width="60%">Retailer Type</td>
						<td width="5%">:</td>
						<td><%=rtp.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
					</tr>
				</tbody>
			</table>
		</div>
        <div class="col-lg-6">
			<table>
				<tbody>
					<tr>
						<td width="35%">Username</td>
						<td width="5%">:</td>
						<td><%=usrnm.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
					</tr>
					<tr>
						<td width="35%">Pilot Number</td>
						<td width="5%">:</td>
						<td><%=pltnm.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
					</tr>
					<tr>
						<td width="35%">Penerima Token</td>
						<td width="5%">:</td>
						<td><%=tkn.replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
					</tr>
					<tr>
						<td width="35%">Whitelist Package</td>
						<td width="5%">:</td>
						<td>
						<%
							while(rs1.next()){
						%>
						- <%=rs1.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></br>
						<%
							}
						%>
						</td>
					</tr>
					<tr>
						<td width="35%">Whitelist IP</td>
						<td width="5%">:</td>
						<td>
						<%
							while(rs2.next()){
						%>
						~ <%=rs2.getString("ip").replaceAll("[^a-zA-Z0-9 :-]", "_")%></br>
						<%
							}
						%>
						</td>
					</tr>
					
				</tbody>
			</table>
        </div>
       
</div>
    <div class="row">
    <div class="row m-bottom">  
                  <div id="containerew678" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
 </div>
    </div>
    
</div>
</div>


</form>
</div>