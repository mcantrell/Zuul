<%--@elvariable id="keys" type="java.util.List<org.devnull.zuul.data.model.EncryptionKey>"--%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Key Management</title>
    <meta name="tab" content="admin"/>
    <script src="${pageContext.request.contextPath}/assets/ext/binder-0.3.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/system-keys.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/json-form.js"></script>
</head>
<body>
<div class="row">
    <div class="span12">
        <div class="page-header">
            <h1>Key Management</h1>
        </div>
    </div>
</div>
<div class="row">
    <div class="span12">
        <table id="keysTable" class="table table-bordered table-condensed">
            <thead>
            <tr>
                <th>Actions</th>
                <th>Name</th>
                <th>Description</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="key" items="${keys}">
                <tr data-key-name="${fn:escapeXml(key.name)}">
                    <td>
                        <c:choose>
                            <c:when test="${key.defaultKey}">
                                <c:set var="buttonClass" value="btn-primary"/>
                                <c:set var="iconClass" value="icon-check icon-white"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="buttonClass" value=""/>
                                <c:set var="iconClass" value="icon-ok"/>
                            </c:otherwise>
                        </c:choose>

                        <div class="btn-group">
                            <button class="btn ${buttonClass} edit-key-action">
                                <i class="${iconClass}"></i>
                                Edit
                            </button>
                            <button class="btn ${buttonClass} dropdown-toggle" data-toggle="dropdown">
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a href="#" class="default-key-action">Set Default</a></li>
                                <li class="divider"></li>
                                <li><a href="#" class="delete-key-action">Delete</a></li>
                            </ul>
                        </div>
                    </td>
                    <td class="key-name">${fn:escapeXml(key.name)}</td>
                    <td class="key-description">${fn:escapeXml(key.description)}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<div class="modal hide" id="editEntryDialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3>Edit Entry</h3>
    </div>
    <div class="modal-body">
        <form id="editEntryForm" action="${pageContext.request.contextPath}/system/keys"
              onsubmit="return false;" method="PUT" class="form-horizontal">
            <fieldset>
                <div class="control-group">
                    <label class="control-label" for="keyName">Name</label>

                    <div class="controls">
                        <input id="keyName" name="name" class="span3" type="text" disabled>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="description">Description</label>

                    <div class="controls">
                        <input id="description" name="description" class="span3" type="text">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="password">Password</label>

                    <div class="controls">
                        <input id="password" name="password" class="span3" type="password">
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn btn-danger pull-left">Delete</a>
        <a href="#" class="btn" data-dismiss="modal">Cancel</a>
        <a href="#" class="btn btn-primary">Save changes</a>
    </div>
</div>
</body>
</html>