package com.atguigu.crowd.mvc.handler;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.service.api.AdminService;
import com.atguigu.crowd.util.CrowdUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class TestHandle {

    private  Logger logger= LoggerFactory.getLogger(TestHandle.class);

    @Autowired
    private AdminService adminService;




    @RequestMapping("/test/ssm.html")
    public String testSsm(ModelMap modelMap,HttpServletRequest request){
        logger.info("testSsm="+CrowdUtil.judgeRequestType(request));
        System.out.println("testSsm="+CrowdUtil.judgeRequestType(request));
        List<Admin> adminList=adminService.getAll();

        modelMap.addAttribute("adminList",adminList);

        System.out.println(adminService);

        System.out.println(10/0);

        return "target";
    }

    @RequestMapping("/test/arr.html")
    @ResponseBody
    public String testarr(@RequestBody List<Integer> arrJson, HttpServletRequest request){

        logger.info("testArr="+CrowdUtil.judgeRequestType(request));
        for (Integer num:arrJson
             ) {
            logger.info("num="+num);

        }
        return "success";
    }

}
