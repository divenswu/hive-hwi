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
<% HWISessionManager hs = (HWISessionManager) application.getAttribute("hs");; %>

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


	String qq = "select * from log."+tablename;
	String queryCondition = "";
	if(starttime!=null ){
		String st="["+starttime;
		queryCondition += " and datatime >= " +st;
    }
	if(endtime!=null ){
		String et="["+endtime;
		queryCondition += " and datatime <= " +et;
	}
	if(source!=null ){
		queryCondition += " and source like '%" + source + "%'";
	}

	if(method!=null ){
		queryCondition += " and method like '%" + method + "%'";
	}
	if(queryCondition!=null ){
		queryCondition =" where console like '%" + console + "%'"+queryCondition;
		qq+=queryCondition;
	}

%>
<%
	if (request.getParameter("start")!=null ){
		if ( sess.getStatus()==HWISessionItem.WebSessionItemStatus.READY){
			//sess.setErrorFile(errorFile);
			sess.setResultFile(resultFile);
			sess.clearQueries();

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
			<div class="alert alert-warning">Session is in QUERY_RUNNING
				state. Changes are not possible!</div>
			<% } %>

			<% if (sess.getStatus()==HWISessionItem.WebSessionItemStatus.QUERY_RUNNING){ %>
			<%--
          View JobTracker: <a href="<%= sess.getJobTrackerURI() %>">View Job</a><br>
          Kill Command: <%= sess.getKillCommand() %>
           Session Kill: <a href="/hwi/session_kill.jsp?sessionName=<%=sessionName%>"><%=sessionName%></a><br>
          --%>
			<% } %>

			<div class="btn-group">
				<a class="btn" href="/hwi/session_history.jsp?sessionName=<%=sessionName%>"><i class="icon-book"></i> History</a>
				<a class="btn" href="/hwi/session_diagnostics.jsp?sessionName=<%=sessionName%>"><i class="icon-cog"></i> Diagnostics</a>
				<a class="btn"href="/hwi/session_remove.jsp?sessionName=<%=sessionName%>"><i class="icon-remove"></i> Remove</a>
				<a class="btn"href="/hwi/session_result.jsp?sessionName=<%=sessionName%>"><i class=" icon-download-alt"></i> Result Bucket</a>
			</div>

			<form action="session_manage1.jsp" class="form-horizontal">
				<input type="hidden" name="sessionName" value="<%=sessionName %>">

				<fieldset>
					<legend>Session Details	</legend>
					<div class="control-group">
						<label class="control-label" for="fldresfile">Result File</label>
						<div class="controls">
							<select id="fldresfile" name="resultFile">
								<option value="tmpLogFile" SELECTED="TRUE">tmpLogFile</option>
							</select>
							<% if (sess.getResultFile()!=null) { %>
							<a href="/hwi/view_file1.jsp?sessionName=<%=sessionName%>">查看结果</a>
							<% } %>
						</div>
					</div>



					<div class="control-group">
						<label class="control-label" for="fldquery">Table Name</label>
						<div class="controls">
							<select id="fldquery" name="table">
								<option value="rainbow_service_log" SELECTED="TRUE">rainbow_service_log</option>
								<option value="rainbow_conn_log">rainbow_conn_log</option>
							</select>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label" for="fldstarttime">开始时间</label>
						<div class="controls">
							<input id="fldstarttime"type="text" name="startTime">
						</div>
						<label class="control-label" for="fldendttime">结束时间</label>
						<div class="controls">
							<input id="fldendttime"type="text" name="endTime">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="fldsource">日志来源</label>
						<div class="controls">
							<input id="fldsource"type="text" name="source">
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="fldconsole">日志等级</label>
						<div class="controls">
							<select id="fldconsole" name="console">
								<option value="INFO" SELECTED="TRUE">INFO</option>
								<option value="DEBUG">DEBUG</option>
							</select>
						</div>
					</div>

					<div class="control-group">
						<label class="control-label" for="fldmethod">产生日志的方法</label>
						<div class="controls">
							<input id="fldmethod" type="text" name="method">
						</div>
					</div>



					<div class="control-group">
						<label class="control-label" for="fldstart">是否查询</label>
						<div class="controls">
							<select id="fldstart" name="start">
								<option value="YES" SELECTED="TRUE">YES</option>
							</select>
						</div>
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
