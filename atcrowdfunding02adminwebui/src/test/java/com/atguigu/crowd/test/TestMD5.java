package com.atguigu.crowd.test;

import com.atguigu.crowd.util.CrowdUtil;
import org.junit.Test;

public class TestMD5 {

    @Test
    public void testMD5(){
           String a=CrowdUtil.md5("123");
        System.out.println(a);
    }
}
