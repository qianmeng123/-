package com.atguigu.crowd.service.api;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.Role;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

public interface AdminService {
    void saveAdmin(Admin admin);

    List<Admin> getAll();

    Admin getAdminByLoginAcct(String text, String password);

    PageInfo<Admin> quertPage(Integer index, Integer pageSize, String queryCon);

    void remove(Integer id);

    void addAdmin(Admin admin);

    Admin edtaAdmind(Integer adminId);

    void editAdmin(Admin admin);

    Map<String,List<Role>> getRoleAndAdmin(Integer adminId);

    void saveInnerRoleAndAdmin(Integer adminId, List<Integer> roleIdList);
}
