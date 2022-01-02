package com.atguigu.crowd.test;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.service.api.AdminService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import javax.xml.ws.Service;
import java.sql.Connection;
import java.sql.SQLException;

// 指定 Spring 给 Junit 提供的运行器类
@RunWith(SpringJUnit4ClassRunner.class)
// 加载 Spring 配置文件的注解
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml","classpath:spring-persist-tx.xml"})
public class CrowdSpringTest {
    @Autowired
    private DataSource dataSource;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private AdminService adminService;

    @Test
    public void testDataSource() throws SQLException {
// 1.通过数据源对象获取数据源连接
        Connection connection = dataSource.getConnection();
// 2.打印数据库连接
        System.out.println(connection);
    }

    @Test
    public void testAdminMapperAutowired() {
        Admin admin =new Admin(null,"Tom","123123","汤姆","156@qq.com",null);

         int count=adminMapper.insert(admin);
        System.out.println(count);
    }

    @Test
    public void testTx(){
        Admin admin =new Admin(null,"Tom","123123","汤姆","156@qq.com",null);
           adminService.saveAdmin(admin);
    }

}
