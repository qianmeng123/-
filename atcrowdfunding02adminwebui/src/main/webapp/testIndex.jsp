<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
    <script src="jquery/jquery-2.1.1.min.js"></script>
    <script>
            var arr=[1,2,3];

            //将数组抓转化为json字符串
             var arrJson=JSON.stringify(arr);

        $(function(){
           $("#btn1").click(function () {
               arrJsonAjx();
           })
        })

          function arrJsonAjx() {
              $.ajax({
                  url:"test/arr.html",
                  data:arrJson,
                  type:"post",
                  dataType:"text",
                  contentType:"application/json;charset=UTF-8",
                  "success":function (resp) {
                      alert(arrJson)
                     alert(resp)
                  },
                  error:function (resp) {
                   alert("error")
                  }
              })
          }
    </script>
</head>
<body>
         <a href="test/ssm.html">点击</a>
       <h1><%=basePath%></h1>
         <hr>
   <button id="btn1">点击</button>




</body>
</html>
