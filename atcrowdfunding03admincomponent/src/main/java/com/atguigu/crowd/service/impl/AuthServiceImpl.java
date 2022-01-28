package com.atguigu.crowd.service.impl;

import com.atguigu.crowd.entity.Auth;
import com.atguigu.crowd.entity.AuthExample;
import com.atguigu.crowd.mapper.AuthMapper;
import com.atguigu.crowd.service.api.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AuthServiceImpl implements AuthService {
    @Autowired
     private AuthMapper authMapper;

    @Override
    public void saveAuth(Map<String, List<Integer>> map) {
        List<Integer> authIdList = map.get("authId");
        Integer roleId = map.get("roleId").get(0);
        authMapper.deleteOldRole(roleId);
        if (authIdList!=null&&authIdList.size()!=0) {
            authMapper.saveAuthAndRole(authIdList, roleId);
        }
    }

    @Override
    public List<Integer> getAuthId(Integer roleId) {
      return authMapper.selectAuthIdByRoleId(roleId);
    }

    @Override
    public List<Auth> getAllAuth() {
        return authMapper.selectByExample(new AuthExample());
    }
}
