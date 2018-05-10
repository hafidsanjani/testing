<%--
    Document   : main
    Created on : Nov 24, 2016, 11:00:23 AM
    Author     : HafidS
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%--@ include file="cekAuth.jsp" --%>

<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Telkomsel B2B2C Ultimate</title>
        <link rel="icon" type="image/png" href="img/favicon-16x16.png" sizes="16x16" />
        <link type="text/css" href="css/bootstrap.css" rel="stylesheet" />

        <link type="text/css" href="css/style.css" rel="stylesheet" />
        <link type="text/css" href="css/bootstrap-datetimepicker.min.css" rel="stylesheet" />

        <link rel="stylesheet" type="text/css" href="css/dataTables.bootstrap.css">

        <script type="text/javascript" src="js/test.js"></script>
        <script type="text/javascript" src="js/bootstrap.min.js"></script>

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/dataTables.bootstrap.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" src="js/exporting.js"></script>
        <script type="text/javascript" src="js/bootstrap-datetimepicker.js"></script>
        <script language="javascript">
function startTime() {
    var today = new Date();
    var h = today.getHours();
    var m = today.getMinutes();
    var s = today.getSeconds();
    var z = today.getDate();
    var z1 = today.getDay();
    m = checkTime(m);
    s = checkTime(s);
    h = checkTime(h);
    var month = new Array();
    month[0] = "January";
    month[1] = "February";
    month[2] = "March";
    month[3] = "April";
    month[4] = "May";
    month[5] = "June";
    month[6] = "July";
    month[7] = "August";
    month[8] = "September";
    month[9] = "October";
    month[10] = "November";
    month[11] = "December";
var n = month[today.getMonth()];
var y = today.getFullYear();
    document.getElementById('txt').innerHTML =
  z+" "+n+" "+y+" "+ h + ":" + m + ":" + s ;
    var t = setTimeout(startTime, 500);
}
function checkTime(i) {
    if (i < 10) {i = "0" + i};  // add zero in front of numbers < 10
    return i;
}

</script>

    </head>
    <body onload="startTime()">
        <header class="header">
        <%
        String jenis = (String)session.getValue("jenis");
        String menu = request.getParameter("menu");
        String user = (String)session.getValue("usernam");
        String msisdn = (String)session.getValue("msisdna");
        String jnslgn = (String)session.getValue("jnslgn");
        String cpage="";
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

    if (user != null && msisdn != null){
        sql = "select * from session_access where username=? and msisdn=? and session_exp > now() ";
//out.print(sql);
        ps = con.prepareStatement(sql);
        ps.setString(1, user.replaceAll("[^a-zA-Z0-9 :-]", "_"));
        ps.setString(2, msisdn.replaceAll("[^a-zA-Z0-9 :-]", "_"));
        rs = ps.executeQuery();




        if (rs.next()){

        }else{
           response.sendRedirect("index.jsp");
        }




        if (jenis != null){if (jenis.equals("BL")){cpage="informasi.jsp";}else{cpage="informasi1.jsp";}}
        if(menu != null){
            if(jenis != null){if(jenis.equals("BL")){if(menu.equals("cq")) cpage="informasi.jsp";}else{if(menu.equals("cq")) cpage="informasi1.jsp";}}
            if(menu.equals("gf")) cpage="giftPacket.jsp";if(menu.equals("whst")) cpage="whitelist.jsp";if(menu.equals("lg")) cpage="logout.jsp";if(menu.equals("inf3")) cpage="informasi3.jsp";if(menu.equals("req")) cpage="request.jsp";if(menu.equals("pckl")) cpage="package_list.jsp";
            if(menu.equals("rp")) cpage="report.jsp";if(menu.equals("rp1")) cpage="gabungan.jsp";if(menu.equals("rp2")) cpage="cv.jsp";
            if(menu.equals("upl")) cpage="upload.jsp";if(menu.equals("cp")) cpage="forgot.jsp";if(menu.equals("gab")) cpage="gabungan.jsp";if(menu.equals("tr")) cpage="transaksi.jsp";
        }

        %>
        <div class="row">
        <div class="col-lg-4 bglogo">
            <a class="logo" href="#"></a>
        </div>
        <div class="row navtop">
		
        </div>
	<div class="col-lg-4 bglogo1">
            <table align="right">
					<tbody>
					<tr>
					<td><%=user.replaceAll("[^a-zA-Z0-9 :-]", "_")%>&nbsp;|&nbsp;<a href="main.jsp?menu=inf3">Help</a>&nbsp;|&nbsp;</td>
					<td id="txt"></td>
					</tr>
					</tbody>
					</table>        </div>

	
		
        
                </div>
<div class="row navbot">

        </div>

	
        </header>
        <section class="content">
	
        <div class="container">
            <div class="row">
                <div class="col-lg-3">
                    <nav class="navbar hidden-sm" role="navigation">
          <!-- Brand and toggle get grouped for better mobile display -->
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand hidden-lg hidden-sm" href="#">MENU</a>
          </div>
          <!-- Collect the nav links, forms, and other content for toggling -->
          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1" style="overflow:hidden;">
            <ul class="list-left-menu m-bottom">
              <%
                if (jnslgn.equals("API")){
              %>
              <a href="main.jsp?menu=cq"><li><i class="fa fa-users fa-md"></i>Profil</li></a>
	      <a href="main.jsp?menu=rp1"><li><i class="fa fa-users fa-md"></i>Transaction</li></a>
		  <a href="main.jsp?menu=req"><li><i class="fa fa-users fa-md"></i>Request</li></a>
	      <a href="main.jsp?menu=pckl"><li><i class="fa fa-users fa-md"></i>Your Package</li></a>
              <a href="main.jsp?menu=rp"><li><i class="fa fa-users fa-md"></i>Report</li></a>
              <a href="main.jsp?menu=cp"><li><i class="fa fa-users fa-md"></i>Change Password</li></a>
              <a href="logout.jsp"><li><i class="fa fa-users fa-md"></i>Logout</li></a>
              <%
                }else{
              %>
              <a href="main.jsp?menu=cq"><li><i class="fa fa-users fa-md"></i>Profil</li></a>
              <a href="main.jsp?menu=rp1"><li><i class="fa fa-users fa-md"></i>Transaction</li></a>
			  <a href="main.jsp?menu=req"><li><i class="fa fa-users fa-md"></i>Request</li></a>
	      <a href="main.jsp?menu=pckl"><li><i class="fa fa-users fa-md"></i>Your Package</li></a>
              <a href="main.jsp?menu=rp"><li><i class="fa fa-users fa-md"></i>Report</li></a>
              <a href="main.jsp?menu=cp"><li><i class="fa fa-users fa-md"></i>Change Password</li></a>
              <a href="logout.jsp"><li><i class="fa fa-users fa-md"></i>Logout</li></a>
             <!-- <a href="main.jsp?menu=upl"><li><i class="fa fa-users fa-md"></i>Upload</li></a>-->
              <% } %>
              </ul>
          </div>
          <!-- /.navbar-collapse -->
        </nav>
        <nav class="navbar hidden-xs">
          <ul class="visible-sm d-inline">
              <%
                if (jnslgn.equals("API")){
              %>
              <a href="main.jsp?menu=cq"><li><i class="fa fa-users fa-md"></i>Profil</li></a>
	      <a href="main.jsp?menu=rp1"><li><i class="fa fa-users fa-md"></i>Transaction</li></a>
		  <a href="main.jsp?menu=req"><li><i class="fa fa-users fa-md"></i>Request</li></a>
	      <a href="main.jsp?menu=pckl"><li><i class="fa fa-users fa-md"></i>Your Package</li></a>
              <a href="main.jsp?menu=rp"><li><i class="fa fa-users fa-md"></i>Report</li></a>
              <a href="main.jsp?menu=cp"><li><i class="fa fa-users fa-md"></i>Change Password</li></a>
              <a href="logout.jsp"><li><i class="fa fa-users fa-md"></i>Logout</li></a>
              <%
                }else{
              %>
              <a href="main.jsp?menu=cq"><li><i class="fa fa-users fa-md"></i>Profil</li></a>
              <a href="main.jsp?menu=rp1"><li><i class="fa fa-users fa-md"></i>Transaction</li></a>
			  <a href="main.jsp?menu=req"><li><i class="fa fa-users fa-md"></i>Request</li></a>
	      <a href="main.jsp?menu=pckl"><li><i class="fa fa-users fa-md"></i>Your Package</li></a>
              <a href="main.jsp?menu=rp"><li><i class="fa fa-users fa-md"></i>Report</li></a>
              <a href="main.jsp?menu=cp"><li><i class="fa fa-users fa-md"></i>Change Password</li></a>
              <a href="logout.jsp"><li><i class="fa fa-users fa-md"></i>Logout</li></a>
             <!-- <a href="main.jsp?menu=upl"><li><i class="fa fa-users fa-md"></i>upload</li></a>-->
             <%
                }
             %>
                            </ul>
        </nav>
                </div>

                <div class="col-lg-9">                    

                   <jsp:include page="<%=cpage%>" />

                </div>
            </div>
        </div>
        </section>

<div class="row">
            <div class="col-lg-12 footed text-center">Copyright &copy; 2017 PT. Telekomunikasi Selular.</div>
        </div>


        

<script type="text/javascript">
$('.form_date').datetimepicker({
        language:  'id',
        weekStart: 1,
        todayBtn:  1,
                autoclose: 1,
                todayHighlight: 1,
                startView: 2,
                forceParse: 0
    });
</script>
<%
}else{
        response.sendRedirect("index.jsp");
    }
%>
    </body>
</html>