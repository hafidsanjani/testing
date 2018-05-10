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
    
    query = "Select f1.*, (case when f1.status='0' then 'Belum Di Eksekusi' else (select detail_code from transaction_log where request_id=f1.request_id and status=f1.status) end) statuss, f2.price from (select * from request where co_id=? and status=?) f1 inner join(SELECT * FROM `package_list`) f2 on f2.pck_name=f1.pck_keyword ";
    // Select f1.*, (case when f1.status='0' then 'Belum Di Eksekusi' else select detail_code from transaction_log where request_id=f1.request_id and status=f1.status end) statuss from (select * from request where co_id=3 and status<>'0') f1 limit 1;
    ps = con.prepareStatement(query);
    ps.setString(1, cid);
    ps.setString(2, "0");
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
                            <th>Request Id</th>
                            <th>Msisdn</th>
                            <th>Packet Keyword</th>
                            <th>Submit Time</th>
                            <th>Execution Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            while(rs.next()){
                        %>
                        <tr>
                            <td><%=rs.getString("request_id").replaceAll("[^a-zA-Z0-9 :-]", "")%></td>
                            <td><%=rs.getString("msisdn").replaceAll("[^a-zA-Z0-9 :-]", "")%></td>
                            <td><%=rs.getString("pck_keyword").replaceAll("[^a-zA-Z0-9 :-]", "")%></td>
                            <td><%=rs.getString("submit_time").replaceAll("[^a-zA-Z0-9 :-]", "")%></td>
                            <td><%=rs.getString("execution_time").replaceAll("[^a-zA-Z0-9 :-]", "")%></td>
                            <td><%=rs.getString("statuss").replaceAll("[^a-zA-Z0-9 :-]", "")%></td>
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
