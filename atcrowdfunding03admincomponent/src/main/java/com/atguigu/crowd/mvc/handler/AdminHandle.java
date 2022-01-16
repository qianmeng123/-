package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.service.api.AdminService;;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
public class AdminHandle {

    @Autowired
    private AdminService adminService;

    @RequestMapping("/admin/do/assign.html")
    public String assign(Integer adminId,Integer pageNum,@RequestParam(value = "roleIdList",required = false) List<Integer> roleIdList){

        adminService.saveInnerRoleAndAdmin(adminId,roleIdList);

        return "redirect:/admin/do/page.html?pageNum="+pageNum;

    }

    /**
     * 分配初始页面
     * @param adminId
     * @param pageNum
     * @return
     */
       @RequestMapping("/admin/to/assignRole.html")
      public ModelAndView assignRole(Integer adminId,Integer pageNum){
                Map<String,List<Role>> map=adminService.getRoleAndAdmin(adminId);
                  ModelAndView mv=new ModelAndView();
                  mv.addObject("distribute",map.get("distribute"));
                 mv.addObject("noDistribute",map.get("noDistribute"));
                 mv.addObject("pageNum",pageNum);
             mv.addObject("adminId",adminId);
               mv.setViewName("admin-assignRole");

               return mv;

      }

    /**
     * 修改
      */
     @RequestMapping("admin/to/updata.html")
    public String updata(Integer pageNum,Admin admin){
          adminService.editAdmin(admin);
         return  "redirect:/admin/do/page.html?pageNum="+pageNum+"";
     }


    /**
     * 页面的赋值
      */
      @RequestMapping("/admin/to/edit.html")
      public String adminId(Integer adminId,Model model){
             Admin admin=adminService.edtaAdmind(adminId);
              model.addAttribute("admin",admin);
             return "admin-edit";
      }

    /**
     * 新增
     */
    @RequestMapping("/admin/do/add.html")
    public String addAdmin(Admin admin){
                adminService.addAdmin(admin);

                return "redirect:/admin/do/page.html?pageNum="+Integer.MAX_VALUE+"";
    }

    /**
     * 删除
     */
    @RequestMapping("admin/remove/{id}/{pageNum}/{queryCon}.html")
    public String removeAdmin(
            @PathVariable("id") Integer id,
            @PathVariable("pageNum") Integer pageNum,
            @PathVariable("queryCon") String queryCon

    ){
        adminService.remove(id);

        return  "redirect:/admin/do/page.html?pageNum="+pageNum+"&queryCon="+queryCon+"";

    }

    /**
     * 分页查询
     * @param pageSize 每页的数据
     * @param queryCon 查询条件
     */
    @RequestMapping("/admin/do/page.html")
    public String doPage(
                      @RequestParam(value = "pageSize",defaultValue = "10") Integer  pageSize,
                      @RequestParam(value = "pageNum",defaultValue = "1") Integer pageNum,
                       @RequestParam(value = "queryCon",defaultValue ="") String queryCon,
                       Model modelMap
                     ){

        // 查询得到分页数据
        PageInfo<Admin> pageInfo = adminService.quertPage(pageNum,pageSize,queryCon);
// 将分页数据存入模型
        modelMap.addAttribute("pageInfo", pageInfo);
        return "admin-user";

    }


    /**
     * 退出登陆的请求
     * @param session
     * @return 返回到登陆页面
     */
    @RequestMapping("/admin/to/logout.html")
    public String doLogout(HttpSession session){
           //强制session失效
            session.invalidate();

            return "redirect:/admin/to/login.html";
       }

    /**
     * 管理员登录账号密码的判断
     * @param text 账号
     * @param password  密码
     * @param session
     * @return 管理员主界面
     */
    @RequestMapping("/admin/do/login.html")
    public String doLogin(String text, String password, HttpSession session){
            Admin admin=adminService.getAdminByLoginAcct(text,password);
                  session.setAttribute("admin",admin);
                  return "redirect:/admin/to/admin.html";
                  
    }

}
