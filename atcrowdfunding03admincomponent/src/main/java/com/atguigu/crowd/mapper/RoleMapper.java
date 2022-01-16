package com.atguigu.crowd.mapper;

import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.entity.RoleExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;

public interface RoleMapper {
    int countByExample(RoleExample example);

    int deleteByExample(RoleExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Role record);

    int insertSelective(Role record);

    List<Role> selectByExample(RoleExample example);

    Role selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Role record, @Param("example") RoleExample example);

    int updateByExample(@Param("record") Role record, @Param("example") RoleExample example);

    int updateByPrimaryKeySelective(Role record);

    int updateByPrimaryKey(Role record);

    //分页和模糊查询
    List<Role> selectRolePageBykeyword(String keyWord);

    List<Role> getdistribute(Integer adminId);

    List<Role> getNoDistribute(Integer adminId);

    void removeInnerRoleAndAdmin(Integer adminId);

    void saveInnerRoleAndAdmin(@Param("adminId") Integer adminId,@Param("roleIdList") List<Integer> roleIdList);
}