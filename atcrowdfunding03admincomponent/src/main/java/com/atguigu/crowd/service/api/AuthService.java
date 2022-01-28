package com.atguigu.crowd.service.api;

import com.atguigu.crowd.entity.Auth;

import java.util.List;
import java.util.Map;

public interface AuthService {
    List<Auth> getAllAuth();

    List<Integer> getAuthId(Integer roleId);

    void saveAuth(Map<String, List<Integer>> map);
}
