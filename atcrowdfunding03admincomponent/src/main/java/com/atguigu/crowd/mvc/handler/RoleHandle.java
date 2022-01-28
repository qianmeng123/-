package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.entity.Auth;
import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.service.api.AuthService;
import com.atguigu.crowd.service.api.RoleService;
import com.atguigu.crowd.util.ResultEntity;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;


@Controller
public class RoleHandle {

    @Autowired
    private RoleService roleService;

    @Autowired
    private AuthService authService;

    /**
     * 分配权限的保存
     */

    @ResponseBody
    @RequestMapping("/admin/save/authRole.json")
    public ResultEntity<String> saveAuth(@RequestBody Map<String,List<Integer>> map){
              authService.saveAuth(map);
         return ResultEntity.successWithoutData();
    }


    /**
     *复选框的默认勾选
     */
    @ResponseBody
    @RequestMapping("/admin/showData/authRole.json")
    public ResultEntity<List<Integer>> showChecked(Integer roleId){
          List<Integer> listAuth=authService.getAuthId(roleId);
       return ResultEntity.successWithData(listAuth);
    }



    /**
     * 权限展现
     */
    @ResponseBody
    @RequestMapping("/admin/getAll/authRole.json")
    public ResultEntity<List<Auth>> getAuth(){
           List<Auth> listAuth=authService.getAllAuth();
           return ResultEntity.successWithData(listAuth);
    }




    /**
     * 删除
     * @param list
     * @return
     */
    @RequestMapping("/admin/role/delete.json")
    @ResponseBody
     public ResultEntity<String> deleteRole(@RequestBody List<Integer> list){
          roleService.deleteRole(list);
          ResultEntity<String> resultEntity=ResultEntity.successWithoutData();
             return resultEntity;
    }


    /**
     * 修改
     * @param role
     * @return
     */
    @RequestMapping("/admin/role/update.json")
    @ResponseBody
    public ResultEntity<String> updateRole(Role role){
            roleService.updateRole(role);
            ResultEntity<String> resultEntity=ResultEntity.successWithoutData();
            return  resultEntity;

    }

    /**
     * 增添操作
     */
    @RequestMapping("/admin/role/save.json")
    @ResponseBody
    public ResultEntity<String>  saveRole(Role role){
            roleService.saveRole(role);
             ResultEntity<String> resultEntity=ResultEntity.successWithoutData();
         return resultEntity;
    }


    /**
     * 分页
      * @return
     */
    @RequestMapping("/role/do/Page.json")
    @ResponseBody
    public ResultEntity<PageInfo<Role>> doPage(
            @RequestParam(value = "keyWord",defaultValue = "") String keyWord,
            @RequestParam(value = "pageNum",defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize",defaultValue = "10") Integer pageSize){



        PageInfo<Role>  pageInfoList = roleService.getPageInfo(keyWord,pageNum,pageSize);

             return ResultEntity.successWithData(pageInfoList);



      }
}
