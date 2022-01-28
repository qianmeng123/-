<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <base href="<%=basePath%>">

    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/pagelib/pagination.css">

    <script src="jquery/jquery-2.1.1.min.js"></script>
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <script src="script/docs.min.js"></script>
    <script src="jquery/pagelib/jquery.pagination.js"></script>

    <script src="ztree/jquery.ztree.all-3.5.min.js"></script>
   <link rel="stylesheet" href="ztree/zTreeStyle.css">


    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        .tree-closed {
            height : 40px;
        }
        .tree-expanded {
            height : auto;
        }
    </style>

    <script type="text/javascript">
        $(function () {
            $(".list-group-item").click(function(){
                if ( $(this).find("ul") ) {
                    $(this).toggleClass("tree-closed");
                    if ( $(this).hasClass("tree-closed") ) {
                        $("ul", this).hide("fast");
                    } else {
                        $("ul", this).show("fast");
                    }
                }
            });


            window.pageNum=1;
            window.pageSize=5;
            window.keyWord="";

            //第一次到页面时调用一次，默认值
            ajaxPage();

            //查询时调用
            $("#findBtn").click(function () {
                keyWord=$("#keyWord").val();
                ajaxPage(pageNum,pageSize);
            });

              //打开模态窗口
            $("#addRole").click(function () {
               $("#roleModelAdd").modal("show");

            })

            //点击保存按钮，发送ajax请求
            $("#saveBtn").click(function () {
                     var name=$.trim($("#nameText").val());
                     $.ajax({
                         url:"admin/role/save.json",
                         data:{
                         name:name
                         },
                         type:"post",
                         dataType:"json",
                         success:function (resp) { 
                             if (resp.operationResult=="FAILED"){
                                alert(resp.operationMessage);
                             }

                             if (resp.operationResult=="SUCCESS") {

                                 window.pageNum=9999999;



                                 $("#nameText").val("");
                                  ajaxPage()
                                 $("#roleModelAdd").modal("hide");
                             }



                         },
                         error:function (resp) {
                           alert(resp.status+" "+resp.statusText)
                         }

                     })
            })

            //给未生成的元素绑定事件
            $("#tbodyPageDate").on("click",".editBtn",function () {

                //当前单击事件对象的父亲,然后再上一个对象的text
                var name=$(this).parent().prev().text();

                $("#nameEditText").val(name);

                $("#roleModelEdit").modal("show");

                window.id=this.id;
            })

              //点击修改的单击事件
          $("#updateBtn").click(function () {

              var name=$("#nameEditText").val();

              editRole(id,name)

          });

            //全选按钮和单选按钮的逻辑实现
            //全选按钮勾选，单选按钮全部勾选
            $("#allCheckBox").click(function () {
                $(".oneCheckBox").prop("checked",this.checked);
            })

            //所有单选按钮勾选，全选按钮勾选,否则取消
            $("#tbodyPageDate").on("click",".oneCheckBox",function () {

                $("#allCheckBox").prop("checked",$(".oneCheckBox").length==$(".oneCheckBox:checked").length);
            })

            window.array= [];

            //多删
            $("#deleteManyBtn").click(function () {
                deleteMany();
            })

            //点击删除按钮时
            $("#deleteBtn").click(function () {
                 deleteModal();
            })


           //权限分配点击保存按钮时
            $("#roleAuthModal #saveAuthBtn").click(function () {
                // [1]声明一个专门的数组存放 id
                var authIdArray = [];
             // [2]获取 zTreeObj 对象
                var zTreeObj = $.fn.zTree.getZTreeObj("roleAuthModaluL");
              // [3]获取全部被勾选的节点
                var checkedNodes = zTreeObj.getCheckedNodes();
                
                $.each(checkedNodes,function (i,n) {
                    authIdArray.push(n.id);
            })

                  var roleId=$('#roleAuthModal [type=hidden]').val();


                var  AuthIdArray={
                      authId:authIdArray,
                        roleId:[roleId]
                };

                  AuthIdArray=JSON.stringify(AuthIdArray);

                $.ajax({
                    url:"admin/save/authRole.json",
                    data:AuthIdArray,
                    contentType:"application/json;charset=UTF-8",
                    dataType:"json",
                    type:"post",
                    success:function (resp) {
                        if (resp.operationResult=="SUCCESS") {
                            $("#roleAuthModal").modal("hide");
                        }
                        if (resp.operationResult=="FAILED") {
                            alert("出现异常："+resp.operationMessage);
                        }

                    },
                    error:function (resp) {
                        alert("请求失败："+resp.status+" "+resp.statusText);
                    }
                })




                
            })

        });

        //多删
        function deleteMany() {
               if ($(".oneCheckBox:checked").length==0){
                   alert("请至少选择一个进行删除");
                   return false;
               }

            array=[];

            for (var i = 0; i <  $(".oneCheckBox").length ; i++) {

                   var id=$(".oneCheckBox")[i].value;

                var name=$("#"+id).text();

                 var idAndName={"id":id,"name":name};

                array.push(idAndName)

            }

            modelDeleteMessage()

        }


        //单删触发的事件
          function deleteOne(id,name) {
                 var name=$("#"+id).text();
                 var id=id;

                  var nameAndId={"name":name,"id":id};
                array=[];
                array.push(nameAndId);
                  modelDeleteMessage();
          }

        //在删除的模态窗口给用户提示的信息
         function modelDeleteMessage() {
             $("#modalBody").empty();

             for (var i = 0; i <array.length ; i++) {
                 $("#modalBody").append('<div>'+array[i].name+'</div>');
                 $("#roleModalDelete").modal("show");
             }
            
         }

         //ajax删除操作
         function deleteModal() {
            var arrayId=[];
             for (var i = 0; i <array.length ; i++) {
                      var id=array[i].id;
                      arrayId.push(id)
             }
              var arrayJson=JSON.stringify(arrayId)
             console.log(arrayJson)

              $.ajax({
                  url:"admin/role/delete.json",
                  data: arrayJson,
                  type:"post",
                  dataType:"json",
                  contentType:"application/json;charset=utf-8",
                  success:function (resp) {
                      if (resp.operationResult=="FAILED"){
                          alert(resp.message);
                      }

                      if (resp.operationResult=="SUCCESS"){
                          $("#roleModalDelete").modal("hide");
                          ajaxPage();
                      }
                  },
                  error:function (resp) {
                      alert(resp.status+" "+resp.statusText)
                  }
                  
              })
         }

          //修改
          function editRole(id,name) {
        //更新的ajax

            $.ajax({
                url:"admin/role/update.json",
                data:{
                   id:id,
                    name:name
                },
                type:"post",
                dataType:"json",
                success:function (resp) {
                     if (resp.operationResult=="FAILED"){
                         alert(resp.message);
                     }

                     if (resp.operationResult=="SUCCESS"){
                         $("#roleModelEdit").modal("hide");
                         ajaxPage();
                    }
                    
                },
                error:function (resp) {
                    alert(resp.status+" "+resp.statusText)
                }
            })

    }

        //翻页时调用
        function pageSelectCallback(pageIndex, jQuery) {
            // pageIndex 是当前页页码的索引，相对于 pageNum 来说，pageIndex 比 pageNum 小 1
            pageNum = pageIndex + 1;
// 执行页面跳转也就是实现“翻页”
            ajaxPage(pageNum,5);
// 取消当前超链接的默认行为
            return false;
        }

        //分页插件初始化
        function pageProperties() {
            var properties = {
                num_edge_entries: 3, // 边缘页数
                num_display_entries: 5, // 主体页数
                callback: pageSelectCallback, // 用户点击“翻页”按钮之后执行翻页操作的回调函数

                current_page:pageNum-1, //pageNum(页码) 从 1 开始，必须-1 后才可以赋值
                prev_text: "上一页",
                next_text: "下一页",
                items_per_page:pageSize // 每页显示几项
            };
            return properties;
        }

        //分页的ajax函数的封装
        function ajaxPage(){
            $("#allCheckBox").prop("checked",false);
            $.ajax({
                url:"role/do/Page.json",
                data:{
                    pageNum:pageNum,
                    pageSize:pageSize,
                    keyWord:keyWord,
                },
                type:"get",
                dataType:"json",
                success:function (resp) {

                    var html="";
                    //给表格增添数据
                    $.each(resp.queryData.list,function (i,n) {
                        html+='<tr>';
                        html+='<td>'+(i+1)+'</td>';
                        html+='<td><input value="'+n.id+'" type="checkbox" class="oneCheckBox"></td>';
                        html+='<td id="'+n.id+'">'+n.name+'</td>';
                        html+='<td>';
                        html+='<button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check" onclick="authModal('+n.id+')"></i></button>';
                        html+='<button id="'+n.id+'"  type="button" class="btn btn-primary btn-xs editBtn"><i class=" glyphicon glyphicon-pencil"></i></button>';
                        html+='<button  onclick="deleteOne(\''+n.id+'\')" type="button" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
                        html+='</td>';
                        html+='</tr>';
                    });

                    if (resp.queryData.list==null||resp.queryData.list==""){
                        $("#tbodyPageDate").html("<tr><td colspan=4 style='text-align: center'>没有找到想要的数据</td></tr>");
                        $("#Pagination").empty();
                        return false;
                    }

                    $("#tbodyPageDate").html(html);


                    // 调用分页导航条对应的 jQuery 对象的 pagination()方法生成导航条  传入总条数和分页插件初始化的对象
                    $("#Pagination").pagination(resp.queryData.total,pageProperties(pageNum,pageSize));

                },
                error:function (resp) {

                }
            })
        }

        $("tbody .btn-success").click(function(){
            window.location.href = "assignPermission.html";
        });


        function authModal(roleId) {

            $('#roleAuthModal [type=hidden]').val(roleId);

             $.ajax({
                 url:"admin/getAll/authRole.json",
                 dataType:"json",
                 type:"post",
                 success:function (resp) {
                     if (resp.operationResult=="SUCCESS") {
                         var setting = {
                             "data": {
                                 "simpleData": {
                                     // 开启简单 JSON 功能
                                     "enable": true,
                                     // 使用 categoryId 属性关联父节点，不用默认的 pId 了
                                     "pIdKey": "categoryId"
                                 }, "key": {
                                     // 使用 title 属性显示节点名称，不用默认的 name 作为属性名了
                                     "name": "title"
                                 }
                             },
                             "check": {
                                 "enable": true
                             }
                         };


                        $.fn.zTree.init($("#roleAuthModaluL"), setting,resp.queryData);

                         // 获取 zTreeObj 对象
                         var zTreeObj = $.fn.zTree.getZTreeObj("roleAuthModaluL")

                         // 调用 zTreeObj 对象的方法，把节点展开
                         zTreeObj.expandAll(true);

                          showData(roleId);

                         $("#roleAuthModal").modal("show");

                     }
                     if (resp.operationResult=="FAILED") {
                         alert("出现异常："+resp.operationMessage);
                     }

                 },
                 error:function (resp) {
                     alert("请求失败："+resp.status+" "+resp.statusText);
                 }
             })

        }

        function showData(roleId) {

            $.ajax({
                url:"admin/showData/authRole.json",
                data:{
                    roleId:roleId
                },
                dataType:"json",
                type:"post",
                success:function (resp) {
                    if (resp.operationResult=="SUCCESS") {

                        // 获取 zTreeObj 对象
                        var zTreeObj = $.fn.zTree.getZTreeObj("roleAuthModaluL")

                         var authIdArray=resp.queryData;


                        // 6.根据 authIdArray 把树形结构中对应的节点勾选上
                       // ①遍历 authIdArray
                        for(var i = 0; i < authIdArray.length; i++) {
                            var authId = authIdArray[i];
                            // ②根据 id 查询树形结构中对应的节点
                            var treeNode = zTreeObj.getNodeByParam("id", authId);
                            // ③将 treeNode 设置为被勾选
                            // checked 设置为 true 表示节点勾选
                            var checked = true;
                            // checkTypeFlag 设置为 false，表示不“联动”，不联动是为了避免把不该勾选的勾选上
                            var checkTypeFlag = false;
                            // 执行
                            zTreeObj.checkNode(treeNode, checked, checkTypeFlag);
                        }

                    }
                    if (resp.operationResult=="FAILED") {
                        alert("出现异常："+resp.operationMessage);
                    }

                },
                error:function (resp) {
                    alert("请求失败："+resp.status+" "+resp.statusText);
                }
            })


        }

    </script>
</head>

<body>
      <%@include file="/WEB-INF/admin-nav.jsp"%>
     <%@include file="/WEB-INF/admin-left.jsp"%>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="keyWord" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="findBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button id="deleteManyBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" id="addRole"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input  id="allCheckBox" type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody id="tbodyPageDate">

                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <ul id="Pagination" class="pagination">
                                    </ul>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/model-role-add.jsp"%>
<%@include file="/WEB-INF/model-role-edit.jsp"%>
<%@include file="/WEB-INF/model-role-delete.jsp"%>
<%@include file="/WEB-INF/modal-role-auth.jsp"%>
</body>
</html>

