<%-- 
    Document   : request
    Created on : Dec 12, 2017, 8:58:15 AM
    Author     : Hafidsan
--%>

<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Connection con = null;
    Statement stat = null;
    ResultSet rs = null;
    PreparedStatement ps = null;
    String query = "";
    Context ctx = new InitialContext ();
    if(ctx == null)
    throw new Exception("Boom - No Context");
    DataSource ds = (DataSource) ctx.lookup ( "java:comp/env/jdbc/b2b2c_ultimate" );
    con = ds.getConnection();
    String cid = (String)session.getValue("coid");
    
    query = " SELECT f2.* FROM (select * from `whitelist_package` where co_id=?) f1 inner join (select * from package_list) f2 on f2.pck_id=f1.pck_id";
    ps = con.prepareStatement(query);
    ps.setString(1, cid.replaceAll("[^a-zA-Z0-9 :-]", "_"));
    rs = ps.executeQuery();
%>
<script type="text/javascript">
    $(document).ready(function() {
    $('#example').DataTable();
    } );
</script>
<div>
    <form name="" method="POST">
        <div class="row m-bottom">
            <div class="row">
                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th>Description</th>
                            <th>Keyword</th>
                            <th>Price</th>
						</tr>
                    </thead>
                    <tbody>
                        <%
                            while(rs.next()){
                        %>
                        <tr>
                            <td><%=rs.getString("description").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                            <td><%=rs.getString("keyword").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
                            <td><%=rs.getString("price").replaceAll("[^a-zA-Z0-9 :-]", "_")%></td>
						</tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</div>
