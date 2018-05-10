<%-- 
    Document   : reset
    Created on : Feb 2, 2017, 9:31:28 AM
    Author     : HafidS 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>B2B2C Ultimate</title>
        <link rel="icon" type="image/png" href="img/favicon-16x16.png" sizes="16x16" />
        <link type="text/css" href="css/bootstrap.css" rel="stylesheet" />
        <link rel="stylesheet" href="css/login-style.css" type="text/css"/>
        <script type="text/javascript" src="js/test.js"></script>
    </head>
    <%
        String msg = (String)session.getValue("MSGTOKEN3"); 
    %>
    <body>
        <div class="container block" style="margin-top:10px;">
            <div class="row centered">
                <div class="col-md-4 col-md-offset-4">
                    <div class="panel panel-default">
						<div class="panel-heading">
                            <h3 class="panel-title">Silahkan Masukan Username Anda Untuk Reset Password Anda</h3>
                        </div>
                        <div class="panel-body">
                            <form id="formLogin" autocomplete="off" accept-charset="UTF-8" role="form" method="post" action="inputreset.jsp">
                                <fieldset>
                                    <div class="form-group">  
                                        <input class="form-control success" placeholder="Username" name="username" type="text" required>
                                    </div>
                                    <% if (msg != null){ %>
                                    <div class="alert alert-dismissable alert-warning">
                                        <%=msg%>
                                    </div>
                                        <% session.removeAttribute("MSGTOKEN3");} %>
                                        
                                    <input class="btn btn-lg btn-danger btn-block" type="submit" value="Reset Password">
                                </fieldset>
                            </form>
                                        
						</div>
                    </div>
                </div>
            </div>
            <div style="margin-top: 20px;">Dipersembahkan Oleh:</div>
            <div class='logo'></div>
        </div>
        

        <script type="text/javascript" src="js/bootstrap.min.js"></script>

    </body>
</html>

