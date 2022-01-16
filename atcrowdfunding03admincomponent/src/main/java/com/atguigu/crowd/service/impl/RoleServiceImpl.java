package com.atguigu.crowd.service.impl;

import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.entity.RoleExample;
import com.atguigu.crowd.entity.RoleExample.Criteria;
import com.atguigu.crowd.mapper.RoleMapper;
import com.atguigu.crowd.service.api.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    private RoleMapper roleMapper;

    @Override
    public void deleteRole(List<Integer> list) {
        RoleExample roleExample=new RoleExample();
            Criteria criteria =roleExample.createCriteria();
             criteria.andIdIn(list);
     roleMapper.deleteByExample(roleExample);
    }

    @Override
    public void updateRole(Role role) {
        roleMapper.updateByPrimaryKey(role);
    }

    @Override
    public void saveRole(Role role) {
        roleMapper.insert(role);
    }

    @Override
    public PageInfo<Role> getPageInfo(String keyWord, Integer pageNum, Integer pageSize) {

                 PageHelper.startPage(pageNum,pageSize);

                 List<Role> roleList=roleMapper.selectRolePageBykeyword(keyWord);

                 PageInfo<Role> pageInfo=new PageInfo(roleList);

        return pageInfo;
    }
}
