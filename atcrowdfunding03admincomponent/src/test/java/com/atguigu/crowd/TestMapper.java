package com.atguigu.crowd;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.AdminExample;
import com.atguigu.crowd.mapper.AdminMapper;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class TestMapper {

    @Autowired
    private AdminMapper adminMapper;

    @Test
    public void testCount(){


        List<Admin> listAdmin=adminMapper.selectPageAndCon("");

        for (Admin a :
          listAdmin) {
            System.out.println(a.toString());
        }

    }
}
