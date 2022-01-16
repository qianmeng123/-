package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.entity.Role;
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


@Controller
public class RoleHandle {

    @Autowired
    private RoleService roleService;

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
