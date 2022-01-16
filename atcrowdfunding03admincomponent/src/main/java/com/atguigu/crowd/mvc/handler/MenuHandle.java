package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.entity.Menu;
import com.atguigu.crowd.service.api.MenuService;
import com.atguigu.crowd.util.ResultEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class MenuHandle {
    @Autowired
    private MenuService menuService;

    /**
     * 删除
     */
    @RequestMapping("/admin/menu/remove.json")
    @ResponseBody
    public ResultEntity<String> removeMenu(Integer id){
      menuService.removeMenu(id);
      return ResultEntity.successWithoutData();
    }

    /**
     * 修改
     */
    @RequestMapping("/admin/menu/edit.json")
    @ResponseBody
    public ResultEntity<String> editMenu(Menu menu){
             menuService.editMenu(menu);
             return ResultEntity.successWithoutData();
    }




    /**
     * 添加
     * @return
     */
     @ResponseBody
     @RequestMapping("/admin/menu/add.json")
     public ResultEntity<String> addMenu(Menu menu){
              menuService.addMenu(menu);
              return ResultEntity.successWithoutData();
     }


     /**
      * 展现页面
      */
     @RequestMapping("/admin/do/menu.json")
    @ResponseBody
    public ResultEntity<Menu> menuTree(){

        List<Menu> menuList=menuService.getAll();

          //根节点对象
          Menu root=null;

          //Menu节点和id的对应关系
        Map<Integer,Menu> menuMap=new HashMap<>();

         //填充menuMap
        for (Menu menu:menuList
             ) {
                Integer id=menu.getId();
                menuMap.put(id,menu);
        }


          //找到根节点
        for (Menu menu: menuList) {

               if(menu.getPid()==null){
                   root=menu;
                   continue;
               }
                   Integer fatherId=menu.getPid();

                     Menu menuFather=menuMap.get(fatherId);

                     menuFather.getChildren().add(menu);

        }

        return ResultEntity.successWithData(root);

    }
}
