package com.atguigu.crowd.service.impl;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.AdminExample;
import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.exception.LoginFailedException;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.mapper.RoleMapper;
import com.atguigu.crowd.service.api.AdminService;
import com.atguigu.crowd.util.CrowdUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.atguigu.crowd.entity.AdminExample.Criteria;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private RoleMapper roleMapper;

    /**
     * 分页分配的更换
     * @param adminId
     * @param roleIdList
     */
    @Override
    public void saveInnerRoleAndAdmin(Integer adminId, List<Integer> roleIdList) {

         roleMapper.removeInnerRoleAndAdmin(adminId);

         if (roleIdList!=null&&roleIdList.size()!=0){
             roleMapper.saveInnerRoleAndAdmin(adminId,roleIdList);
         }
    }

    /**
     * 分配页面显示
     * @param adminId
     * @return
     */
    @Override
    public Map<String,List<Role>> getRoleAndAdmin(Integer adminId) {
           List<Role> distributeRoleList=roleMapper.getdistribute(adminId);
           List<Role> noDistributeRoleList=roleMapper.getNoDistribute(adminId);
             Map<String,List<Role>> map=new HashMap<>();
             map.put("distribute",distributeRoleList);
          map.put("noDistribute",noDistributeRoleList);

        return map;
    }

    /**
     * 修改
     */
    @Override
    public void editAdmin(Admin admin) {
      adminMapper.updateByPrimaryKeySelective(admin);
    }

    /**
     * 页面的赋值
     * @param adminId
     */
    @Override
    public Admin edtaAdmind(Integer adminId) {
           Admin admin=adminMapper.selectByPrimaryKey(adminId);
           return admin;
    }

    /**
     *新增
     */
    @Override
    public void addAdmin(Admin admin) {
        Date data=new Date();
        SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String createTime=format.format(data);
        admin.setCreateTime(createTime);
                   String md5PassWord=CrowdUtil.md5(admin.getUserPswd());
                   admin.setUserPswd(md5PassWord);

        adminMapper.insert(admin);
    }

    /**
     * 删除
     */
    @Override
    public void remove(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    /**
     * 分页查询
     * @param index
     * @param pageSize
     * @param queryCon
     * @return
     */
    @Override
    public PageInfo<Admin> quertPage(Integer index, Integer pageSize, String queryCon) {
// 1.开启分页功能
            PageHelper.startPage(index, pageSize);
// 2.查询 Admin 数据
            List<Admin> adminList = adminMapper.selectPageAndCon(queryCon);
// ※辅助代码：打印 adminList 的全类名
            Logger logger = LoggerFactory.getLogger(AdminServiceImpl.class);
            logger.debug("adminList 的全类名是："+adminList.getClass().getName());
// 3.为了方便页面使用将 adminList 封装为 PageInfo
            PageInfo<Admin> pageInfo = new PageInfo<>(adminList);
            return pageInfo;
        }

    /**
     * 管理员登陆账号密码正确与否的逻辑判断
     * @param text 账号
     * @param password 密码
     * @return
     */
    public Admin getAdminByLoginAcct(String text, String password) {

          if (text==null||"".equals(text)){
              throw new RuntimeException("请不要输入空字符串");
          }

          //获取AdminExample对象
            AdminExample adminExample = new AdminExample();

            //获取Criteria对象
          Criteria criteria = adminExample.createCriteria();

            //封装查询条件
        criteria.andLoginAcctEqualTo(text);

            List<Admin> list = adminMapper.selectByExample(adminExample);

            if (list==null||list.size()==0){
                throw new LoginFailedException("账号错误");
            }

            if (list.size()>1){
               throw new RuntimeException("数据异常");
            }

               Admin admin=list.get(0);

                   String daoPassWord=admin.getUserPswd();

                   String formMd5= CrowdUtil.md5(password);

                   if (!Objects.equals(daoPassWord,formMd5)){
                       throw new LoginFailedException("密码错误");
                   }


            return admin;
    }







    public void saveAdmin(Admin admin) {
        adminMapper.insert(admin);
        throw new RuntimeException();
    }

    public List<Admin> getAll() {
        return adminMapper.selectByExample(new AdminExample());

    }
}
