<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>    
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>    
<html>
  <head>
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="this is my page">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="<%=basePath %>resources/easyui1.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="<%=basePath %>resources/easyui1.4/themes/default/easyui.css">
	<script type="text/javascript" src="<%=basePath %>resources/easyui1.4/jquery.min.js"></script>
	<script type="text/javascript" src="<%=basePath %>resources/easyui1.4/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="<%=basePath %>resources/easyui1.4/locale/easyui-lang-zh_CN.js"></script>
	</head>
<body class="easyui-layout"  style="margin: 0px; padding: 0px">

    <table id="tabelist1"  class="easyui-datagrid" title="凭证查看" rownumbers="true" striped="true" pagination="true" fit=true
     sortName="id" sortOrder="desc"
    		 data-options="
    		 	iconCls:'icon-search',
    		 	closable:false,
                fitColumns: true,
                singleSelect: true,
                rownumbers: true,
                showFooter: true,
                toolbar:'#tb'">  
        <thead>  
            <tr>
				<th field="docName" width="10" sortable="true">凭证名称</th>
				<th field="subject" width="10" sortable="true">所属科目</th>
				<th field="money" width="10" sortable="true">发生金额</th>
				<th field="lendType" width="10" formatter="lendDesc" sortable="true">收/支</th>
				<th field="recordUser" width="10" sortable="true">记账人</th>
				<th field="userName" width="10" sortable="true">填报人员</th>
				<th field="orgName" width="15" sortable="true">所属机构</th>
				<th field="recordTime" width="15" sortable="true">录入时间</th>
				<th field="fileType" width="10" formatter="filePreView">文件预览</th>
				<th field="status" width="10" formatter="docStatusDesc" sortable="true">提交状态</th>
			</tr>  
        </thead>  
    </table> 



<div id="tb" style="padding:5px;height:auto">
 <form id="from1">
	 	<div style="margin-bottom:5px">  
	 	          凭证名称:<input id="docName" style="width:150px">
	 	          记账人&nbsp:<input id="recordUser" style="width:150px">
	 	         科目类型: <select id="subject" name="subject" panelHeight="auto" style="width:100px">  
            			<option value="" />--请选择--</option>
							<s:iterator id="map" value="#request.docSubjectList" status="sta">  
							 	<option value='<s:property value="#map['id']"/>'>
									<s:property value="#map['subject']" />
								</option>
							</s:iterator>
            	</select>
            	<s:if test="#request.orgList.size()!= 0">  
  
 				 	    组织机构 : <select id="orgId" name="orgId" panelHeight="auto" style="width:100px">  
            			<option value="" />--请选择--</option>
							<s:iterator id="map" value="#request.orgList" status="sta">  
							 	<option value='<s:property value="#map['orgId']"/>'>
									<s:property value="#map['orgName']" />
								</option>
							</s:iterator>
            	</select>
            	</s:if>
        </div>
       <div style="margin-bottom:5px" >  
       		开始时间:<input id="recordTimeBegin" class="easyui-datebox"  style="width:150px">
           	截止时间:<input id="recordTimeEnd" class="easyui-datebox"  style="width:150px"> 
           	收支类型: <select id="lendType" name="lendType" panelHeight="auto" style="width:100px">  
            			<option value="" />--请选择--</option>
            			<option value="1" />--收入--</option>
            			<option value="2" />--支出--</option>
            	</select>
     	 审核状态 : <select id="docstatus" name="docstatus" panelHeight="auto" style="width:100px">  
						<option value="" />--请选择--</option>
            			<option value="1" />--未提交--</option>
            			<option value="2" />--待审核--</option>
            			<option value="3" />--审核办结--</option>
            	</select>	
            	
            <a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="query()">查询</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-clear" onclick="clearForm()">清除</a>   
        </div>  
</form>        
</div>
    <div id="uploadWin1" class="easyui-window" title="原始凭证" 
    data-options="modal:true,closed:true,iconCls:'icon-save',onClose:refeach"
     style="width:680px;height:500px;padding:1px;">
	<iframe name="main"  id="main"  width="100%"
					height="100%" marginwidth=0 marginheight=0 frameborder=0 scrolling="no"></iframe>
    </div> 
</body>	
<script type="text/javascript">

$(document).ready(function(){
	initDataGrid();
});

function closeWin(){
	$('#uploadWin1').window('close');
}

function refeach(){
	$('#tabelist1').datagrid('reload');
}

function fileUpload(value,row,index){
	return "<a class='ll_button' onclick='uploadWin(\""+row.docId+"\");' href='javascript:void(0);'>文件上传</a>";   
}
function filePreView(value,row,index){
	arrys = row.fileType;
	if(arrys!="" && typeof(arrys)!='undefined'&&arrys!=null)
	{
		 return "<a class='ll_button' onclick='prewViewWin(\""+row.docId+"\");' href='javascript:void(0);'>文件预览</a>";   	
	}	
	return "";  
}

function uploadWin(value){
	var action = '<%=basePath%>upload1/doUploadFile.action?param.docId='+value;
	$('iframe').attr("src",action);
	$('#uploadWin1').window('open');
}

function prewViewWin(value){
	var action = '<%=basePath%>upload1/doPreViewFile.action?param.docId='+value;
	$('iframe').attr("src",action);
	$('#uploadWin1').window('open');
}

function query(){
	var docName = $('#docName').val();
	var recordUser =  $('#recordUser').val();
	var subject = $('#subject').val();
	var orgId = $('#orgId').val();
	var lendType = $('#lendType').val();
	var docstatus = $('#docstatus').val();
	
	var recordTimeBegin = $('#recordTimeBegin').datebox('getValue');
	var recordTimeEnd = $('#recordTimeEnd').datebox('getValue');
	$('#tabelist1').datagrid({
		url:'./manager/queryDocInfoByLeftJoin.action',
		queryParams:{
	    	'param.docName':docName,
	    	'param.orgId':orgId,
	    	'param.recordUser':recordUser,
	    	'param.subject':subject,
	    	'param.lendType':lendType,
	    	'param.status':docstatus,
	    	'param.recordTimeBegin':recordTimeBegin,
	    	'param.recordTimeEnd':recordTimeEnd
    	}
  	});

	
}
function clearForm(){
    $('#from1').form('clear');
}

initDataGrid = function(){
	query();
};

lendDesc= function(value,row,index){
	var value = row.lendType;
	if(value=='1'){
		return "收入";
	}
	if(value=='2'){
		return "支出";
	}
	
}
docStatusDesc= function(value,row,index){
	var value = row.status;
	if(value=='1'){
		var span = "<span style='color:blue'>未提交</span>";
		return span;
	}
	if(value=='2'){
		var span = "<span style='color:red'>待审核</span>";
		return span;
	}
	if(value=='3'){
		var span = "<span ><strong>审核办结</strong></span>";
		return span;
	}
	
}
</script>
</html>