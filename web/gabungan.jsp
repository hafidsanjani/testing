<%-- 
    Document   : gabungan
    Created on : Dec 30, 2016, 5:23:49 PM
    Author     : HafidS 
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--<div class="navbar navbar-default">-->
<div class="navbar-collapse collapse">
    <ul class="nav navbar-nav">
        <li class="fa fa-users fa-md"><a href="main.jsp?menu=gab&menu1=whst">Single Transaction</a>
                                </li>
                                <li class="fa fa-users fa-md"><a href="main.jsp?menu=gab&menu1=whst1">Single Transaction Imidiate</a>
                                </li>
                                <li class="fa fa-users fa-md"><a href="main.jsp?menu=gab&menu1=upl">Multi Transaction</a>
                                </li>
                                <%
        String menu = request.getParameter("menu1");
	String cpage="whitelist.jsp";
        if(menu != null){
            if(menu.equals("upl")) cpage="upload.jsp";
            if(menu.equals("whst")) cpage="whitelist.jsp";
            if(menu.equals("rp")) cpage="report.jsp";
            if(menu.equals("whst1")) cpage="imidiate.jsp";
        }
        %>
        </ul>
                            </div>
        <!--</div>-->
                                <div class="col-lg-12">
                                <jsp:include page="<%=cpage%>" flush="true" />
                                </div>
<!--<div class="col-md-12 tab-content" id="tab-1">
                            <div class="bs-example " data-example-id="simple-horizontal-form">
                               <%-- <jsp:include page="whitelist.jsp" flush="true" />
                            </div>
                        </div>
                        option2
                        <div class="col-md-12 tab-content" id="tab-2">
                            <div class="bs-example " data-example-id="simple-horizontal-form">
                                <jsp:include page="upload.jsp" flush="true" />--%>
                            </div>
                        </div>-->
                            