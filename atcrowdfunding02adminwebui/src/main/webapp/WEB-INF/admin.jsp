<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
 <%@include file="/WEB-INF/admin-head.jsp"%>
<body>
 <%@include file="/WEB-INF/admin-nav.jsp"%>
<%@include file="/WEB-INF/admin-left.jsp"%>
 <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
     <h1 class="page-header">控制面板</h1>

     <div class="row placeholders">
         <div class="col-xs-6 col-sm-3 placeholder">
             <img data-src="holder.js/200x200/auto/sky" class="img-responsive" alt="Generic placeholder thumbnail">
             <h4>Label</h4>
             <span class="text-muted">Something else</span>
         </div>
         <div class="col-xs-6 col-sm-3 placeholder">
             <img data-src="holder.js/200x200/auto/vine" class="img-responsive" alt="Generic placeholder thumbnail">
             <h4>Label</h4>
             <span class="text-muted">Something else</span>
         </div>
         <div class="col-xs-6 col-sm-3 placeholder">
             <img data-src="holder.js/200x200/auto/sky" class="img-responsive" alt="Generic placeholder thumbnail">
             <h4>Label</h4>
             <span class="text-muted">Something else</span>
         </div>
         <div class="col-xs-6 col-sm-3 placeholder">
             <img data-src="holder.js/200x200/auto/vine" class="img-responsive" alt="Generic placeholder thumbnail">
             <h4>Label</h4>
             <span class="text-muted">Something else</span>
         </div>
     </div>
 </div>
</body>
</html>

