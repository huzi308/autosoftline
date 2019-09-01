<#include "/include/parameters.ftl">
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.model;

import java.util.List;

public class TreeNode {

    private long id;
    private long parentId;
    private String name;
    private String url;
    private String target;
    private Boolean open;

    public TreeNode(){
    }

    public TreeNode(long id, long parentId, String name, String url, String target, Boolean open){
        this.id=id;
        this.parentId=parentId;
        this.name=name;
        this.url=url;
        this.target=target;
        this.open=open;
    }

    public long getId() {
        return id;
    }
    public void setId(long id) {
        this.id = id;
    }
    public long getParentId() {
        return parentId;
    }
    public void setParentId(long parentId) {
        this.parentId = parentId;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getUrl() {
        return url;
    }
    public void setUrl(String url) {
        this.url = url;
    }
    public String getTarget() {
        return target;
    }
    public void setTarget(String target) {
        this.target = target;
    }
    public Boolean getOpen() {
        return open;
    }
    public void setTarget(Boolean open) {
        this.open = open;
    }

}
