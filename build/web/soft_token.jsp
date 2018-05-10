<%-- 
    Document   : soft_token
    Created on : Jan 5, 2017, 4:19:07 PM
    Author     : HafidS 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml">
    <head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">

    <title> SILAHKAN MASUKAN TOKENNYA </title>
<style type="text/css">

#wrapper {
	width: 100%;	
}
#token {
	width: 497px;
	height: 222px;
	background: url(img/token_main.png) center top;
	margin-left: 15px;
	font-family: Verdana, Geneva, sans-serif;
	font-size: 9px;
	color: #00F;
}
#header-wrapper {
}

#header {
	width: 1000px;
	height: 100px;
	align: center;
}
#page {
	width: 980px;
	margin: 0 auto;
	padding: 0px;
}
#logo {
	width: 1000px;
	height: 768px;
	margin: 0 auto;
	background-repeat: no-repeat;
	background-position: left top;
}

.inputtext { width: 203px; height: 44px; font-size: 24px; text-align:center}
.generatebutton { width: 73px; height: 40px; }
.submitbutton { width: 203px; height: 30px; }

</style>

</head>

<body>
<%
String msg = (String)session.getValue("MSGTOKEN");
//    String msg= "kalalalala";
//    String msg ="";
//ResultSet rsMsisdn = Db.doQuery("select * from co_token_contact where corpid = '"+(String)session.getValue("MYCORPID")+"'");
%>

<div id="wrapper">
<div id="header"></div>
	<!-- end #header -->
  <div id="logo" align="center">
    <table width="497" height="350" border="0" align="center" cellpadding="0" cellspacing="0">
	    <tbody>
        <tr>
	      <td width="497" height="222">
          <div id="token" align="center">            
              <table width="67%" height="191" border="0" align="right">
               <tr>     
               
                <td height="165" valign="bottom">
                  <form id="formToken" name="formToken" method="post" action="verify_token.jsp">
                  <table width="65%" height="74" border="1" cellpadding="5" cellspacing="0">
                    <tr>
                      <td height="44"><input name="softtoken" type="text" class="inputtext" id="softtoken" maxlength="10" required/></td>
                    </tr>
                                     
                    <tr>
                      <td height="30" valign="bottom"><input type="submit" name="Verify" id="Verify" value="Verify Token" class="submitbutton" /></td>
                    </tr>                    
                  </table>                  
                  </form>
                </td>
              </tr><tr>
                <td height="20" valign="top">
                  <table width="203" border="00" cellspacing="0" cellpadding="0">
                    <tr>
                      <td align="center"><font color= "ffffff"><%=msg%></font></td>
                    </tr>
                  </table>
                </td>
              </tr>              
			  </table>
			  
			<script type="text/javascript" language="JavaScript">
			    document.forms['formToken'].elements['softtoken'].focus();
            </script>
            
          </div>
		  <div align = "center">
		     <table>			 
			  <tr>
			    <td align= "center">
			     <p>Telah diterapkannya token untuk meningkatkan security. Apabila belum mendaftarkan msisdn untuk menerima token, dapat menghubungi PIC Telkomsel </p>
				</td> 
			  </tr>
			 </table>
		  </div>
          		  
          </td>
        </tr>
    </tbody></table>
  </div>
</div>
	

</body></html>