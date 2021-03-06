<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.format" var="resformat"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.notes" var="restext"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.page_messages" var="resmessages"/>

<jsp:include page="include/managestudy_top_pages.jsp"/>

<!-- move the alert message to the sidebar-->
<jsp:include page="include/sideAlert.jsp"/>
<!-- then instructions-->
<tr id="sidebar_Instructions_open">
    <td class="sidebar_tab">

        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><span
                class="icon icon-caret-down gray"></span></a>

        <fmt:message key="instructions" bundle="${restext}"/>

        <div class="sidebar_tab_content">

            <%--            <fmt:message key="design_implement_sdv" bundle="${restext}"/>--%>

        </div>
    </td>
</tr>

<tr id="sidebar_Instructions_closed" style="display: none">
    <td class="sidebar_tab">

        <a href="javascript:leftnavExpand('sidebar_Instructions_open'); leftnavExpand('sidebar_Instructions_closed');"><span
                class="icon icon-caret-right gray"></span></a>

        <fmt:message key="instructions" bundle="${restext}"/>

    </td>
</tr>

<script>
    $(function () {
        $('#sidebar_Info_closed').css('display', 'none');
        $('#sidebar_Info_open').removeAttr('style');
    });
</script>

<jsp:include page="include/sideInfo.jsp"/>

<link rel="stylesheet" href="../includes/jmesa/jmesa.css" type="text/css">
<script type="text/JavaScript" language="JavaScript"
        src="${pageContext.request.contextPath}/includes/jmesa/jquery.min.js"></script>
<script type="text/JavaScript" language="JavaScript"
        src="${pageContext.request.contextPath}/includes/jmesa/jmesa.js"></script>
<script type="text/JavaScript" language="JavaScript"
        src="${pageContext.request.contextPath}/includes/jmesa/jquery.jmesa.js"></script>
<script type="text/javascript" language="JavaScript"
        src="${pageContext.request.contextPath}/includes/jmesa/jquery-migrate-1.4.1.js"></script>
<script type="text/javascript" language="JavaScript"
        src="${pageContext.request.contextPath}/includes/jmesa/jquery.blockUI.js"></script>
<script type="text/javascript" language="JavaScript"
        src="${pageContext.request.contextPath}/includes/permissionTagAccess.js"></script>


<%-- view all subjects starts here --%>
<script type="text/javascript">

    function onInvokeAction(id, action) {
        setExportToLimit(id, '');
        createHiddenInputFieldsForLimitAndSubmit(id);
    }

    function onInvokeExportAction(id) {
        var parameterString = createParameterStringForLimit(id);
        //location.href = '${pageContext.request.contextPath}/ViewCRF?module=manage&crfId=' + '${crf.id}&' + parameterString;
    }
</script>

</div>

<div id="box" class="dialog">
    <span id="mbm">
        <br>
        <c:if test="${(!study.status.pending)}">
            <fmt:message key="study_frozen_locked_note" bundle="${restext}"/>
        </c:if>
        
        <c:if test="${(study.status.pending)}">
            <fmt:message key="study_design_note" bundle="${restext}"/>
        </c:if>   
    </span><br>
    <div style="text-align:center; width:100%;">
        <button id="btn" onclick="hm('box');">OK</button>
    </div>
</div>

<script type="text/javascript">
    window.onload = function () {
        document.getElementById("btn").focus();
    };
</script>

<h1><span class="title_manage">
<fmt:message key="sdv_sdv_for" bundle="${resword}"/> <c:out value="${study.name}"/>
    <a href="javascript:openDocWindow('https://docs.openclinica.com/3.1/openclinica-user-guide/monitor-and-manage-data')">
        <span class=""></span></a>
</span></h1><br/>

<jsp:useBean scope='session' id='sSdvRestore' class='java.lang.String'/>
<c:set var="restore" value="true"/>
<c:if test="${sSdvRestore=='false'}"><c:set var="restore" value="false"/></c:if>

<script type="text/javascript">
    function setRedirection(formObj) {
        var params = new URLSearchParams(window.location.search);
        params.delete('redirection');
        if (!params.has('studyId'))
            params.append('studyId', '${study.studyId}');
        formObj.redirection.value = '${pageContext.request.contextPath}/pages/viewAllSubjectSDVtmp?' + params.toString();
    }

    function prompt(formObj, crfId) {
        var bool = confirm('<fmt:message key="uncheck_sdv" bundle="${resmessages}"/>');
        if (bool) {
            setRedirection(formObj);
            formObj.action = '${pageContext.request.contextPath}/pages/handleSDVRemove';
            formObj.crfId.value = crfId;
            formObj.submit();
        }
    }

    function submitSdv(formObj, crfId) {
        setRedirection(formObj);
        formObj.action = '${pageContext.request.contextPath}/pages/handleSDVGet';
        formObj.crfId.value = crfId;
        formObj.submit();
    }

</script>
<div id="subjectSDV">
    <form name='sdvForm' action="${pageContext.request.contextPath}/pages/viewAllSubjectSDVtmp">
        <input type="hidden" name="studyId" value="${param.studyId}">
        <input type="hidden" name=imagePathPrefix value="../">
        <%--This value will be set by an onclick handler associated with an SDV button --%>
        <input type="hidden" name="crfId" value="0">
        <%-- the destination JSP page after removal or adding SDV for an eventCRF --%>
        <input type="hidden" name="redirection" value="viewAllSubjectSDVtmp?sdv_restore=true&studyId=${param.studyId}">
        <%--<input type="hidden" name="decorator" value="mydecorator">--%>
        ${sdvTableAttribute}
        <br/>
        <input type="submit" name="sdvAllFormSubmit" class="button_medium"
               value="<fmt:message key="sdv_all_checked" bundle="${resword}"/>"
               onclick="this.form.method='POST';this.form.action='${pageContext.request.contextPath}/pages/handleSDVPost';this.form.submit();"/>
        <!--  <input type="submit" name="sdvAllFormCancel" class="button_medium" value="Cancel" onclick="this.form.action='${pageContext.request.contextPath}/pages/viewAllSubjectSDVtmp?sdv_restore=true&studyId=${param.studyId}';this.form.submit();"/> -->
    </form>
    <%-- <script type="text/javascript">hideCols('sdv',[2,3,6,7,11,12,13])</script> --%>

</div>
<%-- view all subjects ends here --%>

<link rel="stylesheet" href="../includes/css/icomoon-style.css">

<script>
    function store(callback) {
        if (callback)
            store.data = callback(store.data) || store.data;
        if (!store.dirty) {
            store.dirty = true;
            setTimeout(function () {
                sessionStorage.setItem(store.key, JSON.stringify(store.data));
                if (
                    store.data.ocStatusHide !== 'oc-status-removed' ||
                    store.data.datatables.some(function (state) {
                        return canReset(state)
                    }) ||
                    $('#studySubjectRecord.collapsed, #subjectEvents.collapsed, #commonEvents>.expanded').length
                )
                    $('#reset-all-filters').removeClass('invisible');
                else
                    $('#reset-all-filters').addClass('invisible');
                store.dirty = false;
            }, 1);
        }
    }

    store.key = '${study.oc_oid}.SDVs';
    store.data = JSON.parse(sessionStorage.getItem(store.key)) || {
        sdvChecks: {}
    };
    store.dirty = false;

    $('#sdv')
        .on('change', 'input[type=checkbox]', function () {
            var checkbox = $(this);
            var name = checkbox.attr('name');
            var checked = checkbox.is(':checked');
            store(function (data) {
                data.sdvChecks[name] = checked;
            });
        })
        .find('input[type=checkbox]').each(function () {
        var checkbox = $(this);
        var name = checkbox.attr('name');
        var checked = store.data.sdvChecks[name];
        if (checked)
            checkbox.attr('checked', 'checked');
        else
            checkbox.removeAttr('checked');
    });
</script>

<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css"/>
<script type="text/JavaScript" language="JavaScript"
        src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<script type="text/JavaScript" language="JavaScript"
        src="https://cdn.datatables.net/plug-ins/1.10.16/api/fnSortNeutral.js"></script>
<script type="text/JavaScript" language="JavaScript"
        src="https://cdn.datatables.net/plug-ins/1.10.16/sorting/datetime-moment.js"></script>

<style>
    #participantId {
        width: 300px;
    }

    #eventName {
        width: 300px;
    }

    #itemsdv {
        position: relative;
    }

    #sdv-items {
        clear: both;
    }

    #sdv-items th {
        font-weight: normal;
    }

    #sdv-items td {
        word-wrap: anywhere;
    }

    #sdv-items .icon::before {
        padding: 0;
        min-width: 1.45em;
    }

    #sdv-items_wrapper {
        margin: 0 10px 10px;
        overflow-y: auto;
    }

    #sdv td {
        vertical-align: middle !important;
    }

    #sdv td:last-child {
        white-space: nowrap;
    }

    #sdv-details {
        padding: 10px;
        background-color: lightgray;
        width: 100%;
    }

    #sdv-details th {
        font-weight: normal;
        text-align: left;
        padding: 5px;
        width: 150px;
    }

    #sdv-details td {
        font-weight: normal;
        text-align: left;
        border: none;
        font-weight: bold;
    }

    #sdv-show-type {
        float: right;
        padding: 10px;
        border: none;
    }

    #sdvVerify {
        margin-bottom: 10px;
        visibility: hidden;
    }

    #sdv-close-popup {
        float: right;
        position: absolute;
        right: -10px;
        top: -10px;
    }

    #sdv-close-popup > .icon-cancel::before {
        color: black;
        background-color: transparent;
    }

    .sdvCheck {
        position: relative;
        left: 3px;
    }

    .icon.icon-icon-SDV-doubleCheck {
        margin-top: 1px;
    }

    .text-left {
        text-align: left;
    }

    .text-right {
        text-align: right;
    }

    .blockOverlay {
        cursor: default !important;
    }

    .blockUI.blockMsg.blockPage {
        padding: 0 !important;
    }

    #clear-filter {
        float: left;
        margin: 5px 10px;
    }

</style>

<div id="itemsdv" style="display:none;">
    <a href="javascript:jQuery.unblockUI()" id="sdv-close-popup">
        <span class="icon icon-cancel"></span>
    </a>
    <table id="sdv-details">
        <tbody>
        <tr>
            <th>Participant ID:</th>
            <td id="participantId"></td>
            <th>Event Name:</th>
            <td id="eventName"></td>
        </tr>
        <tr>
            <th>Site ID:</th>
            <td id="siteId"></td>
            <th>Event Start Date:</th>
            <td id="eventStartDate"></td>
        </tr>
        <tr>
            <th>Form Name:</th>
            <td id="formName"></td>
            <th>SDV Requirement:</th>
            <td id="sdvRequirement"></td>
        </tr>
        <tr>
            <th>Form Status:</th>
            <td id="formStatus"></td>
            <th>SDV Status:</th>
            <td id="sdvStatus"></td>
        </tr>
        </tbody>
    </table>
    <fieldset id="sdv-show-type">
        <label>
            <input type="radio" name="sinceLastVerified" value="n" autofocus="autofocus" checked="checked"> Show all items
        </label>
        <label>
            <input type="radio" name="sinceLastVerified" value="y"> Show only changed since last Verified
        </label>
    </fieldset>

    <a id="clear-filter" href="javascript:;">Clear Filter</a>
    <table id='sdv-items' style="width:100%">
        <thead>
        <tr>
            <th>Brief Description (Item Name)</th>
            <th>Value</th>
            <th>Last Verified (UTC)</th>
            <th>Open Queries</th>
            <th>Last Modified (UTC)</th>
            <th>Modified By</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
    <input type="button" id="sdvVerify" name="sdvVerify" value="Verify">
</div>

<script>
    var itemsTable = jQuery('#sdv-items').DataTable({
        dom: 't',
        paging: false,
        columns: [
            {data: 'descName'},
            {data: 'value'},
            {data: 'lastVerifiedDate'},
            {data: 'openQueriesCount'},
            {data: 'lastModifiedDate'},
            {data: 'lastModifiedBy'},
            {data: 'actions'}
        ],
        columnDefs: [{
            targets: 0,
            className: 'text-left'
        }, {
            targets: 1,
            className: 'text-right'
        }]
    });

    function translate(str) {
        var trans = {
            'VERIFIED': 'Verified',
            'NOT_VERIFIED': 'Ready to verify',
            'CHANGED_SINCE_VERIFIED': 'Changed since verified',
            '100percent_required': '100% Required',
            'partial_required': 'Partial Required',
            'not_required': 'Not Required',
            'not_applicable': 'N/A'
        };
        return trans[str] || str;
    }

    function formatDateTime(date) {
        return moment(date).utc().format('DD-MMM-YYYY HH:mm');
    }

    function isMidnight(date) {
        return moment(date).utc().format('HHmmssSSS') === '000000000';
    }

    function calcPopupPos() {
        var winWidth = $(window).width();
        if (winWidth < 900) {
            return '0';
        }
        else if (winWidth > 1000) {
            return '50px';
        }
        else {
            var deltaWidth = winWidth - 900;
            var marginX = (deltaWidth / 2) + 'px';
            return marginX;
        }
    }

    function setPopupPos() {
        var marginX = calcPopupPos();
        $('#itemsdv').parents().css({
            left: marginX,
            right: marginX
        });
        var maxHeight = $(window).height() - $('#sdv-items_wrapper').position().top - 130;
        if ($('#sdv-items').height() > maxHeight) {
            $('#sdv-items_wrapper').css('height', maxHeight + 'px');
        }
        else {
            $('#sdv-items_wrapper').css('height', $('#sdv-items').height() + 30 + 'px');
        }
    }

    $('#sdv').on('click', '.popupSdv', function () {
        var popupIndex = $('#sdv button.popupSdv').index(this);
        var data = $(this).data();
        clearFilter();
        var url = 'auth/api/sdv/studies/' + data.studyOid + '/events/' + data.eventOid + '/occurrences/' + data.eventOrdinal + '/forms/' + data.formOid + '/participants/' + data.participantId + '/sdvItems';

        function getItems() {
            var sinceLastVerified = $('#sdv-show-type input:checked').val();
            $.get(url + '?changedAfterSdvOnlyFilter=' + sinceLastVerified, function (data) {

                $('#participantId').text(data.participantId);
                if (data.repeatingEvent) {
                    $('#eventName').text(data.eventName + ' (' + data.eventOrdinal + ')');
                } else {
                    $('#eventName').text(data.eventName);
                }
                $('#formName').text(data.formName);
                $('#sdvRequirement').text(translate(data.sdvRequirement));
                $('#siteId').text(data.siteId);
                $('#eventStartDate').text(data.eventStartDate);
                $('#formStatus').text(data.formStatus);
                $('#sdvStatus').text(translate(data.sdvStatus));

                itemsTable.rows.add(data.sdvItems.map(function (item) {
                    item.descName = (item.briefDescription || item.label || '') + ' (' + item.name + ')';
                    if (item.repeatingGroup) {
                        item.descName += ' (' + item.ordinal + ')';
                    }

                    item.lastVerifiedDate = data.lastVerifiedDate;
                    if (item.sdvStatus == 'CHANGED_SINCE_VERIFIED') {
                        item.value += '&nbsp; <img src="../images/changed_since_verified.png" width="16" title="<fmt:message key="value_changed_since_last_verified" bundle="${resword}"/>">';
                    }
                    if (item.lastVerifiedDate) {
                        item.lastVerifiedDate = formatDateTime(item.lastVerifiedDate);
                    }
                    else if (data.sdvStatus === 'NOT_VERIFIED') {
                        item.lastVerifiedDate = 'Never';
                    }
                    else {
                        item.lastVerifiedDate = '';
                    }

                    var legacyItem = isMidnight(item.lastModifiedDate);
                    item.lastModifiedDate = formatDateTime(item.lastModifiedDate);
                    if (legacyItem) { // don't display the time component
                        item.lastModifiedDate = item.lastModifiedDate.split(' ')[0];
                    }
                    item.lastModifiedBy = item.lastModifiedUserFirstName + ' ' + item.lastModifiedUserLastName;

                    item.actions = '';
                    if (!item.calculateItem)
                        item.actions =
                            '<a title="<fmt:message key="view_form" bundle="${resword}"/>" class="icon icon-view-within" href="../ResolveDiscrepancy' +
                            '?itemDataId=' + item.itemDataId +
                            '&popupIndex=' + popupIndex +
                            '"></a>';

                    return item;
                }));
                itemsTable.draw();
                
                setTimeout(setPopupPos, 1);
            });
        }

        $('#sdvVerify').css('visibility', data.sdvStatus === 'VERIFIED' ? 'hidden' : 'visible');

        $('#sdv-show-type').off('change');
        if (data.sdvStatus === 'CHANGED_SINCE_VERIFIED') {
            $('#sdv-show-type input[value=y]').click();
        } else {
            $('#sdv-show-type input[value=n]').click();
        }

        $('#sdv-show-type').change(function () {
            itemsTable.clear().draw();
            getItems();
        }).change();

        function clearFilter() {
            jQuery('#sdv-items').dataTable().fnSortNeutral();
            if (data.sdvStatus === 'CHANGED_SINCE_VERIFIED') {
                $('#sdv-show-type input[value=y]').click();
            } else {
                $('#sdv-show-type input[value=n]').click();
        }
        }
        $('#clear-filter').click(function (){
                clearFilter();
        });

        var verifyButton = $(this).siblings('[name=sdvVerify]');
        $('#sdvVerify').off('click').click(function () {
            $(verifyButton).click();
        });

        jQuery.blockUI({
            message: jQuery('#itemsdv'), css: {
                cursor: 'default',
                top: '40px',
                left: calcPopupPos(),
                right: calcPopupPos()
            }
        });
        setTimeout(setPopupPos, 1);
    });

    function adjustFilterTexOverflow() {
        limitFilterWidth('110px', 'SDV Status');
        limitFilterWidth('110px', 'SDV Requirement');
        limitFilterWidth('120px', 'CRF Status');
    }

    function limitFilterWidth(width, columnTitle) {
        var sdvTableHeaders = $('#sdv > thead').children();
        var sdvtColumnTitles = sdvTableHeaders.filter('.header').children();
        var sdvtFilterBoxes = sdvTableHeaders.filter('.filter').children();
        var colIndex = sdvtColumnTitles.find(':contains(' + columnTitle + ')').closest('td').index();
        var theFilterBox = sdvtFilterBoxes.eq(colIndex).children();
        if(theFilterBox.children().length > 0){
                   theFilterBox.children().contents().unwrap();
        }
        theFilterBox.wrapInner('<div style="width:' + width + '; overflow:hidden; text-overflow:ellipsis;">');
        theFilterBox.attr('title', theFilterBox.text());
    }
    adjustFilterTexOverflow();
    $('.dynFilter').mouseleave(function () {
        adjustFilterTexOverflow();
    });

    $(window).resize(setPopupPos);

    var popupIndex = new URLSearchParams(location.search).get('popupIndex');
    if (popupIndex) {
        $(function() {
            setTimeout(function() {
                $('#sdv button.popupSdv').eq(popupIndex).click();
            }, 1);
        });
    }

</script>
