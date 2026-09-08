<%@page import="utility.Utility"%>
%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    session.invalidate();
    response.sendRedirect(Utility.url);
    return;
%>