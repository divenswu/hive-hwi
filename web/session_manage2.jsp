<%--
/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
--%>

<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="org.apache.hadoop.hive.hwi.*" %>
<%@page errorPage="error_page.jsp" %>

<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%
	Calendar c = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	c.add(Calendar.DATE, -2);
	String datetime=sdf.format(c.getTime());

	Calendar c1 = Calendar.getInstance();
	c1.add(Calendar.DATE, -1);
	String datetime1=sdf.format(c1.getTime());

	Calendar c2 = Calendar.getInstance();
	c2.add(Calendar.DATE,0);
	String datetime2=sdf.format(c2.getTime());

	String q="alter table log.rainbow_service_log drop partition (date<'"+datetime+"')";
	String q2="alter table log.test_log drop partition (date<'"+datetime2+"')";
	String q11="alter table log.rainbow_service_log add if not exists partition (date='"+datetime+"',instance='rbt1')";
	String q12="alter table log.rainbow_service_log add if not exists partition (date='"+datetime1+"',instance='rbt1')";
	String q13="alter table log.rainbow_service_log add if not exists partition (date='"+datetime2+"',instance='rbt1')";

	String q21="alter table log.rainbow_service_log add if not exists partition (date='"+datetime+"',instance='rbt2')";
	String q22="alter table log.rainbow_service_log add if not exists partition (date='"+datetime1+"',instance='rbt2')";
	String q23="alter table log.rainbow_service_log add if not exists partition (date='"+datetime2+"',instance='rbt2')";

	String q31="alter table log.rainbow_service_log add if not exists partition (date='"+datetime+"',instance='rbt3')";
	String q32="alter table log.rainbow_service_log add if not exists partition (date='"+datetime1+"',instance='rbt3')";
	String q33="alter table log.rainbow_service_log add if not exists partition (date='"+datetime2+"',instance='rbt3')";

	String q41="alter table log.rainbow_service_log add if not exists partition (date='"+datetime+"',instance='rbt4')";
	String q42="alter table log.rainbow_service_log add if not exists partition (date='"+datetime1+"',instance='rbt4')";
	String q43="alter table log.rainbow_service_log add if not exists partition (date='"+datetime2+"',instance='rbt4')";

	String q101="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='01',instance='rbt1')";
	String q102="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='02',instance='rbt1')";
	String q103="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='03',instance='rbt1')";
	String q104="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='04',instance='rbt1')";
	String q105="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='05',instance='rbt1')";
	String q106="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='06',instance='rbt1')";
	String q107="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='07',instance='rbt1')";
	String q108="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='08',instance='rbt1')";
	String q109="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='09',instance='rbt1')";
	String q110="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='10',instance='rbt1')";
	String q111="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='11',instance='rbt1')";
	String q112="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='12',instance='rbt1')";
	String q113="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='13',instance='rbt1')";
	String q114="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='14',instance='rbt1')";
	String q115="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='15',instance='rbt1')";
	String q116="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='16',instance='rbt1')";
	String q117="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='17',instance='rbt1')";
	String q118="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='18',instance='rbt1')";
	String q119="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='19',instance='rbt1')";
	String q120="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='20',instance='rbt1')";
	String q121="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='21',instance='rbt1')";
	String q122="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='22',instance='rbt1')";
	String q123="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='23',instance='rbt1')";
	String q124="alter table log.test_log add if not exists partition (date='"+datetime2+"',time='24',instance='rbt1')";
%>

<% HWISessionManager hs = (HWISessionManager) application.getAttribute("hs"); %>

<% HWIAuth auth = (HWIAuth) session.getAttribute("auth"); %>
<% if (auth==null) { %>
<jsp:forward page="/authorize.jsp" />
<% } %>
<% String sessionName=request.getParameter("sessionName"); %>
<% HWISessionItem sess = hs.findSessionItemByName(auth,sessionName); %>
<% String message=null; %>
<%
	//String errorFile=request.getParameter("errorFile");
	String resultFile=request.getParameter("resultFile");
	//String query = request.getParameter("query");
	//String silent = request.getParameter("silent");
	String start = request.getParameter("start");

	String tablename = request.getParameter("table");
	String starttime = request.getParameter("startTime");
	String endtime = request.getParameter("endTime");
	String source = request.getParameter("source");
	String console = request.getParameter("console");
	String method = request.getParameter("method");
	String describe = request.getParameter("describe");
	String instance = request.getParameter("instance");
//

	String qq = "select * from log."+tablename;
	String queryCondition = "";
	if(tablename=="test_log") {
		if (starttime != null && starttime != "") {
			String st = "'[" + starttime + "'";
			queryCondition += " and datetime >=" + st;
			String dT=starttime.substring(0,10);
			String tT=starttime.substring(11,13);
			queryCondition += " and date =" + dT;
			queryCondition += " and time =" + tT;
		}
		if (endtime != null && endtime != "") {
			String et = "'[" + endtime + "'";
			queryCondition += " and datetime <=" + et;
		}
	}else{
	if (starttime != null && starttime != "") {
		String st = "'[" + starttime + "'";
		queryCondition += " and datetime >=" + st;
	}
	if (endtime != null && endtime != "") {
		String et = "'[" + endtime + "'";
		queryCondition += " and datetime <=" + et;
	}
	}
	if(source!=null ){
		queryCondition += " and source like '%" + source + "%'";
	}

	if(method!=null ){
		queryCondition += " and method like '%" + method + "%'";
	}
	if(describe!=null ){
		queryCondition += " and describe like '%" + describe + "%'";
	}
	if(instance!=null && instance!=""){
		String ins="'"+instance+"'";
		queryCondition += " and instance =" +ins;
	}

	if(queryCondition!=null ){
		queryCondition =" where console like '%" + console + "%'"+queryCondition+"limit 50";
		qq+=queryCondition;
	}

%>
<%

%>
<%
	if (request.getParameter("start")!=null ){
		if ( sess.getStatus()==HWISessionItem.WebSessionItemStatus.READY){
			//sess.setErrorFile(errorFile);
			sess.setResultFile(resultFile);
			sess.clearQueries();

			sess.addQuery(q101);
			sess.addQuery(q102);
			sess.addQuery(q103);
			sess.addQuery(q104);
			sess.addQuery(q105);
			sess.addQuery(q106);
			sess.addQuery(q107);
			sess.addQuery(q108);
			sess.addQuery(q109);
			sess.addQuery(q110);
			sess.addQuery(q111);
			sess.addQuery(q112);
			sess.addQuery(q113);
			sess.addQuery(q114);
			sess.addQuery(q115);
			sess.addQuery(q116);
			sess.addQuery(q117);
			sess.addQuery(q118);
			sess.addQuery(q119);
			sess.addQuery(q120);
			sess.addQuery(q121);
			sess.addQuery(q122);
			sess.addQuery(q123);
			sess.addQuery(q124);

			sess.addQuery(q11);
			sess.addQuery(q12);
			sess.addQuery(q13);

			sess.addQuery(q21);
			sess.addQuery(q22);
			sess.addQuery(q23);

			sess.addQuery(q31);
			sess.addQuery(q32);
			sess.addQuery(q33);

			sess.addQuery(q41);
			sess.addQuery(q42);
			sess.addQuery(q43);

			sess.addQuery(q);
			sess.addQuery(q2);
			sess.addQuery(qq);


//			if (silent.equalsIgnoreCase("YES") )
//				sess.setSSIsSilent(true);
//			else
//				sess.setSSIsSilent(false);

			message="Changes accepted.";
			if (start.equalsIgnoreCase("YES") ){
				sess.clientStart();
				message="Session is set to start.";
			}
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
	<title>Manage Session <%=sessionName%></title>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<script type="text/javascript" src="js/My97DatePicker/WdatePicker.js"></script>
</head>
<body style="padding-top: 60px;">
<jsp:include page="/navbar.jsp"></jsp:include>
<div class="container">
	<div class="row">
		<div class="span12">
			<h2>
				Manage Session
				<%=sessionName%></h2>

			<% if (message != null) {  %>
			<div class="alert alert-info"><%=message %></div>
			<% } %>

			<% if (sess.getStatus()==HWISessionItem.WebSessionItemStatus.QUERY_RUNNING) { %>
			<div class="alert alert-warning">还在查询中，请稍后!</div>
			<% } %>

			<% if (sess.getStatus()==HWISessionItem.WebSessionItemStatus.QUERY_RUNNING){ %>
			<%--
          View JobTracker: <a href="<%= sess.getJobTrackerURI() %>">View Job</a><br>
          Kill Command: <%= sess.getKillCommand() %>
           Session Kill: <a href="/hwi/session_kill.jsp?sessionName=<%=sessionName%>"><%=sessionName%></a><br>
          --%>
			<% } %>


			<form action="session_manage2.jsp" class="form-horizontal">
				<input type="hidden" name="sessionName" value="<%=sessionName %>">

				<fieldset>
					<legend>日志查询界面</legend>

					<div class="control-group">
					<table width="90%" border="1" cellspacing="0" align="center">

						<tr>
							<td width="44%" height="33" bgcolor="#F5F5F5">存储表名：
								<select id="fldquery1" name="table">
									<option value="rainbow_service_log" >rainbow_service_log</option>
									<option value="rainbow_conn_log">rainbow_conn_log</option>
									<option value="test_log" SELECTED="TRUE">test_log</option>
								</select>
							</td>
							<td height="45" bgcolor="#F5F5F5">日志等级：
								<select id="fldconsole1" name="console">
									<option value="INFO" SELECTED="TRUE">INFO</option>
									<option value="ERROR">ERROR</option>
									<option value="DEBUG">DEBUG</option>
									<option value="WARN">WARN</option>
								</select>
							</td>
						</tr>
						<tr>
							<td height="45" bgcolor="#F5F5F5">开始时间：
								<%--<input id="fldstarttime1"type="text" name="startTime">--%>
								<input id="fldstarttime1" class="Wdate" type="text" name="startTime" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
							</td>

							<td align="left" bgcolor="#F5F5F5">结束时间：
								<%--<input id="fldendttime1"type="text" name="endTime">--%>
								<input id="fldendttime1" class="Wdate" type="text" name="endTime" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
							</td>
						</tr>
						<tr>
							<td height="45" bgcolor="#F5F5F5">模块名称：
								<input id="fldsource1"type="text" name="source">
							</td>
							<td height="left" bgcolor="#F5F5F5">接口名称：
								<input id="fldmethod1" type="text" name="method">
							</td>
						</tr>
						<tr>
							<td height="45" bgcolor="#F5F5F5">部署主机：
								<input id="fldinstance1" type="text" name="instance">
							</td>
							<td height="left" bgcolor="#F5F5F5">日志内容：
								<input id="flddescribe1" type="text" name="describe">
							</td>
						</tr>
						<tr>
							<td height="left" bgcolor="#F5F5F5">是否查询：
								<select id="fldstart1" name="start">
									<option value="YES" SELECTED="TRUE">YES</option>
								</select>
							</td>
							<td height="45" bgcolor="#F5F5F5">查看结果：
								<select id="fldresfile1" name="resultFile">
									<option value="tmpLogFile" SELECTED="TRUE">tmpLogFile</option>
								</select>
								<% if (sess.getResultFile()!=null) { %>
								<a href="/hwi/view_file1.jsp?sessionName=<%=sessionName%>">查看结果</a>
								<% } %>
							</td>

						</tr>
					</table>
					</div>



				</fieldset>

				<% if (sess.getStatus()!=HWISessionItem.WebSessionItemStatus.QUERY_RUNNING) { %>
				<div class="form-actions">
					<button type="submit" class="btn btn-primary">查询</button>
				</div>
				<% } %>
			</form>
		</div><!-- span8 -->
	</div><!-- row -->
</div><!-- container -->
</body>
</html>
