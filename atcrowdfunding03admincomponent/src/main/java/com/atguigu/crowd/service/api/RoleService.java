package com.atguigu.crowd.service.api;


import com.atguigu.crowd.entity.Role;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface RoleService {

    PageInfo<Role> getPageInfo(String keyWord, Integer pageNum, Integer pageSize);

    void saveRole(Role role);

    void updateRole(Role role);

    void deleteRole(List<Integer> list);
}
