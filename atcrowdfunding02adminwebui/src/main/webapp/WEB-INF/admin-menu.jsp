<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/admin-head.jsp"%>
<script src="jquery/jquery-2.1.1.min.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script src="script/docs.min.js"></script>
<script src="ztree/jquery.ztree.all-3.5.min.js"></script>
<link rel="stylesheet" href="ztree/zTreeStyle.css">
<script type="text/javascript">
    $(function () {

        ajaxMenu();

        //删除的ajax请求
        $("#confirmBtn").click(function () {
            var id= $("#removeHidden").val();
            $.ajax({
                url:"admin/menu/remove.json",
                data:{
                id:id
                },
                type:"post",
                dataType:"json",
                success:function (resp) {
                    if (resp.operationResult=="SUCCESS"){
                        ajaxMenu();
                        $("#menuConfirmModal").modal("hide");
                    }
                    if (resp.operationResult=="FAILED"){
                        alert(resp.operationMessage);
                    }
                },
                error:function (resp) {
                    alert(resp.status+" "+resp.statusText);
                }
            })
        })


        //点击模态窗口中的保存按钮时ajax发出请求
        $("#menuSaveBtn").click(function () {
            var pid=$("#hiddenForm").val();
            var name=$("#formMenu input[name=name]").val()
            var url=$("#formMenu input[name=url]").val()
            var icon=$("#formMenu input[name=icon]:checked").val()
             $.ajax({
                 url:"admin/menu/add.json",
                 data:{
                     pid:pid,
                     name:name,
                     url:url,
                     icon:icon
                 },
                 type:"post",
                 dataType:"json",
                 success:function (resp) {
                     if (resp.operationResult=="SUCCESS"){
                         ajaxMenu();
                         $("#menuAddModal").modal("hide");
                         $("#formMenu")[0].reset();
                     }
                     if (resp.operationResult=="FAILED"){
                      alert(resp.operationMessage);
                     }
                 },
                 error:function (resp) {
                     alert(resp.status+" "+resp.statusText);
                 }
             })
        })

        //修改模态窗口发送请求
        $("#menuEditBtn").click(function () {
            var id= $("#editModalForm").val();
            var name=$("#menuEditModal input[name=name]").val()
            var url=$("#menuEditModal input[name=url]").val()
            var icon=$("#menuEditModal input[name=icon]:checked").val()
            $.ajax({
                url:"admin/menu/edit.json",
                        data:{
                            id:id,
                    name:name,
                    url:url,
                    icon:icon
                },
                type:"post",
                dataType:"json",
                success:function (resp) {
                    if (resp.operationResult=="SUCCESS"){
                        ajaxMenu();
                        $("#menuEditModal").modal("hide");
                    }
                    if (resp.operationResult=="FAILED"){
                        alert(resp.operationMessage);
                    }
                },
                error:function (resp) {
                    alert(resp.status+" "+resp.statusText);
                }
            })
        })
    });

    //打开删除的模态窗口
       function removeMenu(id) {
           $("#removeHidden").val(id);
           var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
           var currentNode=zTreeObj.getNodeByParam("id",id);
          $("#removeNodeSpan").html("<i class='"+currentNode.icon+"'>"+currentNode.name+"</i>")
           $("#menuConfirmModal").modal("show");
       }


    //回显数据
     function editMenu(id) {
         $("#editModalForm").val(id);
         $("#menuEditModal").modal("show");
         var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
          var currentNode=zTreeObj.getNodeByParam("id",id);
         $("#menuEditModal [name=name]").val(currentNode.name);
         $("#menuEditModal [name=url]").val(currentNode.url);
         $("#menuEditModal [name=icon]").val([currentNode.icon]);

         return false;
     }
    
     
     //展现页面别的ajax请求
    function ajaxMenu() {
        $.ajax({
            url:"admin/do/menu.json",
            type:"post",
            dataType:"json",
            success:function (resp) {
                if (resp.operationResult=="SUCCESS") {

                    var setting={
                        data : {
                            "key": {
                                "url": "maomi"
                            }
                        },
                        view: {
                            addDiyDom: addDiyDom,
                            addHoverDom: addHoverDom,
                            removeHoverDom: removeHoverDom
                        }
                    };
                    var menu=resp.queryData;

                    $.fn.zTree.init($("#treeDemo"), setting, menu);



                }
                if (resp.operationResult=="FAILED"){
                    alert(resp.operationMessage);
                }
            },
            error:function (resp) {
                alert(  resp.status+"  "+resp.statusText)
            }
        })

    }
    

     //添加方法
    function addMenu(id){
        $("#hiddenForm").val(id);
        $("#menuAddModal").modal("show");
        return false;
    }

     //鼠标移入时，加入按钮样式
     function addHoverDom(treeId, treeNode) {
         var  anchorId  = treeNode.tId + "_a";
         var btnGroupId = treeNode.tId + "_btnGrp";
         var id=treeNode.id;
         var btnHtml="";
         //添加
         var addBtn ='<a onclick="addMenu('+id+')" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="javascript:void(0)" title="添加权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';

         //修改
         var  editBtn='<a onclick="editMenu('+id+')" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="javascript:void(0)" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';

         //删除
         var removeBtn='<a onclick="removeMenu('+id+')" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="javascript:void(0)" title="删除权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
          
         if ($("#"+btnGroupId).length>0){
         return false;
         }

         //只有添加
       if (treeNode.level==0){
           btnHtml=addBtn;
           }


        if (treeNode.level==1){
            //添加，修改

            btnHtml=editBtn+" "+addBtn;
            if (treeNode.children.length==0){
                btnHtml+=" "+removeBtn+" ";
            }
           }

        if (treeNode.level==2){
            btnHtml=editBtn+" "+removeBtn+" "+addBtn;
        }

        $("#"+anchorId).after("<span id='"+btnGroupId+"'>"+btnHtml+"</span>");

     }




    //鼠标移开时，清除掉样式按钮
    function removeHoverDom(treeId, treeNode) {
// 拼接按钮组的 id
        var btnGroupId = treeNode.tId + "_btnGrp";
// 移除对应的元素
        $("#"+btnGroupId).remove();
    }


    //有几个节点就执行几次
    function addDiyDom(treeId, treeNode) {
        treeNode.open = true
        // treeId 是整个树形结构附着的 ul 标签的 id
        console.log("treeId="+treeId);
        // 当前树形节点的全部的数据，包括从后端查询得到的 Menu 对象的全部属性
        console.log(treeNode);
        var spanId=treeNode.tId+"_ico";
        $("#"+spanId).removeClass();
        $("#"+spanId).addClass(treeNode.icon);
    };

</script>
<body>


<%@include file="/WEB-INF/admin-nav.jsp"%>
<%@include file="/WEB-INF/admin-left.jsp"%>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

            <div class="panel panel-default">
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限菜单列表 <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title" id="myModalLabel">帮助</h4>
            </div>
            <div class="modal-body">
                <div class="bs-callout bs-callout-info">
                    <h4>没有默认类</h4>
                    <p>警告框没有默认类，只有基类和修饰类。默认的灰色警告框并没有多少意义。所以您要使用一种有意义的警告类。目前提供了成功、消息、警告或危险。</p>
                </div>
                <div class="bs-callout bs-callout-info">
                    <h4>没有默认类</h4>
                    <p>警告框没有默认类，只有基类和修饰类。默认的灰色警告框并没有多少意义。所以您要使用一种有意义的警告类。目前提供了成功、消息、警告或危险。</p>
                </div>
            </div>
            <!--
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              <button type="button" class="btn btn-primary">Save changes</button>
            </div>
            -->
        </div>
    </div>
</div>
<%@include file="/WEB-INF/modal-menu-add.jsp"%>
<%@include file="/WEB-INF/modal-menu-edit.jsp"%>
<%@include file="/WEB-INF/modal-menu-confirm.jsp"%>
</body>
</html>

